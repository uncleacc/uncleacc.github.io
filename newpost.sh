#!/bin/bash
set -euo pipefail

# 事务式执行的临时状态与回滚逻辑
declare -a TMP_FILES=()
PIC_BACKUP=""
PIC_UPDATED=0
PIC_CREATED=0
CREATED_FILE=""
PIC_FILE=""

rollback() {
  local exit_code=$?
  # 清理临时文件
  for t in "${TMP_FILES[@]:-}"; do
    [ -f "$t" ] && rm -f "$t" || true
  done
  # 删除已创建但未成功完成的 md 文件
  if [ -n "${CREATED_FILE:-}" ] && [ -f "$CREATED_FILE" ]; then
    rm -f "$CREATED_FILE"
  fi
  # 恢复/清理计数器文件
  if [ ${PIC_UPDATED:-0} -eq 1 ]; then
    if [ -n "${PIC_FILE-}" ]; then
      if [ -n "${PIC_BACKUP:-}" ] && [ -f "$PIC_BACKUP" ]; then
        mv -f "$PIC_BACKUP" "$PIC_FILE"
      else
        [ -f "$PIC_FILE" ] && rm -f "$PIC_FILE" || true
      fi
    fi
  elif [ ${PIC_CREATED:-0} -eq 1 ]; then
    # 若一开始为创建默认计数器文件，但整体失败则删除它
    if [ -n "${PIC_FILE-}" ] && [ -f "$PIC_FILE" ]; then
      rm -f "$PIC_FILE"
    fi
  fi
  exit $exit_code
}
trap 'rollback' ERR INT TERM

# 使用方式：
# ./newpost.sh "文章标题"

if [ $# -eq 0 ]; then
  echo "请输入文章名称" >&2
  echo "用法: $0 \"文章标题\"" >&2
  exit 1
fi

TITLE=$1

# 先校验计数器文件是否存在（确保原子性：失败则不创建 md 文件）
PIC_FILE="pic_num.txt"
if [ ! -f "$PIC_FILE" ]; then
  echo "错误: 缺少计数器文件 'pic_num.txt'。" >&2
  echo "解决方法: 在项目根目录创建 'pic_num.txt'，写入上一次使用的图片 URL，如：" >&2
  echo "  https://cdn.jsdelivr.net/gh/uncleacc/Img2/136.webp" >&2
  false
fi

# 1. 执行 hexo new（只在计数器校验通过后创建）
FILE=$(hexo new "$TITLE" | grep -oE "source/_posts/.*\.md")

if [ ! -f "$FILE" ]; then
  echo "文章创建失败"
  exit 1
fi

# 标记创建的文件用于失败回滚
CREATED_FILE="$FILE"

LAST_URL=$(cat $PIC_FILE)

# 3. 提取数字并 +1（只取最后一个数字，避免多数字导致算术错误）
NUM=$(printf '%s' "$LAST_URL" | grep -oE "[0-9]+" | tail -n1)
if [ -z "$NUM" ]; then
  echo "错误: 从 $PIC_FILE 中读取到的 URL 无法解析数字：'$LAST_URL'" >&2
  echo "请确保文件内容形如：https://cdn.jsdelivr.net/gh/uncleacc/Img2/136.webp" >&2
  false
fi
NEXT_NUM=$((NUM + 1))

NEW_URL="https://cdn.jsdelivr.net/gh/uncleacc/Img2/${NEXT_NUM}.webp"

# 5. 替换 md 文件头部，添加或更新 cover 字段（使用 awk 以保证在 macOS/GNU 下均可用）
if grep -q "^cover:" "$FILE"; then
  # 已经有 cover 字段，整行替换
  FILE_TMP="$FILE.tmp"; TMP_FILES+=("$FILE_TMP")
  awk -v newurl="$NEW_URL" '
    BEGIN { replaced = 0 }
    {
      if (!replaced && $0 ~ /^cover:/) {
        print "cover: " newurl
        replaced = 1
        next
      }
      print $0
    }
  ' "$FILE" > "$FILE_TMP" && mv "$FILE_TMP" "$FILE"
else
  # 没有 cover 字段，在 title 行后追加一行 cover
  FILE_TMP="$FILE.tmp"; TMP_FILES+=("$FILE_TMP")
  awk -v newurl="$NEW_URL" '
    BEGIN { inserted = 0 }
    {
      print $0
      if (!inserted && $0 ~ /^title:/) {
        print "cover: " newurl
        inserted = 1
      }
    }
  ' "$FILE" > "$FILE_TMP" && mv "$FILE_TMP" "$FILE"
fi

# 6. 最后一步：原子性更新计数器文件（并创建备份用于回滚）
if [ -f "$PIC_FILE" ]; then
  PIC_BACKUP="$PIC_FILE.bak"
  cp -f "$PIC_FILE" "$PIC_BACKUP"
fi
PIC_TMP="$PIC_FILE.tmp"; TMP_FILES+=("$PIC_TMP")
printf "%s\n" "$NEW_URL" > "$PIC_TMP" && mv "$PIC_TMP" "$PIC_FILE"
PIC_UPDATED=1

# 清理成功路径上的备份文件，避免遗留 .bak
if [ -n "${PIC_BACKUP:-}" ] && [ -f "$PIC_BACKUP" ]; then
  rm -f "$PIC_BACKUP"
fi

echo "文章创建成功: $FILE"
echo "封面链接: $NEW_URL"
