#!/usr/bin/env bash
# 把 MediaCrawler 爬到的图片汇入 corpus/raw/（扁平化，笔记id做前缀防重名）
# 用法: bash sync-images.sh [MediaCrawler目录] 默认 ~/tools/MediaCrawler
set -euo pipefail
MC_DIR="${1:-$HOME/tools/MediaCrawler}"
RAW_DIR="$(cd "$(dirname "$0")" && pwd)/raw"
mkdir -p "$RAW_DIR"
count=0
for platform in xhs weibo wb; do
  src="$MC_DIR/data/$platform/images"
  [ -d "$src" ] || continue
  for dir in "$src"/*/; do
    [ -d "$dir" ] || continue
    note_id="$(basename "$dir")"
    for img in "$dir"*; do
      [ -f "$img" ] || continue
      dest="$RAW_DIR/${platform}-${note_id}-$(basename "$img")"
      [ -f "$dest" ] || { cp "$img" "$dest"; count=$((count+1)); }
    done
  done
done
echo "同步完成：新增 $count 张图片 -> $RAW_DIR"
