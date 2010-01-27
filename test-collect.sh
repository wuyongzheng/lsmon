#!/bin/bash

if [ ! -f config.rc ] ; then
	echo config.rc not found
	exit 1
fi
source config.rc

echo -n 'expected var count '
grep '#DEFVAR' config.rc | sed -e 's/.*DEFVAR //g' | wc -w
vars=`readvars`
echo -n 'actual var count '
echo $vars | wc -w
echo 'vars:'
echo $vars
