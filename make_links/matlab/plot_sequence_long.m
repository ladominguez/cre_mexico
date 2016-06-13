clear all
close all
clc

addpath('/Users/antonio/CJA_Msac1.1/io/')
addpath('~/Dropbox/CRSMEX/matlab/')
addpath('/Users/antonio/lib/')

starting_directory = 1;

low  = 1;
high = 8;

fid      = fopen('directories.list', 'r');
stations = ['ARIG'; 'CAIG'; 'MEIG'; 'MMIG'; 'PNIG'; 'PLIG'; 'TLIG'; 'OXIG'; 'PEIG'; 'ZIIG'; 'YOIG'];
counter = 0;

while 1
    counter = counter +1;
    subdir  = fgetl(fid);
    if ~ischar(subdir)
        break
    end
    sequence_id = subdir(10:12);
    if counter >= starting_directory
        for w = 1:size(stations,1)
            close all
            [files N] = ValidateComponent(stations(w,:),subdir);
            
            if N <= 5
                continue
            end
            
            a   = rsac(fullfile(pwd,subdir,files(1).name));
            a   = filter_sac(a,low,high,2);
            dta = a.dt;
            
            colors = ['r' 'b' 'c' 'g'];
            
            for k = 2:N
                b   = rsac(fullfile(pwd,subdir,files(k).name));
                b   = filter_sac(b,low,high,2);
                dtb = b.dt;
                
                [CorrelationCoefficient tshift S1 S2] = get_correlation_coefficient(a,b,25.5,'combined',0);
                ta = 0:dta:(numel(S1) - 1)*dta;
                tb = 0:dtb:(numel(S2) - 1)*dtb;
                
                if k == 2
                    figure(1)
                    subplot(5,1,1)
                    plot(ta, normalize(S1),'k','LineWidth',1.5)
                    grid
                    axis tight
                    title(files(1).name,'Fontsize',16)
                    
                    figure(ceil((N+1)/5))
                    subplot(5,1,mod(N,5)+1)
                    plot(ta, normalize(S1),'k')
                    grid
                    axis tight
                    
                end
                setw
                setwin([7 -8  1231  765])
                
                figure(ceil(k/5))
                setw
                setwin([7 -8  1231  765])
                subplot(5,1,mod(k-1,5)+1)
                S2shift   = FourierShift(S2,tshift/dtb);
                plot(tb, normalize(S2shift),'k','LineWidth',1.5)
                legend(['CC= ' num2str(CorrelationCoefficient,'%5.3f')]);
                grid
                axis tight
                title(files(k).name,'Fontsize',16)
                
                if mod(k-1,5)+1 == 5
                    outputfile = ['sequence_' sequence_id '_' stations(w,:) '_S' num2str(ceil(k/5))];
                    disp(['Writting ... ' outputfile]);
                    saveas(gcf,fullfile(pwd,subdir,outputfile),'epsc')
                    pause(5)
                end
                
                figure(ceil((N+1)/5))
                subplot(5,1,mod(N,5)+1)
                hold on
                colors = circshift(colors',1);
                ccolor = colors(1);
                plot(tb, normalize(S2shift),ccolor)
                grid
                axis tight
            end
            
            % saving the last figure
            outputfile = ['sequence_' sequence_id '_' stations(w,:) '_S' num2str(ceil((N+1)/5))];
            saveas(gcf,fullfile(pwd,subdir,outputfile),'epsc')
            pause(5)
            close all
            clear files a b
        end
    end
end
