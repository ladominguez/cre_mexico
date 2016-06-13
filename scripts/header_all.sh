#!/bin/sh
#i This script creates a list of latitude, longitude and event information
# Change first line. 


for k in `ls 20*.sac`; do

        # For SSN format 
	year=$(echo $k | cut -c 1-4)
	s=$(echo $k | cut -c 1-14)
        id=`grep  $s /home/u2/antonio/CRSMEX/Catalogs/EQ_ID_TABLE.DAT | awk '{print $2}' | tail -1`
	if [[ -z "$id" ]]; then
	     echo 'Empty ' $s
	else
		info=`grep $id /home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID.DAT`
        	echo $s $info
        fi
        unset s
        unset id
        unset info
        # For BSL format 
	#id=`echo $k | awk -F.  '{print $9}'`
	#sta=`echo $k | awk -F. '{print $1}'`
        #s=`grep  $id /home/u2/antonio/CRSMEX/Catalogs/EQ_ID_TABLE.DAT | awk '{print $1}'`
done > header_all2.aux 
grep Empty header_all2.aux
wc -l header_all2.aux
ls *.sac | wc -l
echo "The numbers above should be the same. DRLA"
