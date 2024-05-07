#!/bin/bash

# Update and install necessary tools and libraries
apt-get update && apt-get upgrade -y
apt install -y curl socat vim xz-utils openssl gawk file wget screen build-essential libffi-dev libssl-dev zlib1g-dev

# Start a new screen session
screen -S os

# Download Python
echo "正在下载 Python 3.11.9..."
wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz

# Extract
echo "正在解压 Python 3.11.9..."
tar -xzf Python-3.11.9.tgz

# Enter directory
cd Python-3.11.9

# Configure installation
echo "正在配置安装 Python 3.11.9..."
./configure --enable-optimizations

# Compile and install (use `-j` to speed up the process based on your CPU core count)
echo "正在编译安装 Python 3.11.9，这可能需要几分钟的时间..."
make altinstall -j$(nproc) || echo "编译失败，请检查错误日志和系统配置！"

# Update python and python3 links to the newly installed Python version
echo "正在更新系统默认 Python 版本..."
if [ -f /usr/local/bin/python3.11 ]; then
    update-alternatives --install /usr/bin/python python /usr/local/bin/python3.11 1
    update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
else
    echo "安装 Python 3.11.9 失败，未找到 /usr/local/bin/python3.11"
fi

# Cleanup installation files
echo "清理安装文件..."
cd ..
rm -rf Python-3.11.9
rm Python-3.11.9.tgz

echo "Python 3.11.9 安装脚本执行完毕。"
