FROM openjdk:8u212-jre-alpine3.9
WORKDIR /danmuji
RUN apk add -U --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone && \
    mkdir Danmuji_log && mkdir guardFile && mkdir log && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*
COPY Bilibili_Danmuji/danmuji.jar /danmuji/danmuji.jar
EXPOSE 23333
VOLUME /danmuji/Danmuji_log /danmuji/guardFile /danmuji/log
ENV JAVA_OPTS=""
ENTRYPOINT ["sh","-c","java ${JAVA_OPTS} -jar danmuji.jar"]