#!/usr/bin/env bash
#
# find-missing-pdfs.sh
#
# Run from inside full-series/ (or wherever your .tex files live).
# Lists any .tex file that has no matching .pdf, and separately checks
# each missing one's .log for the specific LaTeX error, if a .log exists.

set -uo pipefail

missing=()

for texfile in *.tex; do
  base="${texfile%.tex}"
  if [ ! -f "${base}.pdf" ]; then
    missing+=("$base")
  fi
done

count=${#missing[@]}

if [ "$count" -eq 0 ]; then
  echo "All .tex files have a matching .pdf. Nothing missing."
  exit 0
fi

echo "Missing PDFs (${count}):"
for base in "${missing[@]}"; do
  echo "  - ${base}"
done

echo ""
echo "Checking logs for likely cause..."
for base in "${missing[@]}"; do
  echo ""
  echo "=== ${base} ==="
  if [ -f "${base}.log" ]; then
    # Show the first LaTeX-reported error line, if any
    error_line=$(grep -m1 -E "^! |Fatal error|Emergency stop" "${base}.log" || true)
    if [ -n "$error_line" ]; then
      echo "  $error_line"
    else
      echo "  No obvious '!' error found in log — may have just not run at all,"
      echo "  or timed out. Try recompiling this one manually:"
      echo "  pdflatex -interaction=nonstopmode ${base}.tex"
    fi
  else
    echo "  No .log file found — this one probably was never run."
    echo "  Try: pdflatex -interaction=nonstopmode ${base}.tex"
  fi
done

echo ""
echo "To recompile just the missing ones:"
echo '  for f in' "${missing[@]}" '; do pdflatex -interaction=nonstopmode "$f.tex"; pdflatex -interaction=nonstopmode "$f.tex"; done'
