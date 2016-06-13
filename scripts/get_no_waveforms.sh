#!/bin/sh

INPUT=/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID_ROC.DAT
LIST=/home/u2/antonio/CRSMEX/collective/allfiles.info
DIROUT=/home/u2/antonio/output_crsmex/2015MAY27
DISTFILE=/home/u2/antonio/CRSMEX/Catalogs/ID_LOC_DIST.DAT
OUTPUT=/home/u2/antonio/CRSMEX/scripts/REPORT_20150527.DAT
echo "Starting ..."
while read line;do        # Reads CATALOG_2001_2014_ID.DAT line by line
	eqid=`echo $line | awk '{print $7}' | cut -c 2-`
	date=`echo $line | awk -F/ '{print $1}'`
	time=`echo $line | awk '{print $2}'`
	lat=`echo $line  | awk '{print $3}'`
	lon=`echo $line  | awk '{print $4}'`
	dep=`echo $line  | awk '{print $5}'`
	mag=`echo $line  | awk '{print $6}'`
 	no_ev=`grep $eqid $LIST | wc -l`
        echo $lat $lon $no_ev $date 
done < $INPUT 



