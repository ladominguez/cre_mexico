clear all
close all

A = rsac('./test_data/20011105104504.IG.PLIG.BHZ.sac');
B = rsac('./test_data/20040403234914.IG.PLIG.BHZ.sac');
C = rsac('./test_data/20080925043418.IG.PLIG.BHZ.sac');

Win = 1.28;


Win_sp = ceil(Win/A.dt);

S=spectrogram(A.d)