function plot_ssn_stations();

Marker = 'o';
Size   = 14;
Width  = 2      
A      = load( '~/lib/MASE_files/SSN_latlon.txt');

plot(A(:,2),A(:,1),Marker,'Color','r','MarkerSize',Size,'LineWidth',Width)
