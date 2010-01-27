#!/bin/bash

if [ ! -f config.rc ] ; then
	echo config.rc not found
	exit 1
fi
source config.rc

if [ $# -ne 2 ] ; then
	echo Usage: plot.sh period points
	echo Example: plot.sh 1 120
	exit 1
fi
period=$1
points=$2
data_points=`expr $points \* $period`

cd $LSMONDIR

rm -f /tmp/lsmon/lsmon-pd.tsv
if ! cat lsmon-????????????.tsv /tmp/lsmon/lsmon-current.tsv | \
	tail -n $data_points | \
	gawk -v period=$period -f genpd.awk > /tmp/lsmon/lsmon-pd.tsv ; then
	echo failed 1
	exit 1
fi

rm -f /tmp/lsmon/plot-*.png

if ! $GNUPLOT gnuplot.plot ; then
	echo failed 2
	exit 1
fi
