#!/bin/bash
# 每次启动获取最新的版本
LATEST_VERSION=$(curl -sX GET "https://api.github.com/repos/BanqiJane/Bilibili_Danmuji/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]')

# 判断旧的版本时候存在
if [ -f "/danmuji/old" ];then
    # 存在说明重启过容器
    # 将重启时的版本写入新的文件
    echo ${LATEST_VERSION} > new
else
    # 不存在说明是第一次启动容器
    echo "You are running docker for the first time"
    echo "Downloading files now"
    # 将当前版本写入old文件
    echo ${LATEST_VERSION} > old
    # 下载版本
    wget ${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat old)/danmuji.zip
    # 解压最新版本
    unzip danmuji.zip
    # 将BiliBili_Danmuji-版本beta.jar 移动至/danmuji文件夹下，并重命名为danmuji.jar
    cp $(find ./ -name "*.jar") danmuji.jar
    # 删除下载的压缩文件
    rm -rf danmuji/ *.zip
    echo "Download completed"
fi

# 判断新的版本时候存在
if [ -f "/danmuji/new" ];then
    # 如果存在
    # 判断版本是否不一样
    if [$(cat old) != $(cat new)];then
        echo "Inconsistent versions"
        echo "Version being updated"
        # 删除旧的danmuji.jar
        rm *.jar
        # 不一样，获取最新的版本
        # 下载新的版本
        wget ${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/$(cat old)/danmuji.zip
        # 解压最新版本
        unzip danmuji.zip
        # 将BiliBili_Danmuji-版本beta.jar 移动至/danmuji文件夹下，并重命名为danmuji.jar
        cp $(find ./ -name "*.jar") danmuji.jar
        # 删除下载的压缩文件
        rm -rf danmuji/ *.zip
        # 并将new改名为old
        mv /danmuji/new /danmuji/old

        echo "Update completed"
    fi
fi

# 运行弹幕姬
java ${JAVA_OPTS} -jar danmuji.jar ${JAVA_OPTS2}