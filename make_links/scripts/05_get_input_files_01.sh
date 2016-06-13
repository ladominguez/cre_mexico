#!/bin/sh

while read line; do
	echo 'Working on ' $line
	echo $line | awk '{print "ls " $1 "/*.sac "}' | sh > tmp
        awk -F. '{print $9}' tmp | sort | uniq > $line/ids.dat
	
done < directories.list
