clear all
close all
clc

fid     = fopen('repeaters.list');
out     = fopen('multiples.list','w');

% Warning crashes if the file has only one line
line = fgetl(fid);
file_master     = line( 1:14);
file_repeater_A = line(32:45);
counter         = 2;
out_line        = [file_master(1:8) ' ' file_repeater_A(1:8)];
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break
    end
    
    file_test       = line( 1:14);
    file_repeater_B = line(32:45);
    
    if strcmp(file_master,file_test)
        counter  = counter + 1;
        out_line = [out_line,' ',file_repeater_B(1:8)];
    else
        if counter > 2
            disp([num2str(counter),' ',out_line])
            fprintf(out,'%d %s\n',counter,out_line);
        end
        out_line    = [file_test(1:8),' ',file_repeater_B(1:8)];
        file_master = file_test;
        counter     = 2;
    end
end

fclose(fid);
fclose(out);