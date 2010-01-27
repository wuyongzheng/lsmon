#!/bin/bash

if [ ! -f config.rc ] ; then
	echo config.rc not found
	exit 1
fi
source config.rc

mkdir /tmp/lsmon >/dev/null 2>&1
chmod -f 777 /tmp/lsmon
rm -f /tmp/lsmon/lsmon-current.tsv >/dev/null 2>&1
ts=`date +%s`
count=0
until [ -f stop ] ; do
	echo `echo $ts ; readvars` | tr ' ' '\t' >>/tmp/lsmon/lsmon-current.tsv

	count=`expr $count + 1`
	if [ $count -ge 1024 ] ; then
		count=0
		mv /tmp/lsmon/lsmon-current.tsv `date +lsmon-%y%m%d%H%M%S.tsv`
	fi

	ts1=`date +%s`
	if [ $INTERVAL -gt `expr $ts1 - $ts` ] ; then
		sleep `expr $INTERVAL - $ts1 + $ts`
	fi
	ts=`expr $ts + $INTERVAL`
done

if [ -f /tmp/lsmon/lsmon-current.tsv ] ; then
	mv /tmp/lsmon/lsmon-current.tsv `date +lsmon-%y%m%d%H%M%S.tsv`
fi
