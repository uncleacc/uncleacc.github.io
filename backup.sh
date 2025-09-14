#!/usr/bin/env bash
set -e

echo "💾 开始备份源文件到 backup 分支..."

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$current_branch" != "backup" ]; then
  echo "⚠️ 当前分支是 $current_branch，请切换到 backup 分支再运行。"
  exit 1
fi

# 检查是否有改动
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
else
  echo "✅ 没有需要提交的更改，跳过 commit。"
fi

git push origin backup

echo "✅ 源文件已成功推送到 backup 分支"

