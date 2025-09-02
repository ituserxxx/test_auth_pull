#!/bin/bash

# 检查是否提供了目录名参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <目录名>"
    exit 1
fi

DIR_NAME="$1"
URL="https://raw.github.com/ituserxxx/yuchi_dist_data/main/${DIR_NAME}/dist.zip"
TEMP_FILE="/tmp/dist.zip"
TARGET_DIR="/dist"

# 提示用户脚本将操作根目录
echo "警告：此脚本将操作根目录下的文件，可能需要管理员权限。"
echo "正在从 $URL 下载文件..."

# 下载文件
wget -O "$TEMP_FILE" "$URL"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "下载失败，请检查目录名是否正确"
    exit 1
fi

# 检查目标目录是否存在，如果存在则备份
if [ -d "$TARGET_DIR" ]; then
    # 创建带时间戳的备份目录名
    BACKUP_DIR="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    echo "检测到 $TARGET_DIR 目录已存在，正在备份到 $BACKUP_DIR..."
    sudo mv "$TARGET_DIR" "$BACKUP_DIR"
    
    # 检查备份是否成功
    if [ $? -ne 0 ]; then
        echo "备份失败，无法继续操作"
        exit 1
    fi
fi

# 解压到根目录
echo "正在解压文件到根目录..."
sudo unzip -o "$TEMP_FILE" -d /

# 检查解压是否成功
if [ $? -eq 0 ]; then
    echo "操作完成，文件已成功解压到根目录"
    if [ -n "$BACKUP_DIR" ]; then
        echo "原有 $TARGET_DIR 目录已备份到 $BACKUP_DIR"
    fi
else
    echo "解压失败"
    exit 1
fi

# 清理临时文件
rm -f "$TEMP_FILE"
    
