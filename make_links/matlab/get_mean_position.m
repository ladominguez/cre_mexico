clear all
close all

fid      = fopen('directories.list','r');

while 1
    subdir = fgetl(fid);
    if ~ischar(subdir)
        break
    end
    disp(['Working on directory ' subdir]);
    data    = extract_header_info('locmag', 'locmag.dat',subdir);
    A       = load(['./' subdir '/locmag.dat']);
    Amean   = mean(A);
    output1 = ['./' subdir '/locmag_mean.dat'];
    out     = fopen(output1, 'w' );
    disp(['Writing ' output1])
    outline = [num2str(Amean(1),'%6.3f') ' ' num2str(Amean(2),'%8.3f') ' ' ...
               num2str(Amean(3),'%5.1f') ' ' num2str(Amean(4),'%3.1f')];
    fprintf(out,'%s\n',outline);
    fclose(out);
    
end

fclose(fid);
