#!/bin/sh


#! /bin/sh
#
# Created by configure

"./configure" \
"--prefix=/data0/apache22" \
"--enable-so" \
"--enable-modules=all" \
"--enable-mods-shared=most" \
"--enable-rewrite" \
"--with-apr=/data0/apr" \
"--with-apr-util=/data0/apr-util" \
"--with-pcre=/usr" \
"--enable-proxy" \
"--with-mpm=prefork" \
"--enable-cache" \
"--enable-disk-cache" \
"$@"


# split logs into one file every day.
#ErrorLog "|/data0/apache22/bin/rotatelogs /data0/apache22/logs/error_%Y-%m-%d.log 3600 480"

