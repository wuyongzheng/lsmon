#!/bin/bash

grep '#DEFVAR' collect.sh | sed -e 's/.*DEFVAR //g' -e 's/:.//g' | tr ' ' '\n' | gawk 'BEGIN{x=2} {print "s/%"$1"%/"x"/g"; x++;}' > compile-template.sed

sed -f compile-template.sed <gnuplot.template >gnuplot.plot

rm -f compile-template.sed
