clear all
close all
clc

LOC = '/home/u2/antonio/CRSMEX/Catalogs/LOCATION_ID_2001_2014.DAT';
INP = 'output_xc9000_coh9000.dat';
OUT = 'test.dat';

A   = load(LOC);
N   = size(A,1);
fid = fopen(INP,'r');
out = fopen(OUT,'w');
lat = A(:,1);
lon = A(:,2);
dep = A(:,3);
mag = A(:,4);
id  = A(:,5);

disp(['Processing ' INP ])
while 1
	line = fgetl(fid);
	if ~ischar(line)
		break
	end
	ids  = str2num(line);
	ns   = numel(ids);
	
	loc  = zeros(ns,4);
    
    	for k = 1:ns
        	pointer  = find(ids(k) == id);
     		loc(k,1) = lat(pointer);
        	loc(k,2) = lon(pointer);
        	loc(k,3) = dep(pointer);
        	loc(k,4) = mag(pointer);
    	end
    	loc_mean = mean(loc);
    	loc_std  = std(loc);
    	latm     = loc_mean(1);
    	lonm     = loc_mean(2);
    	depm     = loc_mean(3);
    	magm     = loc_mean(4);
    	fprintf(out,'%6.3f %8.3f %5.1f %3.1f %3d %s\n',latm, lonm, depm, magm, ns, line);
    	%disp([num2str(latm,'%6.3f') ' ' num2str(lonm,'%8.3f') ' ' ... 
    	%      num2str(depm,'%5.1f') ' ' num2str(magn,'%3.1f') ' ' line])
    	clear loc
end             
disp (['Writting to ' OUT])
fclose(fid);
fclose(out);
