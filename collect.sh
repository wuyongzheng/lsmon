#!/bin/bash

# ========== BEGIN CONFIG ==========
INTERVAL=200
# ==========  END CONFIG  ==========

function readvars () {
	#DEFVAR lo-downb:a lo-downp:a lo-upb:a lo-upp:a eth0-downb:a eth0-downp:a eth0-upb:a eth0-upp:a
	grep : /proc/net/dev | sed -e 's/:/ /g' -e 's/  */ /g' -e 's/^ //g' | sort | cut -d ' ' -f 2,3,10,11
	#DEFVAR sda-msr:a sda-msw:a sda-msa:a sdb-msr:a sdb-msw:a sdb-msa:a sdc-msr:a sdc-msw:a sdc-msa:a
	grep ' sd[abc] ' /proc/diskstats | sed -e 's/:/ /g' -e 's/  */ /g' -e 's/^ //g' | cut -d ' ' -f 7,10,13
	#DEFVAR sda1-r:a sda1-w:a sda2-r:a sda2-w:a sda3-r:a sda3-w:a sda4-r:a sda4-w:a
	#DEFVAR sdb6-r:a sdb6-w:a sdc4-r:a sdc4-w:a
	grep -E ' sd(a1)|(a2)|(a3)|(a4)|(b6)|(c4) ' /proc/diskstats | sed -e 's/:/ /g' -e 's/  */ /g' -e 's/^ //g' | cut -d ' ' -f 5,7
	#DEFVAR cpu-u:a cpu-s:a cpu-i:a
	#DEFVAR cpu0-u:a cpu0-s:a cpu0-i:a
	#DEFVAR cpu1-u:a cpu1-s:a cpu1-i:a
	#DEFVAR cpu2-u:a cpu2-s:a cpu2-i:a
	#DEFVAR cpu3-u:a cpu3-s:a cpu3-i:a
	#DEFVAR cpu4-u:a cpu4-s:a cpu4-i:a
	#DEFVAR cpu5-u:a cpu5-s:a cpu5-i:a
	#DEFVAR cpu6-u:a cpu6-s:a cpu6-i:a
	#DEFVAR cpu7-u:a cpu7-s:a cpu7-i:a
	grep ^cpu /proc/stat | sed -e 's/:/ /g' -e 's/  */ /g' -e 's/^ //g' | cut -d ' ' -f 2,4,5
	#DEFVAR sys-intr:a sys-ctxt:a proc:a
	grep -E '(intr)|(ctxt)|(processes)' /proc/stat | cut -d ' ' -f 2
	#DEFVAR ping-dns-l:i ping-dns-t:i
	ping -c 5 -W 10 137.132.85.2 >/tmp/lsmon/ping.out
	grep transmitted /tmp/lsmon/ping.out | sed -e 's/.*received, //g' -e 's/% packet loss.*//g'
	grep -h rtt /tmp/lsmon/ping.out dummyrtt.txt | head -n 1 | cut -d / -f 5
	#DEFVAR ping-google-l:i ping-google-t:i
	ping -c 5 -W 10 www.google.com >/tmp/lsmon/ping.out
	grep transmitted /tmp/lsmon/ping.out | sed -e 's/.*received, //g' -e 's/% packet loss.*//g'
	grep -h rtt /tmp/lsmon/ping.out dummyrtt.txt | head -n 1 | cut -d / -f 5
	#DEFVAR ping-sina-l:i ping-sina-t:i
	ping -c 5 -W 10 www.sina.com.cn >/tmp/lsmon/ping.out
	grep transmitted /tmp/lsmon/ping.out | sed -e 's/.*received, //g' -e 's/% packet loss.*//g'
	grep -h rtt /tmp/lsmon/ping.out dummyrtt.txt | head -n 1 | cut -d / -f 5
}

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
