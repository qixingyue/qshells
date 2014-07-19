#!/bin/sh

./configure \
--prefix=/usr     \
--mandir=/usr/share/man     \
--infodir=/usr/share/info     \
--sysconfdir=/private/etc     \
--with-apxs2=/usr/sbin/apxs     \
--enable-cli     \
--with-config-file-path=/etc     \
--with-config-file-scan-dir=/Library/Server/Web/Config/php     \
--with-libxml-dir=/usr     \
--with-openssl=/usr     \
--with-kerberos=/usr     \
--with-zlib=/usr     \
--enable-bcmath     \
--with-bz2=/usr     \
--enable-calendar     \
--disable-cgi     \
--with-curl=/usr     \
--enable-dba     \
--enable-exif     \
--enable-fpm     \
--enable-ftp     \
--with-gd     \
--with-freetype-dir=/data0/freetype2110/    \
--with-jpeg-dir=/data0/jpeg8d/    \
--with-png-dir=/data0/libpng1413/    \
--enable-gd-native-ttf     \
--with-icu-dir=/usr     \
--with-ldap=/usr     \
--with-ldap-sasl=/usr     \
--with-libedit=/usr     \
--enable-mbstring     \
--enable-mbregex     \
--with-mysql=mysqlnd     \
--with-mysqli=mysqlnd     \
--without-pear     \
--with-pdo-mysql=mysqlnd     \
--with-mysql-sock=/var/mysql/mysql.sock     \
--with-readline=/usr     \
--enable-shmop     \
--with-snmp=/usr     \
--enable-soap     \
--enable-sockets     \
--enable-sysvmsg     \
--enable-sysvsem     \
--enable-sysvshm     \
--with-tidy     \
--enable-wddx     \
--with-xmlrpc     \
--with-iconv-dir=/usr     \
--with-xsl=/usr     \
--enable-zip     \
--with-pcre-regex=/data0/pcre832/

make && sudo make install 

