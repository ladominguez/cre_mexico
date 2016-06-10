function get_short_catalog()
%
% Returns a short catalog of events around a given (latitude/longitude)
%   Input:
%       Latitude:
%       Longitude:
%       Radius:
%
% ladominguez@ucla.edu     February 2013

%IG CAIG 17.0478 -100.2673   80
%IG PNIG 16.3923 -98.1271
%IG PLIG 18.3923 -99.5023
%IG ZIIG 17.6067 -101.4650   50
%IG MMIG 18.2885 -103.3456	  0
%IG TLIG 17.5627 -98.5665
%IG OXIG  17.0726 -96.7330
%IG MEIG 17.9249 -99.6197
%IG ARIG 18.2805 -100.3475
stnm      = ['CAIG'; 'PNIG'; 'PLIG'; 'ZIIG'; 'MMIG'; 'TLIG'; 'OXIG'; 'MEIG'; 'ARIG'];
stla      = [17.0478 
             16.3923 
             18.3923 
             17.6067 
             18.2885 
             17.5627 
             17.0726 
             17.9249
             18.2805];
stlo      = [-100.2673 
              -98.1271
              -99.5023
             -101.4650
             -103.3456
              -98.5665
              -96.7330
              -99.6197
             -100.3475];

radius    =        200;
forward_time =       2; % Time before the time in the catalog
year_file    =    2001; % Arbitraty year, start of the catalog.
channel      =   '_HZ';

%CATALOG = '/Users/antonio/Repeating/Catalogs/CATALOG.DAT';
CATALOG = '/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID_ROC.DAT'; 

fid = fopen(CATALOG);
out = fopen(['CAT' num2str(year_file) '.stp' ],'w');
cat = fopen(['TAB' num2str(year_file) '.info'],'w');

while 1
    linef = fgetl(fid);
    if ~ischar(linef)
        break
    end
    %sac
    year   = str2num(linef(1:4));
    month  = str2num(linef(6:7));
    day    = str2num(linef(9:10));
    hh     = str2num(linef(12:13));
    mm     = str2num(linef(15:16));
    ss     = str2num(linef(18:21));
    lat_eq = str2num(linef(27:31));
    lon_eq = str2num(linef(35:41));  
    id     =         linef(55:62);
    date   =         linef( 1:22);

    if year < year_file
	continue
    end
 
    if year > year_file
        year_file = year;
        fclose(out);
        fclose(cat);
	out = fopen(['CAT' num2str(year_file) '.stp' ],'w');
	cat = fopen(['TAB' num2str(year_file) '.info'],'w');
    end

    dist_eq_station = distkm([lat_eq lon_eq],[stla stlo]);
    ind_sta         = find(dist_eq_station <= radius);    
    
    % Records starts 2 minutes earlier
    serial_date  = datenum(year, month, day, hh, mm, ss);
    new_d        = serial_date - forward_time/(60*24);

    [Y,M,D,H,MI,S] = datevec(new_d);

    yearn   = num2str(Y);
    monthn  = num2str(M, '%.2d');
    dayn    = num2str(D, '%.2d');
    hhn     = num2str(H, '%.2d');
    mmn     = num2str(MI,'%.2d');
    ssn     = num2str(S, '%05.2f');
    ss_out  = num2str(floor(S), '%.2d');
    new_date = [yearn monthn dayn hhn mmn linef(18:19)];

    fprintf(cat, '%s %s %d', new_date, linef, numel(ind_sta));
    if isempty(ind_sta)
        fprintf(cat,'\n');
	continue
    end
    
    
    %new_d = d_num - 2/(60*24);
    [Y,M,D,H,MI,S] = datevec(new_d);
    
    yearn   = num2str(Y);
    monthn  = num2str(M, '%.2d');
    dayn    = num2str(D, '%.2d');
    hhn     = num2str(H, '%.2d');
    mmn     = num2str(MI,'%.2d');
    ssn     = num2str(S, '%05.2f');
    ss_out  = num2str(floor(S), '%.2d');
    new_date = [yearn monthn dayn hhn mmn linef(18:19)];
    org_date = [linef(1:4) linef(6:7) linef(9:10) linef(12:13) linef(15:16) ss];
    distance = distkm([stla stlo],[lat_eq lon_eq]);
    for k = 1:numel(ind_sta)
        disp(               ['WIN IG ' stnm(ind_sta(k),:) ' ' channel ' ' yearn '/' monthn '/' dayn ',' hhn ':' mmn ':' ssn ' +660s ' id])
        fprintf(out, '%s\n',['WIN IG ' stnm(ind_sta(k),:) ' ' channel ' ' yearn '/' monthn '/' dayn ',' hhn ':' mmn ':' ssn ' +660s ' id]);
        fprintf(cat, ' %s %5.1f',      stnm(ind_sta(k),:),  dist_eq_station(ind_sta(k)));
    end
    fprintf(cat,'\n');
    clear ind_sta
end
fclose(fid);
fclose(out);
fclose(cat);
