clear all
close all
clc

files = dir('PAIRS.DAT');
N     = numel(files);

for j = 1:N
	A=load(files(j).name);
	N=size(A,1);

	year1  = A(:,1);
	month1 = A(:,2);
	day1   = A(:,3);
	year2  = A(:,4);
	month2 = A(:,5);
	day2   = A(:,6);
	lat1   = A(:,7);
	lon1   = A(:,8);
	dep1   = A(:,9);
	lat2   = A(:,10);
	lon2   = A(:,11);
	dep2   = A(:,12);
	xc     = A(:,13)./10000;
	stla   = A(:,14);
	stlo   = A(:,15);

	for k=1:N
		Dates1      = [num2str(month1(k),'%.2d') '/' num2str(day1(k),'%.2d') '/' num2str(year1(k))];
		Dates2      = [num2str(month2(k),'%.2d') '/' num2str(day2(k),'%.2d') '/' num2str(year2(k))];
		dt_event(k) = daysdif(Dates1, Dates2);
		latm        = mean([lat1(k) lat2(k)]);
		lonm        = mean([lon1(k) lon2(k)]);
		depm        = mean([dep1(k) dep2(k)]);
		disth       = distance([latm lonm], [stla(k) stlo(k)])*111.11;
		dist(k)     = sqrt(disth^2 + depm^2);
		distc(k)    = coast_distance(latm, lonm); 
	end

	% Time between events | distance to the station | distance along the coast | correlation coerfficient
	out     = [dt_event' dist' distc' xc];
	outfile = ['DT_DIST_XC9500_' files(j).name(5:8) '.dat']; 
	disp(['Writing ' outfile ' ...'])
	save(outfile, 'out', '-ascii');
	clear year1 month1 day1 year2 month2 day2 lat1 lon1 dep1 lat2 lon2 dep2 xc stla stlo Dates1 Dates2
	clear dt_event latm lonm depm disth dist distc out outfile

end
exit
