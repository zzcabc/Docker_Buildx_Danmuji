# Docker_Buildx_Danmuji

[Dockerhub](https://hub.docker.com/r/zzcabc/danmuji) | [Github](https://github.com/zzcabc/Docker_Buildx_Danmuji)

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/BanqiJane/Bilibili_Danmuji?label=danmuji&style=flat-square)](https://github.com/BanqiJane/Bilibili_Danmuji/releases/latest) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/zzcabc/danmuji?label=DockerHub&style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji/tags?page=1&ordering=last_updated)[![Docker Pulls](https://img.shields.io/docker/pulls/zzcabc/danmuji?style=flat-square)](https://hub.docker.com/r/zzcabc/danmuji)

### 如果你发现上面图标版本不一致，请前往Github点击一下star，这样会触发自动构建镜像，即使你之后取消star

本项目使用Docker Buildx构建全平台镜像，支持`linux/amd64`、`linux/armv7`、`linux/armv8`、~~`linux/386`、`linux/armv6`、`linux/ppc64le`、`linux/s390x`~~框架

|dockerfile|架构|底包采用|Amd64镜像大小|
|:--:|:--:|:--:|:--:|
|Alpine|arm32|openjdk:8u212-jre-alpine3.9|110M|
|Debian|amd64,arm64|8u322-jre-slim-bullseye|221M|
|Update|amd64,arm64|8u322-jre-slim-bullseye|221M|

使用GitHub Action中国时间 **0:00** 自动拉取[BanqiJane/Bilibili_Danmuji](https://github.com/BanqiJane/Bilibili_Danmuji)的源码进行构建Docker镜像，**但当源码版本和Docker镜像版本一致将不会构建镜像**，由源码构建时间大概6分钟

~~[B站用户西凉君君提供的Docker镜像地址](https://registry.hub.docker.com/r/xilianghe/danmuji)~~

# 使用方式

```
当前已经取消linux/386、linux/armv6、linux/ppc64le、linux/s390x的镜像构建

如果你想拉取armv7的镜像，请使用 zzcabc/danmuji:latest-arm32 进行拉取

或者使用 zzcabc/danmuji:2.6.1-arm32 拉取指定版本

使用 zzcabc/danmuji:2.6.1 可以拉取arm64和amd64架构的镜像

```

## DockerHub镜像(无自动更新 将`zzcabc/danmuji`改为`registry.cn-hangzhou.aliyuncs.com/zzcabc/danmuji`即可使用阿里镜像仓库,如果你是armv7的,需要改为`zzcabc/danmuji:latest-arm32`)

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -e JAVA_OPTS2="" (已经启用，具体看映射配置说明的表格)  \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji
```

或者，你也可以使用

```sh
docker run -d \
    --name danmuji \
    -p 本机端口:23333 \
    zzcabc/danmuji
```

**默认拉取最新版的镜像，如果你想指定版本可以将`zzcabc/danmuji`改为`zzcabc/danmuji:2.6.1`**

## DockerHub镜像(有自动更新 仅支持amd64和arm64)

容器采用获取官方的releases的danmuji.zip 解压并使用

releases下载使用国内的免费服务，可能说不定就挂了

但是可能无法正常更新版本，毕竟Github的网络条件你懂

当版本更新的时候，你只需要使用 `docker restart danmuji` 即可完成更新操作

**已经启用，你可以指定代理服务商了**
**不指定默认为GitHub官方源，目前可以用`https://ghproxy.com/`，记得后面有斜杠**

**注意：只要免费服务不炸,就可以更新**

将`zzcabc/danmuji:autoupdate`改成`registry.cn-hangzhou.aliyuncs.com/zzcabc/danmuji:autoupdate` 即可使用阿里镜像仓库

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e GITHUB_PROXY="https://ghproxy.com/" (已经启用启用，自定义GitHub代理域名) \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -e JAVA_OPTS2="" (已经启用，具体看映射配置说明的表格)  \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji:autoupdate
```

或者，你也可以使用

```sh
docker run -d \
    --name danmuji \
    -p 本机端口:23333 \
    zzcabc/danmuji:autoupdate
```

## docker-compose方式

**确保你安装了docker-compose，并且可以使用**

使用下面命令获取本项目的docker-compose

可能因为CDN的原因无法获取

`wget https://cdn.jsdelivr.net/gh/zzcabc/Docker_Buildx_Danmuji@main/docker-compose.yaml`

之后通过nano或者vim命令修改docker-compose.yaml

最后使用 `docker-compose up -d` 命令启动

你可以使用docker-compose启动多个容器

添加多个service
```yaml
  danmuji: # 变更命名
    image: zzcabc/danmuji
    container_name: danmuji # 变更容器名
    restart: always
    privileged: true
    environment:
      TZ: Asia/Shanghai
      JAVA_OPTS: "-Xms64m -Xmx128m"
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "23333:23333" # 变更端口
    volumes:
      - /danmuji/Danmuji_log:/danmuji/Danmuji_log
      - /danmuji/guardFile:/danmuji/guardFile
      - /danmuji/log:/danmuji/log
    logging:
      driver: json-file
      options:
        max-size: "1m"
        max-file: "2"
```

# 更新容器方式

## 容器自动更新
目前仅支持Amd64，Arm64

```sh
docker run -d \
    --name danmuji \
    --dns=223.5.5.5 \
    -p 本机端口:23333 \
    -e JAVA_OPTS="-Xms64m -Xmx128m" \
    -e JAVA_OPTS2="" (将在2.6.1版本之后启用，具体看映射配置说明的表格)  \
    -v 本机路径:/danmuji/Danmuji_log \
    -v 本机路径:/danmuji/guardFile \
    -v 本机路径:/danmuji/log \
    zzcabc/danmuji:autoupdate
```

**当版本更新的时候，你只要使用`docker restart danmuji`**

## 方案一——手动更新

 - 停止并删除容器
 - 拉取最新的镜像
 - 启动容器

## 方案二——自动更新
 
 - 使用 Watchtower 镜像，具体方式请百度

# 映射路径说明

此说明对应Docker容器内

| Docker运行参数 | 说明 |  
| :---: | :---: |
| `run -d` | 后台的方式保持运行 |
| `--name danmuji` | 设置Docker容器名称为danmuji(非必要设置) |
| `--dns=223.5.5.5` | Docker容器使用阿里DNS |
| `JAVA_OPTS="-Xms64m -Xmx128m -Duser.timezone=GMT+08"` | Java的基础配置，比如现在内存使用，设置Java时区等 |
| `JAVA_OPTS2="Java配置的参数"` | 如果你对Java比较熟悉可以配置该参数(已经启用) |
| `/danmuji/Danmuji_log` | 弹幕姬保存弹幕文件夹(非必须映射) |
| `/danmuji/guardFile` | 弹幕姬上舰私信文件夹(非必须映射) |
| `/danmuji/log` | 弹幕姬日志文件夹(非必须映射) |

Docker容器内部运行命令 `java ${JAVA_OPTS} -jar danmuji.jar ${JAVA_OPTS2}`

即使没有写明的映射路径，你也可以使用-v去映射

比如点击保存配置的时候，程序会在其所在目录下创建set文件夹，在set文件夹下生成set.json配置文件

你同样可以使用`-v 本地路径:/danmuji/set` 来存放配置文件

本docker镜像中程序会存放在/danmuji目录下，不要没事干映射Linux专有的文件夹

对于已经启动的容器，

你也可以使用`docker cp 容器名称:容器内部路径 本地路径` 来将文件或文件夹复制到本地路径下

比如使用`docker cp danmuji:/danmuji/DanmujiProfile /usr/DanmujiProfile` 即可将DanmujiProfile 复制到宿主机的/usr目录下

使用`docker cp danmuji:/danmuji/set /usr/set` 即可将set文件夹内的所有东西 复制到宿主机的/usr/set目录下

# TODO

- [x] 添加判断，如果releases的版本与DockerHub的版本一致，则不重新构建镜像

- [x] 每日定时构建镜像，当上有发布新版本最长也就时隔24小时更新

- [x] 使用源码构建镜像，解决上述注意事项(但我不会！！！！)  上面三项同时解决

- [x] 将镜像上传阿里镜像仓库
