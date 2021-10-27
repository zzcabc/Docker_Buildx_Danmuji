# [Docker_Buildx_Danmuji](https://hub.docker.com/r/zzcabc/danmuji) <-点击跳转DockerHub


####  [本测试版本](https://hub.docker.com/r/zzcabc/danmuji-code) <- 点击跳转本项目测试DockerHub 


[![GitHub release (latest by date)](https://img.shields.io/github/v/release/BanqiJane/Bilibili_Danmuji?label=danmuji&style=flat-square)](https://github.com/BanqiJane/Bilibili_Danmuji/releases/latest) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/zzcabc/danmuji?label=DockerHub&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated)


### 如果你发现上面图标版本不一致，请点击一下star，这样会触发自动构建镜像，即使你之后取消star


本项目使用Docker Buildx构建全平台镜像，支持linux/386、linux/amd64、linux/armv6、linux/armv7、linux/armv8、linux/ppc64le、linux/s390x框架，并使用openjdk:8u212-jre-alpine3.9作为底包


[测试版本](https://hub.docker.com/r/zzcabc/danmuji-code)采用openjdk:8u212-jre-alpine3.9作为底包


测试版本将不会进行平台测试，也就是说测试版本出问题别找我


使用GitHub Action中国时间 **0:00** 自动拉取[BanqiJane/Bilibili_Danmuji](https://github.com/BanqiJane/Bilibili_Danmuji)的源码进行构建Docker镜像，**但当源码版本和Docker镜像版本一致将不会构建镜像**，由源码构建时间大概6分钟


[B站用户西凉君君提供的Docker镜像地址](https://registry.hub.docker.com/r/xilianghe/danmuji)

# 使用方式

```sh
docker run -d \
    --name danmuji \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji:latest
```

# 映射路径说明

此说明对应Docker容器内

JAVA_OPTS="-Xms64m -Xmx128m"           限制内存(**可能无效果**)

/danmuji/Danmuji_log                   弹幕姬保存弹幕文件夹

/danmuji/guardFile                     弹幕姬上舰私信文件夹(非必须映射)

/danmuji/log                           弹幕姬日志文件夹(非必须映射)


### ~~注意：本项目会拉取releases最新的danmuji.zip构建镜像,因包内名称为BiliBili_Danmuji-版本号beta.jar,如上游发生变化，则无法成功构建镜像~~

# TODO

- [x] 添加判断，如果releases的版本与DockerHub的版本一致，则不重新构建镜像

- [x] 每日定时构建镜像，当上有发布新版本最长也就时隔24小时更新

- [x] 使用源码构建镜像，解决上述注意事项(但我不会！！！！)  上面三项同时解决

- [ ] 将镜像上传阿里镜像仓库
