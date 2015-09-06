#! /bin/sh

#useradd mysql -r -d /dev/null -s /sbinlogin 

MYSQL_PREFIX=/data0/mysql

#cmake \
	#-DDOWNLOAD_BOOST=1 \
	#-DWITH_BOOST=/data0/boost1.7 \
	#-DCMAKE_INSTALL_PREFIX=$MYSQL_PREFIX \
	#-DDEFAULT_CHARSET=utf8 \
	#-DDEFAULT_COLLATION=utf8_general_ci \
	#-DWITH_EXTRA_CHARSETS=all \
	#-DWITH_MYISAM_STORAGE_ENGINE=1 \
	#-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	#-DWITH_ZLIB=bundled \
	#-DWITH_READLINE=1 \
	#-DWITH_DEBUG=OFF \
	#-DENABLED_LOCAL_INFILE=1 \
	#-DENABLED_PROFILING=1 \
	#-DMYSQL_MAINTAINER_MODE=0 \
	#-DMYSQL_TCP_PORT=3306 \
	#-DMYSQL_DATADIR=$MYSQL_PREFIX/data \
	#-DMYSQL_UNIX_ADDR=$MYSQL_PREFIX/data/mysql.sock 
#
#make 
#make install
#
#chmod u+x ./scripts/mysql_install_db.sh
#mkdir -p $MYSQL_PREFIX/logs
./scripts/mysql_install_db.sh --basedir="$MYSQL_PREFIX" --datadir="$MYSQL_PREFIX/data" --user=mysql
# cp support-files/my-medium.cnf "$MYSQL_PREFIX/my.cnf"
cp my.cnf "$MYSQL_PREFIX/my.cnf"



###########
# 初始化库及修改密码
#/data0/mysql/bin/mysqld --initialize --explicit_defaults_for_timestamp 
# 会出现一个随机的密码
#mysql> alter user 'root'@'localhost' IDENTIFIED BY '123';
