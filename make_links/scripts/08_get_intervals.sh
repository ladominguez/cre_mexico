#!/bin/sh

INPUT=directories.list
OUTPUT=sequence_intervals.dat
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
                       ddif=$(./daysdiff $date1 $date2 )
		       echo $ddif | awk '{printf("%7.3f ",$1./365.0)}' >> $OUTPUT
		       #echo $ddif | awk '{printf("%7.3f \n ",   $1./365.0)}' >> long_list.dat
		       
                       date1=$date2
                else
                       date1=$(echo $line2 | awk '{print $1}')
		       echo - |	awk -v id=$seqid -v n=$N '{printf("%03d %2d ",id, n)}'  >> $OUTPUT
                fi
               	unset date2
	done < $line/time_dist.dat
	echo - | awk '{printf("\n")}' >> $OUTPUT
done < $INPUT
