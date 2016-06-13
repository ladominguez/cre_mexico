clear all
close all

fid      = fopen('directories.list','r');

while 1
    subdir = fgetl(fid);
    if ~ischar(subdir)
        break
    end
    disp(['Working on directory ' subdir])
    %output1 = ['./' subdir '/eq_latlon.dat'];
    output1 = ['/eq_latlon.dat'];
    extract_header_info('latlon', output1,subdir);

    output2 = ['/st_latlon.dat'];
    extract_header_info('stloc', output2,subdir);

end

fclose(fid);
