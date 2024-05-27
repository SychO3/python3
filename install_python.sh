#!/bin/bash

# Update and install necessary tools and libraries
apt-get update && apt-get upgrade -y
apt-get install -y build-essential libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev curl socat vim xz-utils openssl gawk file wget screen git

# Check if update-alternatives is installed
if ! command -v update-alternatives &> /dev/null; then
    echo "update-alternatives could not be found, installing..."
    apt-get install -y update-alternatives
fi

# Download Python
echo "正在下载 Python 3.11.9..."
wget -O Python-3.11.9.tgz https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz

# Verify the downloaded file (optional, requires a checksum)
# echo "正在验证下载文件的完整性..."
# wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz.sha256
# sha256sum -c Python-3.11.9.tgz.sha256

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
if make altinstall -j$(($(nproc) > 8 ? 8 : $(nproc))); then
    echo "Python 3.11.9 安装成功。"
    
    # Update python and python3 links to the newly installed Python version
    echo "正在更新系统默认 Python 版本..."
    if [ -f /usr/local/bin/python3.11 ]; then
        update-alternatives --install /usr/bin/python python /usr/local/bin/python3.11 1
        update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1
        
        # Install Poetry
        echo "正在安装 Poetry..."
        curl -sSL https://install.python-poetry.org | python3 -

        # Add Poetry to PATH in .bashrc
        echo "将 Poetry 添加到 PATH..."
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        # source ~/.bashrc to make changes effective in the current shell
        source ~/.bashrc

        echo "Poetry 安装并配置完成。"
    else
        echo "安装 Python 3.11.9 失败，未找到 /usr/local/bin/python3.11"
    fi
else
    echo "Python 编译失败，请检查错误日志和系统配置！"
fi

# Cleanup installation files
echo "清理安装文件..."
cd ..
rm -rf Python-3.11.9
rm Python-3.11.9.tgz

echo "安装脚本执行完毕。"
