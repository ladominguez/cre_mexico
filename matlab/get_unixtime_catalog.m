clear all
close all

fid = fopen('/home/u2/antonio/CRSMEX/Catalogs/DATES_2001_2014.DAT')
out = fopen('/home/u2/antonio/CRSMEX/Catalogs/TIME_UNIX.DAT','w')

while 1
    line = fgetl(fid);
    if ~ischar(line)
        break
    end
    stamp = datenum(line,'yyyy/mm/dd HH:MM:SS');
    lout  = [line ' ' num2str(stamp,'%f')];
    fprintf(out,'%s\n',lout);
    disp(lout)
end

fclose(fid);
fclose(out);
