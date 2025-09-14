#!/usr/bin/env bash
set -e

echo "🚀 开始生成并部署博客到 master 分支..."

hexo clean
hexo g
hexo d

echo "✅ 博客已成功部署到 master 分支"
