FROM openjdk:8-jre-slim
WORKDIR /danmuji
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone &&
ADD /home/runner/work/Docker_Buildx_Danmuji/Docker_Buildx_Danmuji/danmuji/danmuji.jar /danmuji/danmuji.jar
EXPOSE 23333
VOLUME /danmuji/Danmuji_log /danmuji/guardFile /danmuji/log
ENTRYPOINT ["java", "-jar", "danmuji.jar"]