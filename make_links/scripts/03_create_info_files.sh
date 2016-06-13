#!/bin/sh

INPUT=output_xc9500_coh9500.dat
OUTPUT=sequence_list_xc9500_coh9500.info

nl $INPUT  | awk '{printf("%03d %02d\n",$1, $6)}'  > id_N.tmp # Gets sequence ID and number of events in the sequence
cut -c31- $INPUT > event_ids.tmp

paste id_N.tmp event_ids.tmp > $OUTPUT
rm *.tmp

