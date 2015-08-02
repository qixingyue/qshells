#!/bin/sh

cd /Users/xingyue/sina/sinagit/sinapython/webpyapp
uwsgi -M -p 4 -t 30  -R 10000 -d /Users/xingyue/sina/sinagit/sinapython/webpyapp/uwsgi.log --uid=www --gid=www --enable-threads -s /tmp/uwsgi.sock -w demo
