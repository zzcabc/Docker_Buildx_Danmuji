FROM openjdk:11.0.3-jre-slim
WORKDIR /danmuji
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone && \
    mkdir Danmuji_log && mkdir guardFile && mkdir log 
COPY Bilibili_Danmuji/danmuji.jar /danmuji/danmuji.jar
EXPOSE 23333
VOLUME /danmuji/Danmuji_log /danmuji/guardFile /danmuji/log
ENV JAVA_OPTS=""
ENTRYPOINT ["sh","-c","java ${JAVA_OPTS} -jar danmuji.jar"]

