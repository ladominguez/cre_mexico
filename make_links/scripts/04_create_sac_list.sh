#!/bin/sh

INPUT=sequence_list_xc9000_coh9000.info
DATA=xc_link_xc9000_coh9000_2015JUL02.raw.out

touch request_files.sh
while read line; do 
	# see notes
	ids=$(echo $line | awk '{print $1}')
	N=$(echo $line   | awk '{print $2}')
	OUTPUT=$(echo - | awk -v a=$ids -v b=$N '{printf("./sequence_%03d_N%02d/",a,b)}')
	touch $OUTPUT
	echo $line | sed -e 's/\s\+/\n/g' | sed '/^$/d' | tail -n+3 > tmp
	awk -v file=$DATA '{print "grep " $1  " " file}' tmp > tmp0
	while read line2; do 
		echo $line2 | sh | awk '{print $8}' | uniq | cut -c 1-4 > tmp2
		id=$(echo $line2 | awk '{print $2}')
		awk -v id=$id -v out=$OUTPUT '{print "cp /home/u2/antonio/CRSMEX/data/" $1 "/sac/" $1 ".*" id "*.sac " out}' tmp2 >> request_files.sh
	done < tmp0
	rm tmp*
done < $INPUT


# NOTES
# sed -e 's/\s\+/\n/g' - convert a line of N elements, into N rows
# sed '/^$/d'          - removes empty lines (usually the last line)
# tail -n+3            - remove the first two lines

