function distance_out = coast_distance(latitude, longitude)
% Distance along the coast. It can get either a Nx2 latlon vector or
% two Nx1, Nx1 latitude and longitude vectors.
%
% ladominguez@ucla.edu
Coor = [ 17.988 -104.047
    	 17.004 -101.985
    	 16.077  -99.424
         15.354  -97.167
         15.269  -96.006
         15.181  -95.606];

lon_x = linspace(Coor(1,2),Coor(end,2),151);
lat_y = interp1(Coor(:,2),Coor(:,1),lon_x,'splines');

coast_dist_int = distkm([lat_y(1:end-1)' lon_x(1:end-1)'],[lat_y(2:end)' lon_x(2:end)']);
coast_dist     = [0; cumsum(coast_dist_int)];

if nargin == 0
	error('Not enough input variables - coast_distance.m')
elseif nargin == 1
	latlon_in = latitude;
elseif nargin == 2
	latlon_in = [latitude longitude];
else
	error('Too many input parameters - coast_distance.m')
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

    distance_out(k,1)  = distance;
end
