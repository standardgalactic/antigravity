#!/usr/bin/env bash
set -Eeuo pipefail

# Replays common captured terminal editing controls and emits clean UTF-8 text.
# Usage:
#   ./clean-summary-artifacts.sh summaries.md summaries-clean.md
#   ./clean-summary-artifacts.sh --in-place summaries.md

if [[ ${1:-} == "--in-place" ]]; then
  [[ $# -eq 2 ]] || { echo "Usage: $0 --in-place FILE" >&2; exit 2; }
  input=$2
  output=$2
  backup="$input.before-artifact-cleaning"
  [[ -e "$input" ]] || { echo "File not found: $input" >&2; exit 1; }
  [[ ! -e "$backup" ]] || { echo "Backup already exists: $backup" >&2; exit 1; }
  cp -- "$input" "$backup"
  temporary=$(mktemp "${input}.clean.XXXXXX")
  trap 'rm -f -- "${temporary:-}"' EXIT
else
  [[ $# -eq 2 ]] || { echo "Usage: $0 INPUT OUTPUT" >&2; exit 2; }
  input=$1
  output=$2
  [[ -e "$input" ]] || { echo "File not found: $input" >&2; exit 1; }
  [[ "$input" != "$output" ]] || {
    echo "Use --in-place when INPUT and OUTPUT are the same file." >&2
    exit 2
  }
  temporary=$(mktemp "${output}.clean.XXXXXX")
  trap 'rm -f -- "${temporary:-}"' EXIT
fi

python3 - "$input" "$temporary" <<'PY'
import re
import sys
from pathlib import Path

source = Path(sys.argv[1])
destination = Path(sys.argv[2])
data = source.read_text(encoding="utf-8", errors="replace")

# Some logs contain a real ESC byte; copied diagnostic output may contain the
# visible two-character spelling ^[ instead. Normalize both before replaying.
data = data.replace("^[", "\x1b")
csi = re.compile(r"\x1b\[([0-9;?]*)([A-Za-z])")

def amount(parameters: str, default: int = 1) -> int:
    head = parameters.lstrip("?").split(";", 1)[0]
    return int(head) if head.isdigit() else default

def clean_line(line: str) -> str:
    cells: list[str] = []
    cursor = 0
    i = 0
    while i < len(line):
        char = line[i]
        if char == "\x1b":
            match = csi.match(line, i)
            if match:
                params, command = match.groups()
                n = amount(params)
                if command == "D":          # cursor left
                    cursor = max(0, cursor - n)
                elif command == "C":        # cursor right
                    cursor += n
                elif command == "G":        # absolute column (one-based)
                    cursor = max(0, n - 1)
                elif command == "K":        # erase within line
                    mode = amount(params, 0)
                    if mode == 0:
                        del cells[cursor:]
                    elif mode == 1:
                        upto = min(cursor + 1, len(cells))
                        cells[:upto] = [" "] * upto
                    elif mode == 2:
                        cells.clear()
                        cursor = 0
                # Styling and unsupported cursor controls are discarded.
                i = match.end()
                continue
            i += 1
            continue
        if char == "\r":
            cursor = 0
        elif char == "\b":
            cursor = max(0, cursor - 1)
        else:
            if cursor < len(cells):
                cells[cursor] = char
            else:
                if cursor > len(cells):
                    cells.extend(" " for _ in range(cursor - len(cells)))
                cells.append(char)
            cursor += 1
        i += 1
    return "".join(cells).rstrip()

cleaned = "\n".join(clean_line(line) for line in data.split("\n"))
destination.write_text(cleaned, encoding="utf-8")
PY

mv -- "$temporary" "$output"
trap - EXIT

if [[ -n ${backup:-} ]]; then
  echo "Cleaned $output (backup: $backup)" >&2
else
  echo "Cleaned $input -> $output" >&2
fi

