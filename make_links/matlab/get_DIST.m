clear all
close all

fid      = fopen('directories.list',   'r');
out      = fopen('sequence_distances', 'w');

while 1
    subdir = fgetl(fid);
    if ~ischar(subdir)
        break
    end
    A       = load(['./' subdir '/locmag_mean.dat']);
    dista   = coast_distance(A(1),A(2));

    disp(['Writing ' subdir])
    outline = [subdir ' ' num2str(dista,'%8.2f')];
    fprintf(out,'%s\n',outline);
    
end

fclose(out);
fclose(fid);
