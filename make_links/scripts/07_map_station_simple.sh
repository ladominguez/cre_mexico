#!/bin/sh
# RAS earthquaes map
#
# Luis Antonio Dominguez - June 2014
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!! WARNING. IT ONLY RUNS ON ADELITA !!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

gmtset  BASEMAP_TYPE fancy PLOT_DEGREE_FORMAT ddd:mm:ssF
gmtset  PAGE_ORIENTATION landscape
gmtset  PAPER_MEDIA Custom_650x450
export  GMT_SHAREDIR=/sw/share/gmt

west=-104.5
east=-96
north=21.5
south=15
REG="-Rg$west/$east/$south/$north"
TICKS='-Ba2.0f1.0/a2.0f1.0WSne'
PROJ='-JM6i'
CITIES=worldcities.gmt
PSFILE=$1_map.eps
INPUT=$1
TITLE=$(echo $1 | tr '[:lower:]' '[:upper:]')
INPUT_EQ=$INPUT/eq_latlon.dat
INPUT_ST=$INPUT/st_latlon.dat
CPTFILE=wikifrance.cpt
MAP_FILES_DIR=/Users/antonio/Dropbox/CRSMEX/Kyoto_2015/map_repeaters
STATIONS=$MAP_FILES_DIR/dat/stations_ssn.dat

rm      $PSFILE 
echo $TITLE
psbasemap $REG  -P $PROJ -K $TICKS  -V --LABEL_FONT_SIZE=12 --ANNOT_FONT_SIZE=16 -Y0.5i > $PSFILE
pscoast   -R -P -J -O -K    -Slightblue    -Glightgray -Wthinner -V  -Di -N1    >> $PSFILE
psxy     -R -J -K -O $MAP_FILES_DIR/Pardo95/contours.dat -W1p,black -M               >> $PSFILE
pstext   -R -J -K -O -Gwhite -Wblack  -: << END >> $PSFILE
19.436  -99.329   9   0  1  BR Mexico City
16.150 -100.700   9 -25  1  BL Guerrero Gap
END
psxy -R -J -M -O -K -W2p  -Sf0.4i/0.1ilt   -Gblack  $MAP_FILES_DIR/gmt/trench.gmt    >> $PSFILE
psxy    -R -J -K -O -Gwhite -Wblack -Sv -V $MAP_FILES_DIR/gmt/SR01.gmt >> $PSFILE
psxy    -R -J -K -O -Gyellow -Wblack -Sa0.25i << END >> $PSFILE
-104.147 17.988 
 -97.167 15.254
END

pstext  -R -J -K -O -Gwhite -Wblack  << END >> $PSFILE
-103.441 16.432 10  60 1 BL 5.4 cm/yr
-102.152 16.346 11  60 1 BL 5.7
-100.342 15.517 11  60 1 BL 6.1
 -99.319 15.211 11  60 1 BL 6.4
 -97.248 14.522 11  60 1 BL 6.7
-104.300 17.800 11   0 1 TL 0km
 -97.267 15.200 10   0 1 TR 790km
END

psscale -E -D1.0i/0.75i/1.5i/0.25h -B0.5:"Magnitude":/:: \
       --LABEL_FONT_SIZE=12 -C$MAP_FILES_DIR/palettes/myseis.cpt  -O -K  >> $PSFILE
psxy -R -J -O -K -Sc0.1i -: -W1p/0 $INPUT_EQ  -Gwhite                    >> $PSFILE
psxy     $STATIONS -R -J -K -O -St0.2i -Gwhite   -Wthick -:              >> $PSFILE
psxy     $INPUT_ST                    -R -J -K -O -St0.2i -Gred     -Wthick -:        >> $PSFILE
# Mexico City Marker
psxy    -R -J -K -O -St0.16i -Glightgreen   -Wthick -:       <<      END   >> $PSFILE
19.45  -99.13
END
pstext   $STATIONS -R -J -K -O -: -X.1i -Gyellow -Wblack $STATIONS  >> $PSFILE
pstext -R -J -Gwhite -O -K -Wblack << END >> $PSFILE
# -103.50  15.300  16   0  1  MC Pacific Ocean
  -96.500  23.000  16   0  1  MC Gulf
  -96.500  22.500  16   0  1  MC of Mexico
# -98.200  16.550  12 -25  4  MC 20km
  -98.000  17.150  11 -23  4  MC 40km
  -97.850  18.050  11 -23  4  MC 60km
  -97.700  18.650  11 -18  4  MC 80km
  -97.550  19.050  11 -10  4  MC 100km
  -97.500  19.400  11 -10  4  MC 120km
  -98.000  21.250  18   0  4  MC $TITLE
# -103.00  17.200  16 -22  1  MC MAT
# -99.850  16.884   9   0  1  TR Acapulco
END


#####################    INSET #############################################
psbasemap -Rg-120/-80/10/35 -P -JM2.0i -O -K -Ba20.0/a10.0wsne -X-0.1i -Y3.65i \
          --BASEMAP_TYPE=plain --ANNOT_FONT_SIZE=8 >> $PSFILE 
pscoast   -R -P -J -O -K    -Slightblue    -Glightgray -Wthinner -V  -Dc -N1    >> $PSFILE
#psxy      -R -J -O -K -Wthinner -M  trench.gmt    >> $PSFILE
pstext             -R -J -GBlack -O -K << END >> $PSFILE
-100.0 32 12 0 1 MC USA
-102.5 25 8 0 1 MC MEXICO
END
psxy -R -J -O -Wthicker << END >> $PSFILE
-105  22
 -95  22
 -95  15
-105  15
-105  22
END
eps2eps $PSFILE TMP.EPS
mv    TMP.EPS $PSFILE
ps2raster -Tg $PSFILE
echo $PSFILE ' created. DONE'

#open $PSFILE
