clear all
close all

% Reference point
latlon_REF = [17.988 -104.047];
Vparkfield = 2.3; % Chen K.H. et al 2007
Vmexico    = 5.8;
Vm_Vp      = Vmexico/Vparkfield;

% Avg_lat  Avg_lon Recurrence_interval Avg_Mag Std_mag
CAIG4 = load('/Users/antonio/Dropbox/CRSTMP/data/CAIG/output/filter_1_4Hz/rep_latlon.dat');
CAIG8 = load('/Users/antonio/Dropbox/CRSTMP/data/CAIG/output/filter_1_8Hz/rep_latlon.dat');
PLIG4 = load('/Users/antonio/Dropbox/CRSTMP/data/PLIG/output/filter_1_4Hz/rep_latlon.dat');
PLIG8 = load('/Users/antonio/Dropbox/CRSTMP/data/PLIG/output/filter_1_8Hz/rep_latlon.dat');
PNIG4 = load('/Users/antonio/Dropbox/CRSTMP/data/PNIG/output/filter_1_4Hz/rep_latlon.dat');
PNIG8 = load('/Users/antonio/Dropbox/CRSTMP/data/PNIG/output/filter_1_8Hz/rep_latlon.dat');
ZIIG4 = load('/Users/antonio/Dropbox/CRSTMP/data/ZIIG/output/filter_1_4Hz/rep_latlon.dat');
ZIIG8 = load('/Users/antonio/Dropbox/CRSTMP/data/ZIIG/output/filter_1_8Hz/rep_latlon.dat');

% Recurrence time of each pair of repeaters
lat_CAIG4 = CAIG4(:,1);
lat_CAIG8 = CAIG8(:,1);
lat_PLIG4 = PLIG4(:,1);
lat_PLIG8 = PLIG8(:,1);
lat_PNIG4 = PNIG4(:,1);
lat_PNIG8 = PNIG8(:,1);
lat_ZIIG4 = ZIIG4(:,1);
lat_ZIIG8 = ZIIG8(:,1);

lon_CAIG4 = CAIG4(:,2);
lon_CAIG8 = CAIG8(:,2);
lon_PLIG4 = PLIG4(:,2);
lon_PLIG8 = PLIG8(:,2);
lon_PNIG4 = PNIG4(:,2);
lon_PNIG8 = PNIG8(:,2);
lon_ZIIG4 = ZIIG4(:,2);
lon_ZIIG8 = ZIIG8(:,2);

dist_CAIG4 = distkm([lat_CAIG4 lon_CAIG4],latlon_REF);
dist_CAIG8 = distkm([lat_CAIG8 lon_CAIG8],latlon_REF);
dist_PNIG4 = distkm([lat_PNIG4 lon_PNIG4],latlon_REF);
dist_PNIG8 = distkm([lat_PNIG8 lon_PNIG8],latlon_REF);
dist_PLIG4 = distkm([lat_PLIG4 lon_PLIG4],latlon_REF);
dist_PLIG8 = distkm([lat_PLIG8 lon_PLIG8],latlon_REF);

Tr_CAIG4 = CAIG4(:,3);
Tr_CAIG8 = CAIG8(:,3);
Tr_PLIG4 = PLIG4(:,3);
Tr_PLIG8 = PLIG8(:,3);
Tr_PNIG4 = PNIG4(:,3);
Tr_PNIG8 = PNIG8(:,3);
Tr_ZIIG4 = ZIIG4(:,3);
Tr_ZIIG8 = ZIIG8(:,3);

Mw_CAIG4 = CAIG4(:,4);
Mw_CAIG8 = CAIG8(:,4);
Mw_PLIG4 = PLIG4(:,4);
Mw_PLIG8 = PLIG8(:,4);
Mw_PNIG4 = PNIG4(:,4);
Mw_PNIG8 = PNIG8(:,4);
Mw_ZIIG4 = ZIIG4(:,4);
Mw_ZIIG8 = ZIIG8(:,4);

RT_CAIG4 = log10(Vm_Vp*CAIG4(:,3));
RT_CAIG8 = log10(Vm_Vp*CAIG8(:,3));
RT_PLIG4 = log10(Vm_Vp*PLIG4(:,3));
RT_PLIG8 = log10(Vm_Vp*PLIG8(:,3));
RT_PNIG4 = log10(Vm_Vp*PNIG4(:,3));
RT_PNIG8 = log10(Vm_Vp*PNIG8(:,3));
RT_ZIIG4 = log10(Vm_Vp*ZIIG4(:,3));
RT_ZIIG8 = log10(Vm_Vp*ZIIG8(:,3));

