#!/bin/sh
RANCHER_SERVER_NAME=$(docker ps --format "{{.Image}} {{.Names}}" | grep -i "rancher/rancher" | cut -d' ' -f2)
TODAY_DATE=$(date +%Y%m%d)


docker stop ${RANCHER_SERVER_NAME}
#docker create --volumes-from ${RANCHER_SERVER_NAME} --name ${RANCHER_COPY_NAME} rancher/rancher:latest
#docker run --volumes-from ${RANCHER_COPY_NAME} -v /root/backup:/backup busybox tar pzcvf /backup/rancher-data-backup-2.4.5-${TODAY_DATE}.tar.gz /var/lib/rancher

tar -zcvpf /root/backup/rancher-data-backup-2.4.5-$TODAY_DATE.tar.gz --absolute-names /var/lib/rancher/

docker start ${RANCHER_SERVER_NAME}
docker rm $(docker ps -a -q)

PATH=/usr/bin:/usr/local/bin aws s3 cp /root/backup/rancher-data-backup-2.4.5-${TODAY_DATE}.tar.gz s3://***/rancher/ 

find /root/backup/* -type f -mtime +2 -print0 | xargs -0 rm -
