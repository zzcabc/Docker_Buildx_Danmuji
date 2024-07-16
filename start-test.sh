#!/bin/sh
set -e

# 创建必要的文件夹函数
create_directories() {
    [ ! -d "/danmuji/Danmuji_log" ] && mkdir /danmuji/Danmuji_log
    [ ! -d "/danmuji/guardFile" ] && mkdir /danmuji/guardFile
    [ ! -d "/danmuji/log" ] && mkdir /danmuji/log
}

# 获取最新版本
LATEST_VERSION=$(curl -sX GET "https://api.github.com/repos/BanqiJane/Bilibili_Danmuji/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

# 检查旧版本文件是否存在
if [ -f "/danmuji/old" ]; then
    # 记录当前版本
    echo ${LATEST_VERSION} > /danmuji/new
else
    echo "You are running docker for the first time"
    echo "Downloading files now"
    echo ${LATEST_VERSION} > /danmuji/old
    wget ${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat /danmuji/old)/danmuji.zip
    unzip danmuji.zip
    cp $(find ./ -name "*.jar") /danmuji/danmuji.jar
    rm -rf danmuji/ *.zip
    echo "Download completed"
fi

# 检查新版本文件是否存在
if [ -f "/danmuji/new" ]; then
    if [ "$(cat /danmuji/old)" != "$(cat /danmuji/new)" ]; then
        echo "Inconsistent versions"
        echo "Version being updated"
        rm /danmuji/*.jar
        wget ${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat /danmuji/new)/danmuji.zip
        unzip danmuji.zip
        cp $(find ./ -name "*.jar") /danmuji/danmuji.jar
        rm -rf danmuji/ *.zip
        mv /danmuji/new /danmuji/old
        echo "Update completed"
    fi
fi

# 使用传入的 UID 和 GID 创建用户
if [ -n "$UID" ] && [ -n "$GID" ]; then
    addgroup -g "$GID" danmuji
    adduser -u "$UID" -G danmuji -h /danmuji -D danmuji
    chown -R danmuji:danmuji /danmuji

    # 以指定的 UID 和 GID 创建文件夹
    su-exec danmuji:danmuji sh -c "$(declare -f create_directories); create_directories"
    
    # 以指定的 UID 和 GID 启动程序
    exec su-exec danmuji:danmuji java ${JAVA_OPTS} -jar /danmuji/danmuji.jar ${JAVA_OPTS2}
else
    # 如果没有指定 UID 和 GID，默认创建文件夹并启动程序
    create_directories
    exec java ${JAVA_OPTS} -jar /danmuji/danmuji.jar ${JAVA_OPTS2}
fi