M0_CAIG4 = 1.5.*Mw_CAIG4 + 16.1;
M0_CAIG8 = 1.5.*Mw_CAIG8 + 16.1;
M0_PLIG4 = 1.5.*Mw_PLIG4 + 16.1;
M0_PLIG8 = 1.5.*Mw_PLIG8 + 16.1;
M0_PNIG4 = 1.5.*Mw_PNIG4 + 16.1;
M0_PNIG8 = 1.5.*Mw_PNIG8 + 16.1;
M0_ZIIG4 = 1.5.*Mw_ZIIG4 + 16.1;
M0_ZIIG8 = 1.5.*Mw_ZIIG8 + 16.1;

logd_CAIG4 = -2.36 + 0.17*M0_CAIG4;
logd_CAIG8 = -2.36 + 0.17*M0_CAIG8;
logd_PLIG4 = -2.36 + 0.17*M0_PLIG4;
logd_PLIG8 = -2.36 + 0.17*M0_PLIG8;
logd_PNIG4 = -2.36 + 0.17*M0_PNIG4;
logd_PNIG8 = -2.36 + 0.17*M0_PNIG8;
logd_ZIIG4 = -2.36 + 0.17*M0_ZIIG4;
logd_ZIIG8 = -2.36 + 0.17*M0_ZIIG8;

% Velocity from repeating events 
vel_CAIG4  = (10.^logd_CAIG4)./Tr_CAIG4;
vel_CAIG8  = (10.^logd_CAIG8)./Tr_CAIG8;
vel_PNIG4  = (10.^logd_PNIG4)./Tr_PNIG4;
vel_PNIG8  = (10.^logd_PNIG8)./Tr_PNIG8;
vel_PLIG4  = (10.^logd_PLIG4)./Tr_PLIG4;
vel_PLIG8  = (10.^logd_PLIG8)./Tr_PLIG8;
vel_ZIIG4  = (10.^logd_ZIIG4)./Tr_ZIIG4;
vel_ZIIG8  = (10.^logd_ZIIG8)./Tr_ZIIG8;

% Velocity from convergence rate
[vcr_CAIG4 dist_CAIG4] = convergence_rate([lat_CAIG4 lon_CAIG4]);
[vcr_CAIG8 dist_CAIG8] = convergence_rate([lat_CAIG8 lon_CAIG8]);
[vcr_PNIG4 dist_PNIG4] = convergence_rate([lat_PNIG4 lon_PNIG4]);
[vcr_PNIG8 dist_PNIG8] = convergence_rate([lat_PNIG8 lon_PNIG8]);
[vcr_PLIG4 dist_PLIG4] = convergence_rate([lat_PLIG4 lon_PLIG4]);
[vcr_PLIG8 dist_PLIG8] = convergence_rate([lat_PLIG8 lon_PLIG8]);
[vcr_ZIIG4 dist_ZIIG4] = convergence_rate([lat_ZIIG4 lon_ZIIG4]);
[vcr_ZIIG8 dist_ZIIG8] = convergence_rate([lat_ZIIG8 lon_ZIIG8]);

cop_CAIG4 = (vcr_CAIG4 - vel_CAIG4)./vcr_CAIG4;
cop_CAIG8 = (vcr_CAIG8 - vel_CAIG8)./vcr_CAIG8;
cop_PNIG4 = (vcr_PNIG4 - vel_PNIG4)./vcr_PNIG4;
cop_PNIG8 = (vcr_PNIG8 - vel_PNIG8)./vcr_PNIG8;
cop_PLIG4 = (vcr_PLIG4 - vel_PLIG4)./vcr_PLIG4;
cop_PLIG8 = (vcr_PLIG8 - vel_PLIG8)./vcr_PLIG8;
cop_ZIIG4 = (vcr_ZIIG4 - vel_ZIIG4)./vcr_ZIIG4;
cop_ZIIG8 = (vcr_ZIIG8 - vel_ZIIG8)./vcr_ZIIG8;

[velocity_cr d_coast] = convergence_rate();

