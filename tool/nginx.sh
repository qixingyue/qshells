#!/bin/sh

#./configure --prefix=/data0/nginx160/ --with-pcre=../pcre-8.32 --with-cc-opt=" -Wno-deprecated-declarations" 

function recompile(){
	nginx_src=/Users/xingyue/outcode/source/nginx-1.6.0
	nginx_run=/data0/nginx160/
	pcre_path=/Users/xingyue/outcode/source/pcre-8.32
	module_base_path="/Users/xingyue/outcode/ngx_modules"
	module_names=$(ls -F $module_base_path | grep '/$')
	for m in $module_names
	do
		modules=" --add-module=$module_base_path/$m $modules"	
	done
	echo $modules 
	sleep 2
	cd $nginx_src
	make clean
	./configure --prefix=$nginx_run --with-debug $modules --with-pcre=$pcre_path \
   	--with-cc-opt="  -Wno-deprecated-declarations " && make && make install	
}

function ck_run(){
	c_r=$(ps aux | grep -v grep | grep -v sh | grep -v vim | grep "$1")
		if [ "$c_r" ]
			then
				return 1
		else
			return 0
				fi
}


function stop_action(){
	ck_run php-fpm
	
	if [ $? -eq 1 ] 
	then
	echo "stop php-fpm"
	sudo kill -INT `cat /usr/var/php-fpm-run/run/php-fpm.pid `
	else
	echo "php-fpm not running"
	fi
	
	ck_run nginx
	if [ $? -eq 1 ] 
	then
	echo "stop nginx"
	sudo /data0/nginx160/sbin/nginx -s stop
	else
	echo "nginx not running"
	fi
}

function start_action(){
	ck_run nginx
	if [ $? -eq 1 ] 
	then
	echo "nginx alreay running"
	else
	echo "start nginx"
	sudo /data0/nginx160/sbin/nginx
	fi
	
	ck_run php-fpm
	if [ $? -eq 1 ] 
	then
	echo "php-fpm alreay running"
	else
	echo "start php-fpm"
	sudo php-fpm
	fi
	curl -s http://localhost
}

opt="$1"

if [ "$opt" = "" ] ; then opt="start" ; fi

case $opt in 
	"start" )
		start_action;;
	"stop" ) 
		stop_action;;	
	"restart" )
		stop_action
		start_action;;
	"recompile" )
		stop_action
		recompile;;
	"debug"	 )
		stop_action
		sudo gdb /data0/nginx160/sbin/nginx ;;
	"single" )
		sudo /data0/nginx160/sbin/nginx ;;
	"closedaemon" )
		sed "s/daemon on/daemon off/g" /data0/nginx160/conf/nginx.conf > tmp.conf
		mv tmp.conf  /data0/nginx160/conf/nginx.conf ;;
	"opendaemon" )
		sed "s/daemon off/daemon on/g" /data0/nginx160/conf/nginx.conf > tmp.conf
		mv tmp.conf  /data0/nginx160/conf/nginx.conf ;;
	"daemonstate" )
		cat /data0/nginx160/conf/nginx.conf | grep daemon
esac

