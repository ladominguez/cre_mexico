grep Empt header_all2.aux | awk '{print $2}' | cut -c 1-12 | awk '{print "grep " $1 " ~/CRSMEX/Catalogs/EQ_ID_TABLE.DAT"}' | sh
