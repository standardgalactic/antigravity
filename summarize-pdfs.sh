#!/usr/bin/env bash
set -Eeuo pipefail

# Recursively summarize PDFs with Ollama and combine the summaries in one file.
# Usage: ./summarize-pdfs.sh [PDF_DIRECTORY] [OUTPUT.md]

PDF_ROOT=${1:-.}
OUTPUT=${2:-pdf-summaries.md}
MODEL=${MODEL:-granite4.1:8b}
FALLBACK_MODEL=${FALLBACK_MODEL:-granite4.1:3b}
CHUNK_BYTES=${CHUNK_BYTES:-45000}
CACHE_DIR=${CACHE_DIR:-.pdf-summary-cache}

command -v pdftotext >/dev/null 2>&1 || {
  echo "Error: pdftotext is required (Ubuntu/Debian: sudo apt install poppler-utils)." >&2
  exit 1
}
command -v ollama >/dev/null 2>&1 || {
  echo "Error: ollama is not installed or is not on PATH." >&2
  exit 1
}

if [[ ! -d "$PDF_ROOT" ]]; then
  echo "Error: PDF directory does not exist: $PDF_ROOT" >&2
  exit 1
fi

available_models=$(ollama list 2>/dev/null | awk 'NR > 1 {print $1}')
if ! grep -Fxq "$MODEL" <<<"$available_models"; then
  if grep -Fxq "$FALLBACK_MODEL" <<<"$available_models"; then
    echo "Model $MODEL is unavailable; using $FALLBACK_MODEL." >&2
    MODEL=$FALLBACK_MODEL
  else
    echo "Error: neither $MODEL nor $FALLBACK_MODEL is available in Ollama." >&2
    exit 1
  fi
fi

mkdir -p "$CACHE_DIR/summaries" "$CACHE_DIR/work"
mapfile -d '' PDFS < <(find "$PDF_ROOT" -type f -iname '*.pdf' -not -path "*/$CACHE_DIR/*" -print0 | sort -z)

if (( ${#PDFS[@]} == 0 )); then
  echo "Error: no PDFs found beneath $PDF_ROOT" >&2
  exit 1
fi

echo "Found ${#PDFS[@]} PDFs. Using $MODEL." >&2

run_ollama() {
  local instruction=$1 source_file=$2 destination=$3
  {
    printf '%s\n\n--- BEGIN SOURCE ---\n' "$instruction"
    sed 's/\x00//g' "$source_file"
    printf '\n--- END SOURCE ---\n'
  } | ollama run "$MODEL" >"$destination.tmp"
  [[ -s "$destination.tmp" ]] || {
    rm -f "$destination.tmp"
    return 1
  }
  mv "$destination.tmp" "$destination"
}

for index in "${!PDFS[@]}"; do
  pdf=${PDFS[$index]}
  relative=${pdf#"$PDF_ROOT"/}
  [[ "$relative" == "$pdf" ]] && relative=$(basename "$pdf")
  stamp=$(printf '%s\0%s\0%s\0%s' "$pdf" "$MODEL" "$(stat -c '%Y:%s' "$pdf")" "$CHUNK_BYTES" | sha256sum | cut -d' ' -f1)
  summary="$CACHE_DIR/summaries/$stamp.md"

  printf '[%d/%d] %s' "$((index + 1))" "${#PDFS[@]}" "$relative" >&2
  if [[ -s "$summary" ]]; then
    echo ' (cached)' >&2
    continue
  fi
  echo >&2

  work="$CACHE_DIR/work/$stamp"
  rm -rf "$work"
  mkdir -p "$work/chunks" "$work/partials"
  if ! pdftotext -layout -enc UTF-8 "$pdf" "$work/document.txt"; then
    printf 'Extraction failed for `%s`.\n' "$relative" >"$summary"
    continue
  fi
  if [[ ! -s "$work/document.txt" ]]; then
    printf 'No machine-readable text was found in `%s`; it may require OCR.\n' "$relative" >"$summary"
    continue
  fi

  split -C "$CHUNK_BYTES" -d -a 4 --additional-suffix=.txt "$work/document.txt" "$work/chunks/chunk-"
  mapfile -t chunks < <(find "$work/chunks" -type f -name 'chunk-*.txt' | sort)
  for chunk_index in "${!chunks[@]}"; do
    partial="$work/partials/$(printf '%04d' "$chunk_index").md"
    instruction="Summarize this section of a research paper accurately and compactly. Preserve the central claims, reasoning, evidence, qualifications, and conclusions. Distinguish the author's claims from established findings. Do not invent facts, citations, or criticism. Write coherent prose without preambles. This is section $((chunk_index + 1)) of ${#chunks[@]} from: $relative"
    run_ollama "$instruction" "${chunks[$chunk_index]}" "$partial" || {
      echo "Ollama failed while processing $relative" >&2
      exit 1
    }
  done

  if (( ${#chunks[@]} == 1 )); then
    cp "$work/partials/0000.md" "$summary"
  else
    combined="$work/partial-summaries.txt"
    : >"$combined"
    for partial in "$work"/partials/*.md; do
      printf '\n### Section summary\n\n' >>"$combined"
      sed 's/\x00//g' "$partial" >>"$combined"
    done
    instruction="Synthesize these ordered section summaries into one self-contained summary of the complete paper '$relative'. Explain its subject, main thesis, reasoning or method, important evidence or examples, qualifications, and conclusion. Remove repetition while preserving disagreements and uncertainty. Use several compact paragraphs, with no generic preamble and no invented details."
    run_ollama "$instruction" "$combined" "$summary" || {
      echo "Ollama failed while synthesizing $relative" >&2
      exit 1
    }
  fi
  rm -rf "$work"
done

output_tmp="$OUTPUT.tmp"
{
  printf '# PDF Collection Summaries\n\n'
  printf 'Generated from %d PDFs using Ollama model `%s`.\n\n' "${#PDFS[@]}" "$MODEL"
  for index in "${!PDFS[@]}"; do
    pdf=${PDFS[$index]}
    relative=${pdf#"$PDF_ROOT"/}
    [[ "$relative" == "$pdf" ]] && relative=$(basename "$pdf")
    stamp=$(printf '%s\0%s\0%s\0%s' "$pdf" "$MODEL" "$(stat -c '%Y:%s' "$pdf")" "$CHUNK_BYTES" | sha256sum | cut -d' ' -f1)
    title=${relative%.pdf}
    title=${title//-/ }
    title=${title//_/ }
    printf '## %s\n\n' "$title"
    printf '*Source: `%s`*\n\n' "$relative"
    cat "$CACHE_DIR/summaries/$stamp.md"
    printf '\n\n'
  done
} >"$output_tmp"
mv "$output_tmp" "$OUTPUT"

echo "Finished: $OUTPUT" >&2

