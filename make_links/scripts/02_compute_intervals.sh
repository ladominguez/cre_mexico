i#!/bin/sh

INPUT=output_xc9000_coh9000.dat
CAT=/home/u2/antonio/data/CRSMEX/Catalogs/CATALOG_2001_2014_ID.DAT
LIM=$(echo $INPUT | awk -F_ '{print $2 "_" $3}')
OUTPUT=time_intervals_$LIM

cut -c 1-26 $INPUT > tmp00 # WARNING Get the location and magnitude
cut -c 31-  $INPUT > tmp0  # WARNING Get events ids

if [ -a tmp2 ];then
	rm tmp2
fi

echo "Starting ..."
echo "Working on file " $INPUT
while read line;do
	echo $line | sed -e 's/\s\+/\n/g' > tmp

        nl=$(wc -l tmp | awk '{print $1}')
	counter=0
	touch tmp2
	echo $nl | awk '{printf(" : %2d : ", $1)}'
	for k in $(cat tmp); do
		grep $k $CAT >> tmp2
                counter=$((counter+1))
		if [[ "$counter" -gt 1 ]]; then
                       date2=$(tail -1 tmp2 | awk '{print $1}')
                       ddif=$(./daysdiff $date1 $date2 )
		       echo $ddif | awk '{printf("%7.3f ",$1./365.0)}'
                       date1=$date2
                else
                       date1=$(tail -1 tmp2 | awk '{print $1}')
                fi
               	unset date2
	done
	echo - | awk '{printf(" : ")}'
 	awk '{print $1}' tmp2 | paste -s -d ' '	
	#echo $line | awk '{printf("%s\n",$0)}'
	#cat tmp2
	rm tmp2 tmp
done < tmp0 > tmp000

paste -d" " tmp00 tmp000 > $OUTPUT


echo 'Writing ... ' $OUTPUT
rm tmp*

