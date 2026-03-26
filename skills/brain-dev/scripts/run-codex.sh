#!/usr/bin/env bash
# run-codex.sh — launched inside the agent worktree by brain-dev skill
# Required env vars:
#   TASK_DESC    — human-readable task description
#   BRANCH_NAME  — git branch for this task (e.g. agent/dev-issue-10)
set -euo pipefail
cd "$(dirname "$0")"

echo "🚀 Initializing Codex Task..."
echo "   Task : ${TASK_DESC}"
echo "   Branch: ${BRANCH_NAME}"

# Build -i flags for any downloaded reference images
image_args=()
if [[ -d ./issue-assets ]]; then
  while IFS= read -r -d '' f; do
    image_args+=(-i "$f")
  done < <(find ./issue-assets -maxdepth 1 -type f -print0 2>/dev/null)
fi

if [[ ${#image_args[@]} -gt 0 ]]; then
  echo "   Images: ${#image_args[@]} asset(s) attached"
fi

codex exec --full-auto "${image_args[@]}" "$(cat .agent_instruction.txt)"

echo "✅ Task completed."
