#!/bin/sh

docker stop rancher_host
sleep 5
docker create --volumes-from rancher_host --name rancher-data-$(date +%Y%m%d) rancher/rancher:stable
sleep 5
docker run --volumes-from rancher-data-$(date +%Y%m%d) -v /home/bell/test/backup:/backup:z busybox tar pzcvf /backup/rancher-data-backup-2.4.4-$(date +%Y%m%d).tar.gz /var/lib/rancher
PID=$!
docker start rancher_host
wait $PID
aws s3 cp --recursive /home/bell/test/backup/ s3://rancher-data-backup/
