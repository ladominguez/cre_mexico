clear all
close all
clc

all = fopen('/Users/antonio/Repeating/matlab/results_all.out');

figure(1)
setwin([360   -14   755   765])

% SSE
% 2002 Event
dista_SSE  = coast_distance([16.94   -100.14]);
start_SSE  = datenum('200110','yyyymm');
end_SSE    = datenum('200204','yyyymm');
X          = [dista_SSE-75 dista_SSE+75 dista_SSE+75 dista_SSE-75 dista_SSE-75];
Y          = [start_SSE start_SSE end_SSE end_SSE start_SSE];
hf = patch(X,Y,[0.5 0.5 0.5]);
text(dista_SSE-70,(end_SSE+start_SSE)/2,'SSE','FontSize',18,'Interpreter','latex')

% 2006 Event
dista_SSE  = coast_distance([16.94   -100.14]);
start_SSE  = datenum('200604','yyyymm');
end_SSE    = datenum('200612','yyyymm');
X          = [dista_SSE-75 dista_SSE+75 dista_SSE+75 dista_SSE-75 dista_SSE-75];
Y          = [start_SSE start_SSE end_SSE end_SSE start_SSE];
hf = patch(X,Y,[0.5 0.5 0.5]);
text(dista_SSE-70,(end_SSE+start_SSE)/2,'SSE','FontSize',18,'Interpreter','latex')


while 1
    infile = fgetl(all);
    if ~ischar(infile)
        break
    end
    disp(infile)
    fid = fopen(infile);
    k = 0;
    while 1
        line        = fgetl(fid);
        if ~ischar(line)
            break;
        end
        
        if strcmp(line(1),'%')
            continue;
        end
        
        k = k + 1;
        event_A_year(k,:)  = line(1:4);
        event_A_month(k,:) = line(5:6);
        event_A_day(k,:)   = line(7:8);
        latitude_A(k)      = str2num(line(76:80));
        longitude_A(k)     = str2num(line(82:88));
        
        event_B_year(k,:)  = line(32:35);
        event_B_month(k,:) = line(36:37);
        event_B_day(k,:)   = line(38:39);
        latitude_B(k)      = str2num(line(90:94));
        longitude_B(k)     = str2num(line(96:end));
        
        distance(k)      = coast_distance([(latitude_A(k)  + latitude_B(k))/2 ...
            (longitude_B(k) + longitude_B(k))/2]);
        
        date_A(k)  = datenum([event_A_year(k,:) '/' event_A_month(k,:) '/' event_A_day(k,:)],'yyyy/mm/dd');
        date_B(k)  = datenum([event_B_year(k,:) '/' event_B_month(k,:) '/' event_B_day(k,:)],'yyyy/mm/dd');
        diff_AB(k) = date_B(k) - date_A(k);
        hold on
        plot([distance(k) distance(k)],[date_A(k), date_B(k)],...
            'ko-','LineWidth',1,'MarkerFaceColor','r')
    end
end

% Events larger than M6.0
M6 = fopen('/Users/antonio/Dropbox/Swarms/M6_data.DAT');
while 1
    line = fgetl(M6);
    if ~ischar(line)
        break
    end
    if strcmp(line(1),'%')
        continue;
    end
    date = line(1:8);
    lat  = str2num(line(10:14));
    lon  = str2num(line(18:24));
    dist = coast_distance([lat lon]);
    
    plot([dist-10 dist+10],datenum(date,'yyyymmdd')*[1 1],'b','LineWidth',3)
    text(dist+14,datenum(date,'yyyymmdd'),['M' line(27:29)],...
        'Interpreter','latex','FontSize',13)
end



box on
grid
setw
xlim([350 800])
datetick('y',10)
xlabel('Distance along the trench [km]','Interpreter','latex','FontSize',18)
fontsize(14)
Ometepec = [16.690045,-98.397675];
dist_ome = coast_distance(Ometepec);
draw_vert(dist_ome, 'k', 2)
Acapulco   = [16.856419,-99.867783];
dist_aca = coast_distance(Acapulco);
draw_vert(dist_aca, 'k', 2)
h1 = text(dist_aca-10,datenum('2008','yyyy'),'Acapulco','FontSize',18,'Interpreter','latex');
set(h1,'rotation',90)
h2 = text(dist_ome-10,datenum('2006','yyyy'),'Ometepec','FontSize',18,'Interpreter','latex');
set(h2,'rotation',90)
%set(hf,'facealpha',0.5)
