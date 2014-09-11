#!/bin/sh

opt=$1

case $opt in 
	"update" )
		svn update ;;

	"status" )
		svn status ;;

	"commit" ) 
		if [ $# -lt 2 ] ; then  echo "Message cant't be blank."; fi;
		message="$2"	
		svn ci -m "$message" ;;

	"reverse" ) 
		if [ $# -lt 2 ] ; then  echo "Message cant't be blank."; fi;
		svn update
		message="$2"
		head_version=$(svn info | grep "Revision:" | awk   '{print $2}')
		reverse_version=$(($head_version-1))
		svn merge -r HEAD:$reverse_version svn://pingxiaohua.com/pingxiaohua
		svn ci -m "$message" ;;
		
	"reverseto" ) 
		if [ $# -lt 3 ] ; then  echo "Message cant't be blank."; fi;
		svn update
		message="$3"
		head_version=$(svn info | grep "Revision:" | awk   '{print $2}')
		reverse_version=$2
		svn merge -r HEAD:$reverse_version svn://pingxiaohua.com/pingxiaohua
		svn ci -m "$message" ;;

	"log" )
		svn update
		head_version=$(svn info | grep "Revision:" | awk   '{print $2}')
		reverse_version=$(($head_version-32))
		svn log -v -r $head_version:$reverse_version
		;;

esac
