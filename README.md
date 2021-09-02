# [Docker_Buildx_Danmuji](https://hub.docker.com/repository/docker/zzcabc/danmuji)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/BanqiJane/Bilibili_Danmuji?label=danmuji&style=flat-square)](https://github.com/BanqiJane/Bilibili_Danmuji/releases/latest)  [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/zzcabc/danmuji?label=DockerHub&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated)
### 如果你发现上面图标版本不一致，请点击一下star，这样会触发自动构建镜像，即使你之后取消star


本项目使用Docker Buildx构建全平台镜像，支持linux/armv7、linux/armv8、linux/amd64框架

使用GitHub Action自动构建[BanqiJane/Bilibili_Danmuji](https://github.com/BanqiJane/Bilibili_Danmuji)的Docker镜像

[B站用户西凉君君提供的Docker镜像](https://registry.hub.docker.com/r/xilianghe/danmuji)


armv8和amd64框架使用 **openjdk:11.0.10-jre-slim**

armv7框架使用 **openjdk:11.0.1-jre-slim**

**使用方式**

```
docker run -d \
       --name danmuji \
       -p 本机端口:23333 \
       -v 本机路径:/danmuji/log \                 弹幕姬保存弹幕
       -v 本机路径:/danmuji/guardFile \           弹幕姬上舰私信(非必须映射)
       -v 本机路径:/danmuji/Danmuji_log \         弹幕姬日志(非必须映射)
       zzcabc/danmuji:latest
```


### 注意：本项目会拉取releases最新的danmuji.zip构建镜像,因包内名称为BiliBili_Danmuji-版本号beta.jar,如上游发生变化，则无法成功构建镜像

## TODO

- [ ] 添加判断，如果releases的版本与DockerHub的版本一致,则不重新构建镜像
- [ ] 每日定时构建镜像,当上有发布新版本最长也就时隔24小时更新
- [ ] 使用源码构建镜像,解决上述注意事项(但我不会！！！！)
- [ ] 将镜像上传阿里镜像仓库