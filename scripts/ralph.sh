#!/bin/bash
# ralph.sh <feature-name> [--tool claude] [--max N]
# Runs one agent iteration per ready-for-agent issue in .scratch/<feature>/issues/

set -e

FEATURE_NAME=""
TOOL="claude"
MAX_ITERATIONS=20

while [[ $# -gt 0 ]]; do
  case $1 in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --tool=*)
      TOOL="${1#*=}"
      shift
      ;;
    --max)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --max=*)
      MAX_ITERATIONS="${1#*=}"
      shift
      ;;
    *)
      if [[ -z "$FEATURE_NAME" ]]; then
        FEATURE_NAME="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$FEATURE_NAME" ]]; then
  echo "Usage: ./ralph.sh <feature-name> [--tool claude] [--max N]"
  exit 1
fi

if [[ "$TOOL" != "claude" ]]; then
  echo "Error: Invalid tool '$TOOL'. Only 'claude' is supported."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
ISSUES_DIR="$PROJECT_DIR/.scratch/$FEATURE_NAME/issues"
FEATURE_PROGRESS="$PROJECT_DIR/.scratch/$FEATURE_NAME/progress.txt"
GLOBAL_PROGRESS="$PROJECT_DIR/progress.txt"

if [[ ! -d "$ISSUES_DIR" ]]; then
  echo "Error: No issues directory found at $ISSUES_DIR"
  exit 1
fi

echo "Starting ralph — feature: $FEATURE_NAME, tool: $TOOL, max: $MAX_ITERATIONS"

for i in $(seq 1 $MAX_ITERATIONS); do
  # Find the next ready-for-agent issue (lowest filename = dependency order)
  NEXT_ISSUE=""
  while IFS= read -r f; do
    if grep -q 'status: ready-for-agent' "$f" 2>/dev/null; then
      NEXT_ISSUE="$f"
      break
    fi
  done < <(find "$ISSUES_DIR" -name "*.md" | sort)

  if [[ -z "$NEXT_ISSUE" ]]; then
    echo ""
    echo "No more ready-for-agent issues. Ralph complete."
    exit 0
  fi

  echo ""
  echo "==============================================================="
  echo "  Iteration $i — $(basename "$NEXT_ISSUE")"
  echo "==============================================================="

  PROMPT=$(cat <<EOF
## Current Task

Feature name: $FEATURE_NAME
Issue file: $NEXT_ISSUE
Issues directory: $ISSUES_DIR
Feature progress log: $FEATURE_PROGRESS
Global progress log: $GLOBAL_PROGRESS

$(cat "$SCRIPT_DIR/../CLAUDE.md")
EOF
  )

  CLAUDE_EXIT=0
  OUTPUT=$(set -o pipefail; echo "$PROMPT" | claude --dangerously-skip-permissions --print 2>&1 | tee /dev/stderr) || CLAUDE_EXIT=$?

  if [[ $CLAUDE_EXIT -ne 0 ]]; then
    echo ""
    echo "ralph stopped: claude exited with code $CLAUDE_EXIT — check spend cap, rate limits, or network connectivity"
    exit $CLAUDE_EXIT
  fi

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo ""
    echo "Ralph: all issues complete!"
    exit 0
  fi

  echo "Iteration $i complete."
  sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
exit 1
