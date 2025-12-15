FROM eclipse-temurin:8u472-b08-jre

WORKDIR /danmuji

# 设置时区并安装必要的软件包
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget \
    curl \
    tzdata \
    locales \
    gosu \
    sudo \
    procps \
    net-tools \
    iputils-ping \
    vim-tiny && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# 复制应用程序和入口脚本
COPY --chmod=755 Bilibili_Danmuji/danmuji.jar /danmuji/danmuji.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# 暴露应用程序端口
EXPOSE 23333

# 设置环境变量
ENV JAVA_OPTS=""
ENV JAVA_OPTS2=""

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]
