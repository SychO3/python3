#!/bin/bash

# 检查并安装必要的工具
apt-get update && apt-get upgrade -y
apt install -y curl socat vim xz-utils openssl gawk file wget screen build-essential

screen -S os

# 下载 Python
echo "正在下载 Python 3.11.9..."
wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz

# 解压
echo "正在解压 Python 3.11.9..."
tar -xzf Python-3.11.9.tgz

# 进入目录
cd Python-3.11.9

# 配置安装
echo "正在配置安装 Python 3.11.9..."
./configure --enable-optimizations

# 编译安装 (使用 `-j` 根据您的 CPU 核心数来加速编译过程)
echo "正在编译安装 Python 3.11.9，这可能需要几分钟的时间..."
make altinstall -j$(nproc)

# 更新 python 和 python3 指向新安装的 Python 版本
echo "正在更新系统默认 Python 版本..."
if [ -f /usr/local/bin/python3.11 ]; then
    update-alternatives --install /usr/bin/python python /usr/local/bin/python3.11 1
    update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
else
    echo "安装 Python 3.11.9 失败，未找到 /usr/local/bin/python3.11"
fi

# 清理下载文件
echo "清理安装文件..."
cd ..
rm -rf Python-3.11.9
rm Python-3.11.9.tgz

echo "Python 3.11.9 安装脚本执行完毕。"
