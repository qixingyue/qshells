#!/bin/sh

cd /data1/deploy/newishare/

#git reset --hard HEAD
#git pull origin master
unset GIT_DIR
git pull

rsync -avzq --delete --exclude='.git' --password-file=/data1/deploy/.git_rysnc_password . rsync_newishare@10.69.2.90::newishare/ 
