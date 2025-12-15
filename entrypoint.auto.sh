#!/bin/bash
set -e

# 设置环境变量
WORKDIR=/danmuji
DANMUJI_LOG=${WORKDIR}/Danmuji_log
GUARDFILE=${WORKDIR}/guardFile
LOG=${WORKDIR}/log

UMASK=${UMASK:-022}
PUID=${PUID:-1000}
PGID=${PGID:-1000}
GITHUB_PROXY=${GITHUB_PROXY:-}

echo "Starting Danmuji on Ubuntu with PUID:${PUID} PGID:${PGID}"

# 创建必要的文件夹函数
create_directories() {
    echo "Creating required directories..."
    mkdir -p "${DANMUJI_LOG}" "${GUARDFILE}" "${LOG}"
    
    # 设置权限
    if [ "${PUID}" != "0" ]; then
        chown -R ${PUID}:${PGID} "${DANMUJI_LOG}" "${GUARDFILE}" "${LOG}"
    fi
    chmod 755 "${DANMUJI_LOG}" "${LOG}"
    chmod 777 "${GUARDFILE}"  # 守护文件目录需要完全权限
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "错误: $1 命令未找到" >&2
        exit 1
    fi
}

# 检查必要命令
check_command curl
check_command wget
check_command unzip
check_command java
check_command gosu

