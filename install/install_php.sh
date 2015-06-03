#!/bin/sh


#! /bin/sh
#
# Created by configure

'./configure' \
'--with-apxs2=/data0/apache2/bin/apxs' \
'--prefix=/data0/php5' \
'--disable-short-tags' \
'--with-curl' \
'--with-mysql=/data0/mysql5' \
'--with-pdo-mysql=/data0/mysql5' \
'--with-mysqli=/data0/mysql5/bin/mysql_config' \
'--with-config-file-path=/data0/php5/' \
'--sysconfdir=/data0/php5/etc/' \
'--with-pcre-dir' \
'--enable-bcmath' \
'--enable-zip' \
'--enable-pcntl' \
'--enable-mbstring' \
'--enable-inifile' \
'--enable-fpm' \
'--enable-shmop' \
"$@"


#if server is apache add this line after Type module
#AddType application/x-httpd-php .php .php3 .phtml .inc



#嵌入式安装mysql
 # './configure' \
 # '--prefix=/home/sinanet/run/php' \
 # '--disable-short-tags' \
 # '--with-curl' \
 # '--enable-mysqlnd' \
 # '--with-pdo-mysql' \
 # '--with-config-file-path=/home/sinanet/run/php/' \
 # '--sysconfdir=/home/sinanet/run/php/etc/' \
 # '--with-pcre-dir' \
 # '--enable-bcmath' \
 # '--enable-zip' \
 # '--enable-pcntl' \
 # '--enable-redis' \
 # '--enable-memcache' \
 # '--enable-memcached' \
 # '--enable-mbstring' \
 # '--enable-inifile' \
 # '--enable-fpm' \
 # '--enable-embedded-mysqli' \
 # "$@"
 # 
 # 
 # #'--with-mysql=/data0/mysql5' \
 # #'--with-pdo-mysql=/data0/mysql5' \
 # #'--with-mysqli=/data0/mysql5/bin/mysql_config' \
