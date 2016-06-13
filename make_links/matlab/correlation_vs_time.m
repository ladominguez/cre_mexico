clear all
close all
clc

%addpath('/Users/antonio/CJA_Msac1.1/io/')
%addpath('~/Dropbox/CRSMEX/matlab/')
%addpath('/Users/antonio/lib/')
addpath('/home/u2/antonio/CRSMEX/make_links/matlab')
addpath('~/CRSMEX/matlab/')
addpath('~/CJA_Msac1.1/io')
addpath('~/lib/')

starting_directory = 1;

low  = 1;
high = 8;

fid      = fopen('directories.list', 'r');
out      = fopen('sequence_correlations.dat','w');
stations = ['ARIG'; 'CAIG'; 'MEIG'; 'MMIG'; 'PNIG'; 'PLIG'; 'TLIG'; 'OXIG'; 'PEIG'; 'ZIIG'; 'YOIG'];
A        = importdata('sequence_distances.dat');
distance_set = A.data;
counter      = 0;


while 1
    counter = counter +1;
    subdir  = fgetl(fid);
    if ~ischar(subdir)
        break
    end
    sequence_id = subdir(10:12);
    id          = str2num(sequence_id);
    dist        = distance_set(id);
    for w = 1:size(stations,1)
        
        [files N] = ValidateComponent(stations(w,:),subdir);
       
        if N == 0 
            continue
        end
        
        master    = rsac(fullfile(pwd,subdir,files(1).name));
        master    = filter_sac(master,low,high,4);
        year      = master.nz(1);
        jday      = master.nz(2);
        header    = ['> ' sequence_id ' ' stations(w,:)];
        year_frac = num2str(year + jday/367,'%8.3f');
        lineout   = [year_frac ' ' num2str(dist,'%7.2f') ' 1.0'];
        fprintf(out,'%s\n',header);
        fprintf(out,'%s\n',lineout);
        
        for k = 2:N
            test   = rsac(fullfile(pwd,subdir,files(k).name));
            test   = filter_sac(test,low,high,4);
            
            [CorrelationCoefficient tshift S1 S2] = get_correlation_coefficient(master,test,25.5,'combined',0);
            year      = test.nz(1);
            jday      = test.nz(2);
            year_frac = num2str(year+jday/367,'%8.3f');
            lineout   = [year_frac ' ' num2str(dist,'%7.2f') ' ' num2str(CorrelationCoefficient)];
            fprintf(out,'%s\n',lineout);
        end
        
    end
end

fclose(fid);
fclose(out);