figure(1)
setw
setwin([116   143   901   614])
plot(dist_CAIG8,10.^logd_CAIG8,'r^','MarkerSize',14,'LineWidth',1.5)
hold all
plot(dist_PNIG8,10.^logd_PNIG8,'bo','MarkerSize',14,'LineWidth',1.5)
plot(dist_PLIG8,10.^logd_PLIG8,'ms','MarkerSize',14,'LineWidth',1.5)
plot(dist_ZIIG8,10.^logd_ZIIG8,'d' ,'MarkerSize',14,'Color',[0 0.5 0],'LineWidth',1.5)
legend('CAIG','PNIG','PLIG','ZIIG','Location','NorthWest',...
       'Interpreter','Latex')
fontsize(18)
grid
xlabel('Distance\,\,\,along\,\,\,the\,\,\,coast\,\, [km]', ...
       'Interpreter','Latex','FontSize',18);
ylabel('Displacement[cm]', ...
       'Interpreter','Latex','FontSize',18);
ylim([16 26])
   
figure(2)
setw
setwin([116   143   901   614])
plot(dist_CAIG8,vel_CAIG8,'r^','MarkerSize',14,'LineWidth',1.5)
hold all
plot(dist_PNIG8,vel_PNIG8,'bo','MarkerSize',14,'LineWidth',1.5)
plot(dist_PLIG8,vel_PLIG8,'ms','MarkerSize',14,'LineWidth',1.5)
plot(dist_ZIIG8,vel_ZIIG8,'d' ,'MarkerSize',14,'Color',[0 0.5 0],'LineWidth',1.5)
legend('CAIG','PNIG','PLIG','ZIIG','Location','NorthWest',...
       'Interpreter','Latex')
fontsize(18)
plot(d_coast,velocity_cr,'k--','LineWidth',2)
grid
xlabel('Distance\,\,\,along\,\,\,the\,\,\,coast\,\, [km]', ...
       'Interpreter','Latex','FontSize',18);
ylabel('Slip\,\,\,Rate\,\,[cm/yr]', ...
       'Interpreter','Latex','FontSize',18);
handle_t1 = text(600.,6.3,'Plate\,\,\,Convergence\,\,\,Rate',...
    'Interpreter','latex','FontSize',16); 
set(handle_t1,'rotation',3.0)
xlim([350 800])
ylim([2.5 15])
% figure(3)
% setw
% setwin([116   143   901   614])
% plot(dist_CAIG4,logd_CAIG4,'r^','MarkerSize',14,'LineWidth',1.5)
% hold all
% plot(dist_PNIG4,logd_PNIG4,'bo','MarkerSize',14,'LineWidth',1.5)
% plot(dist_PLIG4,logd_PLIG4,'ms','MarkerSize',14,'LineWidth',1.5)
% plot(dist_ZIIG4,logd_ZIIG4,'d' ,'MarkerSize',14,'Color',[0 0.5 0],'LineWidth',1.5)
% legend('CAIG','PNIG','PLIG','ZIIG','Location','NorthWest',...
%        'Interpreter','Latex')
% fontsize(18)
% grid
% xlabel('Distance\,\,\,along\,\,\,the\,\,\,coast\,\, [km]', ...
%        'Interpreter','Latex','FontSize',18);
% ylabel('Slip\,\,\,Rate\,\,[cm/yr]', ...
%        'Interpreter','Latex','FontSize',18);
M0_x     = [12 28];
Tr_y     = 0.16*M0_x - 2.53;



%%
figure(5)
setw
plot(M0_CAIG8,RT_CAIG8,'k+','MarkerSize',11)
hold on
plot(M0_PNIG8,RT_PNIG8,'k^','MarkerSize',11)
plot(M0_PLIG8,RT_PLIG8,'ko','MarkerSize',11)
plot(M0_ZIIG8,RT_ZIIG8,'ks','MarkerSize',11)

legend('CAIG','PNIG','PLIG','ZIIG','Location','NorthWest',...
       'Interpreter','Latex')

plot(M0_x,Tr_y,'k--')
xlabel('$log_{10}(M_0)\,[dyne\times cm]$','Interpreter','latex')
ylabel('$log_{10}(T_r)\,[yr]$','Interpreter','latex')
xlim([12 28])
ylim([-0.6 2.6])
grid
fontsize(18)
set(gca,'Position',[0.1300    0.2266    0.7750    0.6984])
ht = text(12.2,-0.35,'$log_{10}(T_r)=0.16log_{10}(M_0)-2.53$','Interpreter','Latex', ...
          'FontSize',14)
set(ht,'rotation',18.85)
setwin([78   353   732   404])



