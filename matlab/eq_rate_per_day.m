% This codes computes the number of earthquakes per day recorded by a given
% station.
%
% Los Cabos, Baja California. December 2013. ladominguez@ucla.edu


clear all
close all
clc

fid        = fopen('/Users/antonio/Dropbox/Repeating/data/CAIG/sac/list_all.info');
eq_counter = 1;
line       = fgetl(fid);

year  = line(1:4);
month = line(5:6);
day   = line(7:8);

init_date    = datenum([day '-' month '-' year], 'dd-mm-yyyy');
rate         = 0;         % Number of eq. per day [array]
current_date = init_date; % Indicates the date (numerical) currently under examination.
counter_eq   = 0;         % Counts the number of e1 per day.
date_n       = init_date;
%disp(line)


while 1
    if date_n == current_date
        counter_eq         = counter_eq + 1;
        rate(current_date - init_date + 1 ) = counter_eq;
        line = fgetl(fid);
        if ~ischar(line)
            break
        end
        %disp(line)
        year   = line(1:4);
        month  = line(5:6);
        day    = line(7:8);
        date_n = datenum([day '-' month '-' year], 'dd-mm-yyyy');
    else
        current_date       = current_date + 1;
        counter_eq         = 0;
        rate(current_date - init_date + 1) = 0;
    end

   
end







