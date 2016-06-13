#!/bin/sh

INPUT=directories.list
OUTPUT=sequence_intervals_seconds_after_ometepec.dat
rm $OUTPUT
touch $OUTPUT

while read line;do
	echo 'Working on ' $line
 	seqid=$(echo $line | awk -F_ '{print $2}')
	N=$(echo $line | awk -F_ '{print $3}' | cut -c 2-)
	counter=0
	while read line2; do
                counter=$((counter+1))
		if [[ "$counter" -gt 1 ]]; then
                       date2=$(echo $line2 | awk '{print $1}')
                       ddif=$(../../scripts/daysdiffs $date1 $date2 )
		       dome=$(../../scripts/daysdiff  2012-03-12 $date1)
		       if [[ "$dome" -gt 0 ]];then
		       		echo $ddif | awk '{printf("%7.3f ",$1)}' >> $OUTPUT
		       fi
                       date1=$date2
                else
                       date1=$(echo $line2 | awk '{print $1}')
		       echo - |	awk -v id=$seqid -v n=$N '{printf("%03d %2d ",id, n)}'  >> $OUTPUT
                fi
               	unset date2
		unset dome
	done < $line/time_dist.dat
	echo - | awk '{printf("\n")}' >> $OUTPUT
done < $INPUT
