#!/bin/sh

INPUT=/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID_ROC.DAT
LIST=/home/u2/antonio/CRSMEX/collective/allfiles.info
DIROUT=/data/seis01/antonio/output_crsmex/2015JUN10
DISTFILE=/home/u2/antonio/CRSMEX/Catalogs/ID_LOC_DIST.DAT
OUTPUT=/data/seis01/antonio/output_crsmex/2015JUN10/REPORT_20150610.DAT
echo "Starting ..."
while read line;do        # Reads CATALOG_2001_2014_ID.DAT line by line 
	eqid=`echo $line | awk '{print $7}' | cut -c 2-`
	date=`echo $line | awk '{print $1}'`
	time=`echo $line | awk '{print $2}'`
	lat=`echo $line  | awk '{print $3}'`
	lon=`echo $line  | awk '{print $4}'`
	dep=`echo $line  | awk '{print $5}'`
	mag=`echo $line  | awk '{print $6}'`
 	no_ev=`grep $eqid $LIST | wc -l`
	grep $eqid $LIST | awk -F. '{print $1}' > tmp00.file # Counts the number of available waveforms
        grep $eqid $DIROUT/*.BSL > tmp01.file                # Seeks if the the earthquakes repeat.
	echo -n $eqid","$date","$time","$lat","$lon","$dep","$mag","$no_ev","
	while read line2;do
		stnm=`echo $line2`
		case $stnm in
			ARIG)
				dist=`grep $eqid $DISTFILE | awk '{print $5}'`
				;;
			CAIG)
				dist=`grep $eqid $DISTFILE | awk '{print $6}'`
				;;
			MEIG)
				dist=`grep $eqid $DISTFILE | awk '{print $7}'`
				;;
			MMIG)
				dist=`grep $eqid $DISTFILE | awk '{print $8}'`
				;;
			PLIG)
				dist=`grep $eqid $DISTFILE | awk '{print $9}'`
				;;
			PNIG)
				dist=`grep $eqid $DISTFILE | awk '{print $10}'`
				;;
			TLIG)
				dist=`grep $eqid $DISTFILE | awk '{print $11}'`
				;;
			ZIIG)
				dist=`grep $eqid $DISTFILE | awk '{print $12}'`
				;;
			OXIG)
				dist=`grep $eqid $DISTFILE | awk '{print $13}'`
				;;
                        PEIG)
                                dist=`grep $eqid $DISTFILE | awk '{print $14}'`
                                ;;
                        YOIG)
                                dist=`grep $eqid $DISTFILE | awk '{print $15}'`
                                ;;
			*)
				echo "Unkown station " $stnm
				exit
				;; 
		esac
		line3=`grep $stnm tmp01.file | tail -1` 
		if [[ -z "$line3" ]]
		then
			xcc=-9999
			coh=-9999
			ceq=-9999
		else
			xcc=`echo $line3 | awk '{print $3}'`
			coh=`echo $line3 | awk '{print $4}'`
			ceq=`echo $line3 | awk '{print $5}'`
			if [[ "$ceq" == "$eqid"  ]]
			then
				ceq=`echo $line3 | awk '{print $5}'`
			fi
		fi
		echo -n $stnm","$dist","$xcc","$coh","$ceq","
	done < tmp00.file 
	echo " "
	if [ -a tmp00.file ];then
		rm tmp00.file
	fi
	if [ -a tmp01.file ];then
		rm tmp01.file
	fi
done < $INPUT > $OUTPUT

echo "FINISH!!!!" 
