# [Docker_Buildx_Danmuji](https://hub.docker.com/r/zzcabc/danmuji) <-点击跳转DockerHub



####  [本测试版本](https://hub.docker.com/r/zzcabc/danmuji-code) <- 点击跳转本项目测试DockerHub 





[![GitHub release (latest by date)](https://img.shields.io/github/v/release/BanqiJane/Bilibili_Danmuji?label=danmuji&style=flat-square)](https://github.com/BanqiJane/Bilibili_Danmuji/releases/latest) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/zzcabc/danmuji?label=DockerHub&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated)

### 如果你发现上面图标版本不一致，请点击一下star，这样会触发自动构建镜像，即使你之后取消star





本项目使用Docker Buildx构建全平台镜像，支持linux/armv7、linux/armv8、linux/amd64框架



使用GitHub Action中国时间**0:00**自动拉取[BanqiJane/Bilibili_Danmuji](https://github.com/BanqiJane/Bilibili_Danmuji)的源码进行构建Docker镜像，由源码构建时间大概4分钟



[B站用户西凉君君提供的Docker镜像地址](https://registry.hub.docker.com/r/xilianghe/danmuji)





| 架构 |       底包       | 大小  |
| ---- | ---- | ---- |
| Amd64 | **openjdk:11.0.10-jre-slim** | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/zzcabc/danmuji/latest-amd64?label=latest-amd64&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated) |
| Armv8 | **openjdk:11.0.10-jre-slim** | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/zzcabc/danmuji/latest-arm64v8?label=latest-arm64v8&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated) |
| Armv7 | **openjdk:11.0.1-jre-slim** | [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/zzcabc/danmuji/latest-arm32v7?label=latest-arm32v7&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated) |





**别问为什么使用jdk11,因为armv7的底包太难找了,使用jre为底包是因为Java运行仅需jre,可以减小体积**





**使用方式**

```sh

docker run -d \
    --name danmuji \
    -p 本机端口:23333 \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    -v 本机弹幕姬配置文件路径:/danmuji/DanmujiProfile
    zzcabc/danmuji:latest

```

**映射路径说明** 

此说明对应Docker容器内

/danmuji/Danmuji_log                   弹幕姬保存弹幕文件夹

/danmuji/guardFile                        弹幕姬上舰私信文件夹(非必须映射)

/danmuji/log                                   弹幕姬日志文件夹(非必须映射)

/danmuji/DanmujiProfile             弹幕姬配置文件(非必须映射)(**在弹幕姬2.4.7之后版本生效**)





### ~~注意：本项目会拉取releases最新的danmuji.zip构建镜像,因包内名称为BiliBili_Danmuji-版本号beta.jar,如上游发生变化，则无法成功构建镜像~~



## TODO



- [x] 添加判断，如果releases的版本与DockerHub的版本一致,则不重新构建镜像

- [x] 每日定时构建镜像,当上有发布新版本最长也就时隔24小时更新

- [x] 使用源码构建镜像,解决上述注意事项(但我不会！！！！)  上面三项同时解决

- [ ] 将镜像上传阿里镜像仓库