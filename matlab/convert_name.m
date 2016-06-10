% This code computes an equivalence table file filename_id.dat for later
% conversion of the filenames of the stations for compatibility with 
% Taka'Aki's code. Original filenames staterte with a sequence of numbers
% which corresponds to the origin time of the eq. This must be changed for
% a filename with the eq. id in the following format.
% Luis filename format
%  yyyymmddhhmmss.net.station.channel.sac 
%  20140527220136.IG.ARIG.BHZ.sac (example)
% Taira filename format
%  station.net.channel..D.year.jd.hhmmss.event_id.sac
%
%               antonio@seismo.berkeley.edu   - Sep 2014


CATALOG = '/home/u2/antonio/CRSMEX/Catalogs/CATALOG_2001_2014_ID.DAT'; 
disp(CATALOG)
fid = fopen(CATALOG);
out = fopen('filename_id.dat' ,'w');

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
    eq_id  = linef(55:end);
    
    % Records starts 2 minutes earlier
    serial_date  = datenum(year, month, day, hh, mm, ss);
    new_d        = serial_date - 2/(60*24);
    
    %new_d = d_num - 2/(60*24);
    [Y,M,D,H,MI,S] = datevec(new_d);
    
    yearn   = num2str(Y);
    monthn  = num2str(M, '%.2d');
    dayn    = num2str(D, '%.2d');
    hhn     = num2str(H, '%.2d');
    mmn     = num2str(MI,'%.2d');
    ssn     = num2str(S, '%05.2f');
    ss_out  = num2str(floor(S), '%.2d');
    new_date = [yearn monthn dayn hhn mmn ssn ss];
    org_date = [linef(1:4) linef(6:7) linef(9:10) linef(12:13) linef(15:16) ss];
    %fprintf(out, '%s\n',['WIN IG ' STA_ID ' BHZ ' yearn '/' monthn '/' dayn ',' hhn ':' mmn ':' ssn ' +660s']);
    %fprintf(cat, '%s %s\n',new_date, linef);
    fprintf(out,'%s\n',[yearn monthn dayn hhn mmn linef(18:19) ' ' eq_id ]);
end
disp(['Done.'])
fclose(fid);
fclose(out);


%load handel
%sound(y,Fs)


%% RESERVE
