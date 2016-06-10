clear all
close all
clc

A =importdata('/Users/antonio/Dropbox/Repeating/data/MMIG/sac/list_all.info');
N = numel(A);



for k = 1:N
    
    filename  = fullfile(pwd,char(A(k)));
    S         = rsac(filename);
    filename  = S.filename;
    latitude  = num2str(S.stla,'%6.3f');
    longitude = num2str(S.stlo,'%7.3f');
    depth     = num2str(S.evdp,'%5.2f');
    mag       = num2str(S.mag ,'%3.1f');
    win_start = num2str(S.a,   '%5.2f');  % Hand picked beginning of the window
    p_arrival = num2str(S.picks(1), '%5.2f'); % Arrival time estimated using taup
    output = [filename(end - 29:end) ' ' latitude ' ' longitude ' ' depth ' ' ...
              mag ' ' win_start ' ' p_arrival];
          
    if S.a >= 1500
        disp(output(1:30))
    end
    
    % Numeric output 
    out(k,:) = [S.stla S.stlo S.evdp sqrt(S.dist^2 + S.evdp^2) S.mag S.a S.picks(1)] ;    
    %disp(k*100/N)
    
end


%%
close all
figure(1)
setwin([430 301 1145 758])
plot(out(:,4),out(:,6),'o')
hold on
plot(out(:,4),out(:,7),'ro')
setw
xlim([0 220])
ylim([0 35])
xlabel('Distance [km]','Interpreter','Latex','FontSize',18)
ylabel('Travel Time','Interpreter','Latex','FontSize',18)
title(S.kstnm(1:4),'FontSize',18)
fontsize(18)
grid
