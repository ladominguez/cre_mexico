#!/bin/sh
catalog=/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID.DAT

for file in `ls *.sac`; do
	eqid=`echo $file | awk -F. '{print $9}'`
	line_aux=`grep $eqid $catalog`
	evla=`echo $line_aux | awk '{print $3}'`
	evlo=`echo $line_aux | awk '{print $4}'`
	evdp=`echo $line_aux | awk '{print $5}'`
	mag=`echo $line_aux  | awk '{print $6}'`
	echo "read " $file
	echo "ch evla " $evla
	echo "ch evlo " $evlo
	echo "ch evdp " $evdp
	echo "ch mag " $mag
	echo "ch kevnm " $eqid
	echo "write over" 
	echo $line_out
done
