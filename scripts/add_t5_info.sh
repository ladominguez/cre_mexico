cat MEIG_t5.dat | awk '{printf("read %s\nch t5 %f\nwh\ndc\n\n",$1,$2)}' > add_t5_header_info.macro
