awk '{printf("read %s.IG.??IG.?HZ.sac\nch evla %f\nch evlo %f\nch evdp %f\nch mag %f\nch kevnm %s\nwh\ndc all\n\n",$1,$4,$5,$6,$7,$8)}' header_all2.aux > header_all.macro
