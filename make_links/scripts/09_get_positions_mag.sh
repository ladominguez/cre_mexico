#!/bin/sh

INPUT=directories.list
OUTPUT=sequence_positions.dat
rm $OUTPUT
touch $OUTPUT
while read line;do
 	seqid=$(echo $line | awk -F_ '{print $2}')
	N=$(echo $line | awk -F_ '{print $3}' | cut -c 2-)
	echo $seqid $N | awk '{printf("%03d %02d ",$1,$2)}'  >> $OUTPUT
	awk '{printf("%6.3f %8.2f %5.2f %3.1f\n",$1,$2,$3,$4)}' $line/locmag_mean.dat >> $OUTPUT
done < $INPUT
