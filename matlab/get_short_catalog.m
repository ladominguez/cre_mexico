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
%IG YOIG 16.8578  -97.5459    0
%IG PEIG 15.9986  -97.1472    0
STA_ID    =     'OMIG';
latitude  =      16.30;
longitude =     -98.30;
radius    =         80;
forward_time =       2; % Time before the time in the catalog
year_file    =    2012; % Arbitraty year, start of the catalog.
channel      =   'HHZ';

%CATALOG = '/Users/antonio/Repeating/Catalogs/CATALOG.DAT';
CATALOG = '/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID_ROC.DAT'; 

fid = fopen(CATALOG);
out = fopen([STA_ID '_' num2str(year_file) '.' channel '.stp' ],'w');
cat = fopen([STA_ID '_' num2str(year_file) '.' channel '.info'],'w');
fpd = fopen([STA_ID '_request.parameters'],'w');

fprintf(fpd,'Station   = %s\nLatitude  = %f\nLongitude = %f\nRadius    = %f\n%s\n',...
    STA_ID, latitude, longitude, radius,CATALOG);
fclose(fpd)

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

    if year < year_file
	continue
    end
 
    if year > year_file
        year_file = year;
        fclose(out);
        fclose(cat);
        out = fopen([STA_ID '_' num2str(year_file) '.' channel '.stp' ],'w');
        cat = fopen([STA_ID '_' num2str(year_file) '.' channel '.info'],'w');
    end
    
    % Records starts 2 minutes earlier
    serial_date  = datenum(year, month, day, hh, mm, ss);
    new_d        = serial_date - forward_time/(60*24);
    
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
    distance = distkm([latitude longitude],[lat_eq lon_eq]);
    if distance <= radius
        disp(['WIN IG ' STA_ID ' ' channel ' ' yearn '/' monthn '/' dayn ',' hhn ':' mmn ':' ssn ' +660s'])
        fprintf(out, '%s\n',['WIN IG ' STA_ID ' BHZ ' yearn '/' monthn '/' dayn ',' hhn ':' mmn ':' ssn ' +660s']);
        fprintf(cat, '%s %s\n',new_date, linef);
	disp(['X' linef(18:19) 'X'])
        disp([new_date linef])
    end
end
fclose(fid);
fclose(out);
fclose(cat);


%load handel
%sound(y,Fs)


%% RESERVE