# 获取最新版本
echo "检查最新版本..."
LATEST_VERSION=$(curl -sL ${GITHUB_PROXY}https://api.github.com/repos/BanqiJane/Bilibili_Danmuji/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "${LATEST_VERSION}" ]; then
    echo "错误: 无法获取最新版本" >&2
    echo "使用备用API..."
    LATEST_VERSION=$(curl -sL ${GITHUB_PROXY}https://api.github.com/repos/BanqiJane/Bilibili_Danmuji/releases/latest | jq -r '.tag_name' 2>/dev/null || echo "")
    
    if [ -z "${LATEST_VERSION}" ]; then
        echo "警告: 无法从GitHub获取版本，尝试使用本地文件"
        if [ -f "${WORKDIR}/danmuji.jar" ]; then
            echo "使用现有的danmuji.jar"
        else
            echo "错误: 没有可用的jar文件" >&2
            exit 1
        fi
    fi
fi

echo "最新版本: ${LATEST_VERSION:-未知}"

# 检查旧版本文件是否存在
if [ -f "${WORKDIR}/old" ]; then
    OLD_VERSION=$(cat "${WORKDIR}/old")
    echo "当前版本: ${OLD_VERSION}"
    
    # 记录新版本
    echo "${LATEST_VERSION}" > "${WORKDIR}/new"
    
    # 检查版本是否一致
    if [ "${LATEST_VERSION}" != "${OLD_VERSION}" ]; then
        echo "发现新版本: ${OLD_VERSION} -> ${LATEST_VERSION}"
        echo "开始更新..."
        
        # 下载新版本
        DOWNLOAD_URL="${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/${LATEST_VERSION}/danmuji.zip"
        echo "下载: ${DOWNLOAD_URL}"
        
        if wget -q --show-progress -O /tmp/danmuji.zip "${DOWNLOAD_URL}"; then
            # 备份旧文件
            if [ -f "${WORKDIR}/danmuji.jar" ]; then
                cp "${WORKDIR}/danmuji.jar" "${WORKDIR}/danmuji.jar.bak"
            fi
            
            # 解压新版本
            unzip -q -o /tmp/danmuji.zip -d /tmp/
            
            # 查找jar文件
            JAR_FILE=$(find /tmp -name "*.jar" -type f | head -1)
            
            if [ -n "${JAR_FILE}" ] && [ -f "${JAR_FILE}" ]; then
                # 复制jar文件
                cp "${JAR_FILE}" "${WORKDIR}/danmuji.jar"
                
                # 更新版本记录
                echo "${LATEST_VERSION}" > "${WORKDIR}/old"
                rm -f "${WORKDIR}/new"
                
                echo "更新完成!"
            else
                echo "错误: 在下载的ZIP中未找到jar文件" >&2
                if [ -f "${WORKDIR}/danmuji.jar.bak" ]; then
                    echo "恢复备份..."
                    cp "${WORKDIR}/danmuji.jar.bak" "${WORKDIR}/danmuji.jar"
                fi
            fi
            
            # 清理临时文件
            rm -rf /tmp/danmuji.zip /tmp/danmuji/
        else
            echo "错误: 下载失败，使用现有版本" >&2
            rm -f "${WORKDIR}/new"
        fi
    else
        echo "已经是最新版本"
        rm -f "${WORKDIR}/new"
    fi
else
    echo "首次运行容器"
    echo "下载文件..."
    
    # 创建版本文件
    echo "${LATEST_VERSION}" > "${WORKDIR}/old"
    
    # 下载初始版本
    DOWNLOAD_URL="${GITHUB_PROXY}https://github.com/BanqiJane/Bilibili_Danmuji/releases/download/${LATEST_VERSION}/danmuji.zip"
    echo "下载: ${DOWNLOAD_URL}"
    
    if wget -q --show-progress -O /tmp/danmuji.zip "${DOWNLOAD_URL}"; then
        # 解压文件
        unzip -q -o /tmp/danmuji.zip -d /tmp/
        
        # 查找jar文件
        JAR_FILE=$(find /tmp -name "*.jar" -type f | head -1)
        
        if [ -n "${JAR_FILE}" ] && [ -f "${JAR_FILE}" ]; then
            # 复制jar文件到工作目录
            cp "${JAR_FILE}" "${WORKDIR}/danmuji.jar"
            echo "下载完成"
        else
            echo "错误: 在ZIP中未找到jar文件" >&2
            exit 1
        fi
        
        # 清理临时文件
        rm -rf /tmp/danmuji.zip /tmp/danmuji/
    else
        echo "错误: 下载失败" >&2
        exit 1
    fi
fi

# 确保jar文件存在
if [ ! -f "${WORKDIR}/danmuji.jar" ]; then
    echo "错误: danmuji.jar不存在" >&2
    exit 1
fi

# 设置jar文件权限
chmod +x "${WORKDIR}/danmuji.jar"

# 创建用户和组（如果需要）
if [ "${PUID}" != "0" ]; then
    echo "设置用户权限: UID=${PUID}, GID=${PGID}"
    
    # 检查组是否存在
    if ! getent group ${PGID} >/dev/null 2>&1; then
        if getent group danmuji >/dev/null 2>&1; then
            echo "警告: 'danmuji'组名已存在但GID不同"
        else
            echo "创建组: GID=${PGID}"
            groupadd -g ${PGID} danmuji
        fi
    fi
    
    # 检查用户是否存在
    if ! getent passwd ${PUID} >/dev/null 2>&1; then
        if getent passwd danmuji >/dev/null 2>&1; then
            echo "警告: 'danmuji'用户名已存在但UID不同"
        else
            echo "创建用户: UID=${PUID}"
            useradd -u ${PUID} -g ${PGID} -d ${WORKDIR} -s /bin/bash -M danmuji
        fi
    fi
    
    # 设置工作目录所有权
    chown -R ${PUID}:${PGID} ${WORKDIR}
fi

# 创建目录
create_directories

# 环境变量检查
echo "环境变量:"
echo "  JAVA_OPTS: ${JAVA_OPTS:-未设置}"
echo "  JAVA_OPTS2: ${JAVA_OPTS2:-未设置}"
echo "  GITHUB_PROXY: ${GITHUB_PROXY:-未设置}"

# 构建Java命令
JAVA_CMD="java"
if [ -n "${JAVA_OPTS}" ]; then
    JAVA_CMD="${JAVA_CMD} ${JAVA_OPTS}"
fi
JAVA_CMD="${JAVA_CMD} -jar ${WORKDIR}/danmuji.jar"
if [ -n "${JAVA_OPTS2}" ]; then
    JAVA_CMD="${JAVA_CMD} ${JAVA_OPTS2}"
fi

echo "启动命令: ${JAVA_CMD}"
echo "Java版本: $(java -version 2>&1 | head -1)"

# 以指定用户身份运行
if [ "${PUID}" != "0" ]; then
    echo "以用户 danmuji (${PUID}:${PGID}) 身份运行"
    exec gosu ${PUID}:${PGID} bash -c "cd ${WORKDIR} && ${JAVA_CMD}"
else
    echo "以root身份运行"
    exec bash -c "cd ${WORKDIR} && ${JAVA_CMD}"
fi