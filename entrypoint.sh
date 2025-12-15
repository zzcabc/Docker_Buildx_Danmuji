#!/bin/sh
set -e

WORKDIR=/danmuji
DANMUJI_LOG=/danmuji/Danmuji_log
GUARDFILE=/danmuji/guardFile
LOG=/danmuji/log

UMASK=${UMASK:-022}
PUID=${PUID:-0}
PGID=${PGID:-0}

umask ${UMASK}
echo "Starting Danmuji with PUID:PGID ${PUID}:${PGID} and UMASK ${UMASK}"

# 检查并创建用户（如果需要）
if [ -n "$PUID" ] && [ "$PUID" -ne 0 ]; then
    echo "Creating user with PUID:$PUID and PGID:$PGID"
    if ! getent group "$PGID" >/dev/null 2>&1; then
        groupadd -g "$PGID" danmuji
    fi
    if ! getent passwd "$PUID" >/dev/null 2>&1; then
        useradd -u "$PUID" -g "$PGID" -d $WORKDIR -s /bin/sh danmuji
    fi
fi

mkdir -p ${DANMUJI_LOG} ${GUARDFILE} ${LOG}
echo "Ensured directories ${DANMUJI_LOG} ${GUARDFILE} ${LOG} exist"

#设置权限
chown -R ${PUID}:${PGID} ${DANMUJI_LOG} ${GUARDFILE} ${LOG}
chmod -R 755 ${DANMUJI_LOG} ${GUARDFILE} ${LOG}
echo "Set permissions for ${DANMUJI_LOG} ${GUARDFILE} ${LOG}"

exec sudo -u "#$PUID" -g "#$PGID" java ${JAVA_OPTS} -jar danmuji.jar ${JAVA_OPTS2}
