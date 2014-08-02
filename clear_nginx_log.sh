#!/bin/sh

d=$(date +"%Y%m%d")
cd /data0/nginx160/logs
nginx_pid=$(cat nginx.pid)
mv access.log tmp/access_${d}.log
gzip tmp/access_${d}.log
kill -USR1 $nginx_pid
cd tmp
find . -ctime +90 | xargs rm
