#!/usr/bin/env bash
# init.sh — venv with pinned dependencies. Idempotent: reuses .venv/; --clean rebuilds it.
#   ./init.sh            create or reuse .venv/, install requirements.txt
#   ./init.sh --clean    remove .venv/ first
#   ./init.sh --help     this text
set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;; esac

VENV=.venv
# Newest interpreter the pinned wheels support, first one found wins.
pick_python() {
  local p
  for p in python3.14 python3.13 python3.12 python3; do
    command -v "$p" >/dev/null 2>&1 && { echo "$p"; return 0; }
  done
  echo "python3 not found" >&2; return 1
}
PYTHON="${PYTHON:-$(pick_python)}"

[ "${1:-}" = "--clean" ] && rm -rf "$VENV"
if [ -x "$VENV/bin/python" ] && ! "$VENV/bin/python" -c 'import sys' >/dev/null 2>&1; then
  echo "$VENV points at an interpreter that no longer exists; rebuilding"; rm -rf "$VENV"
fi
if [ -x "$VENV/bin/python" ]; then echo "reusing $VENV ($("$VENV/bin/python" --version))"
else echo "creating $VENV with $PYTHON"; "$PYTHON" -m venv "$VENV"; fi
"$VENV/bin/python" -m pip install --quiet --disable-pip-version-check -r requirements.txt
echo "ready: ./run.sh help"
