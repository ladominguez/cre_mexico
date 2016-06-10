clear all
close all
clc

input    = load('/home/u2/antonio/CRSMEX/Catalogs/ID_LOC.DAT');
stations = importdata('/home/u2/antonio/CRSMEX/Catalogs/STATIONS.DAT');

Neq = size(input,1);
Nst = size(stations.data,1);

dist = zeros(Neq, Nst);

for k = 1:Nst
	dist_epi  = distance(input(:,2:3),stations.data(k,:))*111.11;
	dist_hyp  = sqrt(dist_epi.^2 + input(:,4));
	dist(:,k) = dist_hyp;
end

save DIST.TMP dist -ascii
!awk '{printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)}' DIST.TMP > TMP
!mv TMP DIST.TMP
