clear all
close all
clc

% Input files

input_file = dir('output*');
files_crs  = importdata(input_file(end).name); 

N            = size(files_crs.data,1);
saving       = 0;
header_lines = 4;    % Number of header lines
Win          = 0;
low_f        = 1;
high_f       = Inf;
p_pick       = 'manual';

time_threshold = 0;  % Min time in years
dist_threshold = Inf; % Min time in km

counter = 0;
for k = 1:N
    counter    = counter + 1;
    filename_A = files_crs.textdata(k+header_lines, 1);
    filename_B = files_crs.textdata(k+header_lines, 2);
    A = rsac(filename_A{1});
    B = rsac(filename_B{1});
    
    %if saving == 1
        disp('WARNING. Check filtering parameters.')
        disp(['Filtering ' num2str(low_f) ' - ' num2str(high_f) ' Hz.'])
        [cc dt] = get_correlation_coefficient(A, B,  Win, low_f, high_f,p_pick, 1);
    %end
    
    pause
    
    if saving == 1
        filename_out = ['sequence_' num2str(counter,'%.3d') '.png'];
        disp(['Saving ' filename_out '...'])
        orient landscape
        print('-dpng',filename_out)
        
        
    end
    
    
    Pairs(counter,:)  = [A.evla A.evlo B.evla B.evlo];
    DatesA(counter,:) = [filename_A{1}(5:6) '/' filename_A{1}(7:8) '/' filename_B{1}(1:4)];
    DatesB(counter,:) = [filename_B{1}(5:6) '/' filename_B{1}(7:8) '/' filename_B{1}(1:4)];
    DiffDays(counter) = daysdif(DatesA(counter,:), DatesB(counter, :))./365;
    DiffMags(counter) = abs(A.mag - B.mag)/2;
    Mags(counter,:)   =    [A.mag  B.mag];
    EvtDist(counter)  = distkm([A.evla A.evlo], [B.evla B.evlo]);
end

figure(1)
plot_map_mexico();
[xl yl] = plot_circle_map(A.stla,A.stlo,200);

for k = 1:counter 
    plot(LatLons(:,2),LatLons(:,1),'k.','Color',[0.5 0.5 0.5],'MarkerSize',6)
end

max_DiffDays = max(DiffDays);
counter_rep = 0;
for k = 1:counter
    if DiffDays(k) > time_threshold && EvtDist(k) <= dist_threshold
        C_color = hsv2rgb([2*(DiffDays(k)-0)/(3*max_DiffDays) 1 1]);
        plot( Pairs(k,2),Pairs(k,1),'.','Markersize',13,'Color',C_color)
        plot( Pairs(k,4),Pairs(k,3),'.','Markersize',13,'Color',C_color)
        plot([Pairs(k,2) Pairs(k,4)],[Pairs(k,1) Pairs(k,3)],'-','Color',C_color,'LineWidth',2)
        counter_rep        =  counter_rep + 1;
        out(counter_rep,:) = [(Pairs(k,1)+Pairs(k,3))/2 (Pairs(k,2)+Pairs(k,4))/2 ...
            DiffDays(k) (Mags(k,1)+Mags(k,2))/2 DiffMags(k)];
    end
end

plot(A.stlo, A.stla, 'k^', 'MarkerSize', 15, 'MarkerFaceColor', 'k')
xlim(xl)
ylim(yl)
fontsize(16)
title(['Repeating Pairs - ' A.kstnm(1:4)],'FontName','Helvetica','FontSize',18)

if saving == 1
    orient landscape
    print('-deps2',[A.kstnm(1:4) '_map_repeating_events.eps'])
end

figure(2)
setwin([343    24   927   987])
subplot(3,1,1)
stem(DiffDays,'k','MarkerFaceColor','k')
xlabel('Sequence Number [1-15]','Interpreter','latex')
ylabel('Time [years]','Interpreter', 'latex')
title ('Time between events [years]','Interpreter','latex','FontSize',18)
axis tight
fontsize(18)
grid


subplot(3,1,2)
plot(Mags(:,1),'k.','MarkerSize',15)
hold on
plot(Mags(:,2),'k.','MarkerSize',15)
for k = 1:counter
    plot([k k],[Mags(k,1) Mags(k,2)],'k')
end
axis tight
fontsize(18)
grid
setw
xlabel('Sequence Number [1-15]','Interpreter','latex')
ylabel('Magnitude','Interpreter','latex')
title('Magnitude difference between events','Interpreter','latex','FontSize',18)

subplot(3,1,3)
semilogy(EvtDist,'k.','MarkerSize',15)
axis tight
grid
fontsize(18)
title('Distance between events','Interpreter','latex','FontSize',18)
xlabel('Sequence Number [1-15]','Interpreter','latex')
ylabel('Distance [km]','Interpreter','latex')
fclose(fid);
h=suptitle(A.kstnm(1:4));
set(h,'FontSize',22,'Interpreter','latex')

if saving == 1
    %orient landscape
    print('-deps2',[A.kstnm(1:4) '_repeating_features.eps'])
end

if saving == 1
    %To save all of the repeaters - aux = [out(:,1:2); out(:,3:4)];
    save('rep_latlon.dat','out','-ascii')
end

%% Reserve

% fid     = fopen('repeaters.list');
% LatLons = load('../latlon.dat');      % Latitude and longitude of all analyzed events