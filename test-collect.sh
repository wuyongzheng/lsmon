#!/bin/bash

if [ ! -f config.rc ] ; then
	echo config.rc not found
	exit 1
fi
source config.rc

readvars
