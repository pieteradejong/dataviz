#!/usr/bin/env bash
# run.sh — one subcommand per plot script. Run ./init.sh once first. Each opens a window.
#   ./run.sh heatmap     heatmap.py
#   ./run.sh hist        hist.py — histogram of random integers
#   ./run.sh lorenz      lorenz.py — Lorenz attractor
#   ./run.sh test        every check (delegates to ./test.sh)
#   ./run.sh [help]      this text (default)
set -euo pipefail
cd "$(dirname "$0")"
VENV=.venv
PY="$VENV/bin/python"

cmd="${1:-help}"
[ $# -gt 0 ] && shift
case "$cmd" in
  help|-h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  test) exec ./test.sh "$@" ;;
  heatmap|hist|lorenz) ;;
  *) echo "unknown command: $cmd" >&2; exit 2 ;;
esac
[ -x "$PY" ] || { echo "no $VENV: run ./init.sh first" >&2; exit 1; }
case "$cmd" in
  heatmap|hist|lorenz) exec "$PY" "$cmd.py" "$@" ;;
  *) echo "unknown command: $cmd" >&2; sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//' >&2; exit 2 ;;
esac
