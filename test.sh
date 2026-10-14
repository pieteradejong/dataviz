#!/usr/bin/env bash
# test.sh — every check in one place. Exit 0 = green. `run.sh test` runs this script.
#   ./test.sh            venv matches requirements, imports resolve, compile every tracked .py,
#                        shell syntax and shellcheck of the scripts, no tracked .env
#   ./test.sh --help     this text
set -euo pipefail
cd "$(dirname "$0")"
case "${1:-}" in -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;; esac

VENV=.venv
PY="$VENV/bin/python"
[ -x "$PY" ] || { echo "no $VENV: run ./init.sh first" >&2; exit 1; }

echo "== python"; "$PY" --version
echo "== deps"; "$PY" -m pip check
echo "== imports"; MPLBACKEND=Agg "$PY" -c 'import matplotlib, numpy, scipy; print("matplotlib", matplotlib.__version__, "numpy", numpy.__version__, "scipy", scipy.__version__)'
echo "== compile (tracked .py)"
git ls-files '*.py' | xargs "$PY" -m compileall -q
echo "== shell"
for f in ./*.sh; do bash -n "$f"; /bin/bash -n "$f"; done
if command -v shellcheck >/dev/null 2>&1; then shellcheck -S warning ./*.sh
else echo "shellcheck not installed — syntax-checked only (brew install shellcheck)"; fi
echo "== secrets"
tracked="$(git ls-files | grep -E '(^|/)\.env(\..+)?$' | grep -vE '\.env\.(example|template)$' || true)"
[ -z "$tracked" ] || { echo "tracked env files:"; echo "$tracked"; exit 1; }
echo "== all green"
