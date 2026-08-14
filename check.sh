#!/usr/bin/env bash
# Every translatable node must carry both languages, or the toggle blanks it out.
set -euo pipefail

sk=$(grep -o 'data-sk=' index.html | wc -l)
en=$(grep -o 'data-en=' index.html | wc -l)

if [ "$sk" -ne "$en" ]; then
  echo "FAIL: $sk data-sk vs $en data-en in index.html" >&2
  exit 1
fi
echo "OK: $sk translated nodes, both languages present"
