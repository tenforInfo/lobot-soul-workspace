#!/usr/bin/env bash
# 简单自检脚本示例
set -e
echo "Running simple checks for brain-intake skill..."
# check markdown files exist
for f in README.md PRD.md MIGRATION.md; do
  if [ ! -f "skills/brain-intake/$f" ]; then
    echo "Missing $f"
    exit 2
  fi
done
echo "OK"
