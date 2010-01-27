#!/bin/bash

if [ ! -f config.rc ] ; then
	echo config.rc not found
	exit 1
fi
source config.rc

grep '#DEFVAR' config.rc | sed -e 's/.*DEFVAR //g' -e 's/:.//g' | tr ' ' '\n' | gawk 'BEGIN{x=2} {print "s/%"$1"%/"x"/g"; x++;}' >compile-template.sed
echo "s/%interval%/$INTERVAL/g" >>compile-template.sed
echo "s/%ncpu%/$NCPU/g" >>compile-template.sed

sed -f compile-template.sed <gnuplot.template >gnuplot.plot

rm -f compile-template.sed
