function [cr_out distance_out] = convergence_rate(latlon_in)
% Convergence rate from an SSN Figure of major ruptures in Mexico in the
% past 100yr. ladominguez@ucla.edu San Francisco, 2013.

Coor = [ 17.988 -104.047
    17.004 -101.985
    16.077  -99.424
    15.354  -97.167];

convergence = [4.7; 5.3; 5.9; 6.4];
% Grid of lat and lons along the 'coast'
lon_x = linspace(Coor(1,2),Coor(end,2),101);
lat_y = interp1(Coor(:,2),Coor(:,1),lon_x,'splines');
% Vector of distance along the coast from [17.988 -104.047]
coast_dist_int = distkm([lat_y(1:end-1)' lon_x(1:end-1)'],[lat_y(2:end)' lon_x(2:end)']);
coast_dist     = [0; cumsum(coast_dist_int)];

if nargin == 0 
    latlon_in = [lat_y' lon_x'];
end
N_in = size(latlon_in,1);


for k = 1:N_in
    latlon = latlon_in(k,:);
    
    % Min distance from the point to the coast
    dist             = distkm(latlon, [lat_y' lon_x']);
    [min_dist index] = min(dist);
    
    dc               = distkm([Coor(1:end-1,1) Coor(1:end-1,2)],  ...
                              [Coor(2:end,  1) Coor(2:end,  2)]);
    distance         = coast_dist(index);                      
    cr               = interp1([0; cumsum(dc)],convergence,distance);
    
    if isnan(cr)
        cr = 6.4;
    end
    
    cr_out(k,1)        = cr;
    distance_out(k,1)  = distance;
end

% d  = distkm(Coor,Coor(1,:));
% dt = distkm(latlon,Coor(1,:));
%isnan()
% cr = interp1(d,convergence,dt);

