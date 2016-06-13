#!/bin/sh
# WARNING. Runs better in Toronto
# Example of INPUT file
# DT_DIST_COAST_XC9500_COH9500.DAT
#
# sh recurrence_time.sh DT_DIST_COAST_XC9500_COH9500.DAT 
#
# June 2015, Luis A. Dominguez. ladominguez@seismo.berkeley.edu
#
rm .gmtdefaults4
gmtset PLOT_DATE_FORMAT o ANNOT_FONT_SIZE_PRIMARY +9p
gmtset PAGE_ORIENTATION landscape
gmtset INPUT_DATE_FORMAT yyyy-mm-dd
gmtset GRID_PEN 0.1tap
gmtset CHAR_ENCODING Standard+

INPUT=$1/time_dist.dat
FILE=$1_time.eps
DATA_DIR=/Users/antonio/Dropbox/CRSMEX/Kyoto_2015/time_distance
SSE2006=$DATA_DIR/input_files/SSE_2006.DAT
SSE2001_2002=$DATA_DIR/input_files/SSE_2001_2002.DAT
SSE2009_2010=$DATA_DIR/input_files/SSE_2009_2010.DAT
M5_2001_2014=$DATA_DIR/input_files/M5_2001_2014.DAT
M6_2001_2014=$DATA_DIR/input_files/M6_2001_2014.DAT
M6_DIST=$DATA_DIR/input_files/M6_DIST.DAT
CPT1=$DATA_DIR/scripts/myseis.cpt

rm $FILE
psbasemap -R2001T/2014-10T/0/850 -JX10i/-5i -Glightyellow \
   -Ba1Yf3og1YSn:"Time":/a50f10We:"Distance along the coast [km]": -K -Glightyellow > $FILE

# plot Slow Slip Events
psxy -R -J -K -O -V -Glightgray $SSE2006      -Wthicker,red >> $FILE
psxy -R -J -K -O -V -Glightgray $SSE2001_2002 -Wthicker,red >> $FILE
psxy -R -J -K -O -V -Glightgray $SSE2009_2010 -Wthicker,red >> $FILE

# Symbol SSE for legend
psxy -R -J -K -O -V -Glightgray  -Wthicker,red << END >> $FILE
2001-03-01  60.0
2001-03-01  80.0
2001-09-01  80.0
2001-09-01  60.0
END

# Acapulco Line
psxy -R -J -K -O -V -W3p,blue << END >> $FILE
2001-01-01 464.75
2014-10-31 464.75
END

# Ometepec Line
psxy -R -J -K -O -V -W3p,blue << END >> $FILE
2001-01-01 588.9
2014-10-31 588.9
END

# Tecpan Line
psxy -R -J -K -O -W3p,blue << END >> $FILE
2001-01-01 371.0
2014-10-31 371.0
END

psxy -R -J -K -O -W1p,black,-- -M << END >> $FILE
> Michoacan state limit
2001-01-01 180.68
2014-10-31 180.68
> Oaxaca state limit
2001-01-01 623.17
2013-10-31 623.17
END
psxy -R -J -K -O -Wthick                  -M $INPUT >> $FILE
psxy -R -J -K -O -Wthick -Sc0.25 -C$CPT1  -M $INPUT >> $FILE

#while read line; do
#    touch tmp.file
#    line1=`echo $line | awk '{print $1, $3, $4, $5}'`
#    line2=`echo $line | awk '{print $2, $3, $4, $5}'`
#    echo $line1 >  tmp.file
#    echo $line2 >> tmp.file
#    psxy -R -J -K -O -Wthick -M                 tmp.file >> $FILE 
#    psxy -R -J -K -O -Sc0.25 -M  -C$CPT1 -Wthin tmp.file >> $FILE 
#    rm tmp.file
#done < $INPUT

#psxy -R -J -K -O -V    -Sc0.15 -Gred   -Wthin      << END >> $FILE
#2001-06-15 60.0
#END

# Repeater legend
psxy -R -J -K -O -V -Sc0.25 -Gwhite -Wthin << END >> $FILE
2001-06-15 30.0
END

psscale -D4.0i/0.75i/2i/0.25h -B0.2:"Magnitude":/:: --LABEL_FONT_SIZE=15 -C$CPT1 -O -K >> $FILE

psxy -R -J -K -O -M -V -W4p,darkgreen $M6_DIST >> $FILE

pstext -R -J -K -O << END >> $FILE
2001-02-01 583.0 16 0 4 BL Ometepec
2001-02-01 617.0 16 0 4 BL Oaxaca
2001-02-01 165.0 16 0 4 BL Michoacan
2001-02-01 366.0 16 0 4 BL Tecpan
2001-02-01 461.0 16 0 4 BL Acapulco
2001-10-05  65.0 12 0 4 ML @;black;SSE@;;
2001-10-05  95.0 12 0 4 ML @;black;EQ @~\263@~ 6.0@;;
2001-10-05  25.0 12 0 4 ML @;black;Repeater@;;
#2001-10-05  30.0 12 0 4 ML @;black;Detected by @~\263@~2 stations@;;
2002-02-01 336.0 12 0 4 BC @;blue;M7.65@;;
2006-06-30 336.0 12 0 4 BC @;blue;M7.49@;;
2010-01-01 336.0 12 0 4 BC @;blue;M7.53@;;
END


# Overhead plot
psbasemap -R2001T/2014-10T/5/7.5 -JX10i/1i -Ba1Yf3og1YSn/a1f0.5We:"Mw": -K -O -Y5.3i -Glightblue  >> $FILE
pstext -R -J -K -O -N << END >> $FILE
2008-01-01 7.7 18 0 4 BC Correlation Coefficient @~\263@~ $XC - Coherence @~\263@~ $COH
END

while read line; do
    touch tmp.file
    date1=`echo $line | awk '{print $1}'`
    mag1=`echo $line | awk '{print $2}'`
    line1=`echo $date1 '5.0'`
    echo $line1 >  tmp.file
    echo $line  >> tmp.file
    psxy -R -J -W2p,black -K -O tmp.file >> $FILE
    rm tmp.file
done < $M5_2001_2014

while read line; do
    touch tmp.file
    date1=`echo $line | awk '{print $1}'`
    mag1=`echo $line | awk '{print $2}'`
    line1=`echo $date1 '5.0'`
    echo $line1 >  tmp.file
    echo $line  >> tmp.file
    psxy -R -J -W2p,red -K -O tmp.file >> $FILE
    rm tmp.file
done < $M6_2001_2014

#open $FILE

