#!/bin/bash
mkdir -p openwrt

REPO="wukongdaily/img-installer"
TAG="2026-01-02"

# 固件下载地址：https://site.istoreos.com/firmware/download?devicename=x86_64
# 定义文件相关信息
VERSION="24.10.5"
BUILD_DATE="2025123110"
ARCH="x86-64"
TYPE="squashfs-combined-efi"

# 构建文件名和URL
FILE_NAME="istoreos-${VERSION}-${BUILD_DATE}-${ARCH}-${TYPE}.img.gz"
OUTPUT_PATH="openwrt/istoreos.img.gz"
DOWNLOAD_URL="https://fw0.koolcenter.com/iStoreOS/x86_64_efi/${FILE_NAME}"

echo "下载地址: $DOWNLOAD_URL"
echo "下载文件: $FILE_NAME -> $OUTPUT_PATH"
curl -L -o "$OUTPUT_PATH" "$DOWNLOAD_URL"

if [[ $? -eq 0 ]]; then
  echo "下载istoreos成功!"
  echo "正在解压为:istoreos.img"
  gzip -d openwrt/istoreos.img.gz
  ls -lh openwrt/
  echo "准备合成 istoreos 安装器"
else
  echo "下载失败！"
  exit 1
fi

mkdir -p output
docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/openwrt/istoreos.img:/mnt/istoreos.img \
        debian:buster \
        /supportFiles/istoreos/build.sh
