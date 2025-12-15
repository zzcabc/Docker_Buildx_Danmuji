#!/bin/bash
set -e

WORKDIR=/danmuji
DANMUJI_LOG=/danmuji/Danmuji_log
GUARDFILE=/danmuji/guardFile
LOG=/danmuji/log

UMASK=${UMASK:-022}
PUID=${PUID:-0}
PGID=${PGID:-0}

echo "Starting Danmuji on Ubuntu with PUID:PGID ${PUID}:${PGID} and UMASK ${UMASK}"

# 检查必要命令
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "错误: $1 命令未找到，请确保已安装" >&2
        exit 1
    fi
}

check_command java
check_command gosu

# 检查JAR文件
if [ ! -f "danmuji.jar" ]; then
    echo "错误: danmuji.jar文件未找到" >&2
    exit 1
fi

# 设置umask
umask ${UMASK}

# Ubuntu用户管理
if [ -n "$PUID" ] && [ "$PUID" -ne 0 ]; then
    echo "配置用户权限: UID=${PUID}, GID=${PGID}"
    
    # 检查是否已存在相同UID的用户
    if ! getent passwd ${PUID} >/dev/null 2>&1; then
        # 检查是否已存在相同GID的组
        if ! getent group ${PGID} >/dev/null 2>&1; then
            echo "创建组: GID=${PGID}"
            groupadd -g ${PGID} danmuji
        fi
        
        echo "创建用户: UID=${PUID}, GID=${PGID}"
        # Ubuntu中使用--no-create-home避免创建家目录
        useradd -u ${PUID} -g ${PGID} --no-create-home -s /bin/bash danmuji
    else
        echo "用户UID=${PUID}已存在，跳过创建"
    fi
fi

# 创建目录
echo "创建目录结构..."
mkdir -p ${DANMUJI_LOG} ${GUARDFILE} ${LOG} 

# Ubuntu权限设置（更严格）
echo "设置目录权限..."
chown -R ${PUID}:${PGID} ${WORKDIR}

# 确保JAR文件可执行
chmod +x danmuji.jar

# 日志目录特殊权限
chmod 777 ${DANMUJI_LOG} ${LOG} ${GUARDFILE}

# 环境变量验证
echo "环境变量检查:"
echo "  JAVA_OPTS: ${JAVA_OPTS:-未设置}"
echo "  JAVA_OPTS2: ${JAVA_OPTS2:-未设置}"
echo "  CONFIG_FILE: ${CONFIG_FILE}"

# 设置locale（Ubuntu需要）
export LANG=${LANG:-C.UTF-8}
export LC_ALL=${LC_ALL:-C.UTF-8}

# 时区设置（可选）
if [ -n "$TZ" ]; then
    echo "设置时区: $TZ"
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
fi

# 构建Java命令
JAVA_CMD="java"
if [ -n "${JAVA_OPTS}" ]; then
    JAVA_CMD="${JAVA_CMD} ${JAVA_OPTS}"
fi
JAVA_CMD="${JAVA_CMD} -jar danmuji.jar"
if [ -n "${JAVA_OPTS2}" ]; then
    JAVA_CMD="${JAVA_CMD} ${JAVA_OPTS2}"
fi

echo "启动命令: ${JAVA_CMD}"
echo "工作目录: $(pwd)"
echo "Java版本: $(java -version 2>&1 | head -1)"

# 使用gosu切换用户执行（Ubuntu推荐使用gosu）
exec gosu ${PUID}:${PGID} bash -c "cd ${WORKDIR} && ${JAVA_CMD}"