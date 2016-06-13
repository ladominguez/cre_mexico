#!/bin//sh


CAT=/home/u2/antonio/data/CRSMEX/Catalogs/CATALOG_2001_2014_ID.DAT

while read line; do
	echo 'Working on ' $line
	
        dist=$(grep $line sequence_distances.dat | awk '{print $2}')
        mag=$(awk '{print $4}' ./$line/locmag_mean.dat)
	touch ./$line/time_dist.dat
	while read line2; do
		grep $line2 $CAT | awk -v d=$dist -v m=$mag '{print $1 " " d " " m}' | sed 's/\//-/g' >> ./$line/time_dist.dat
	done < ./$line/ids.dat
done < directories.list
