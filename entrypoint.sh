#!/bin/sh
set -e

create_directories() {
    [ ! -d '/danmuji/Danmuji_log' ] && mkdir /danmuji/Danmuji_log
    [ ! -d '/danmuji/guardFile' ] && mkdir /danmuji/guardFile
    [ ! -d '/danmuji/log' ] && mkdir /danmuji/log
}

# 使用传入的 UID 和 GID 创建用户
if [ -n "$UID" ] && [ -n "$GID" ]; then
    groupadd -g "$GID" danmuji
    useradd -u "$UID" -g "$GID" -m danmuji
    chown -R danmuji:danmuji /danmuji

    # 以指定的 UID 和 GID 创建文件夹
    su-exec danmuji:danmuji sh -c "$(declare -f create_directories); create_directories"
    
    # 以指定的 UID 和 GID 启动程序
    exec su-exec danmuji:danmuji sh -c "java ${JAVA_OPTS} -jar danmuji.jar ${JAVA_OPTS2}"
else
    # 如果没有指定 UID 和 GID，默认创建文件夹并启动程序
    create_directories
    exec sh -c "java ${JAVA_OPTS} -jar danmuji.jar ${JAVA_OPTS2}"
fi
