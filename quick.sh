#!/usr/bin/env bash
set -e

echo "🚀 开始一键部署 + 备份..."

# 运行脚本 1：生成并部署博客
./deploy_site.sh

# 运行脚本 2：备份源文件
./backup_blog.sh

echo "🎉 部署 + 备份完成！"

