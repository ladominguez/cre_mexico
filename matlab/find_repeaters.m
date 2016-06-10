function find_repeaters(station_nm)
tic;
close all
clc

if nargin == 0
    station_nm = 'CAIG.HHZ..4-16Hz_data';
end

home_dir = '/home/u2/antonio/';
root_dir = '/home/u2/antonio/CRSMEX/';
email_results = 1;

addpath([home_dir 'CJA_Msac1.1/io'])
addpath([home_dir 'lib'])
addpath([root_dir 'matlab'])

%station_nm = 'CAIG';
BTime = datestr(now);
ddate = date;
ddate = [ddate(1:2) ddate(4:6) ddate(8:11)];

Win        =  40.0;    % Win = 0 means dynamic window (see file eq_win.m), otherwise Win > 0 fixed lenght.
Threshold  =   0.6;
low_f      =   1.0;
high_f     =   8.0;
n_poles    =   4;
p_pick     = 'combined';     % manual a field, auto t5 field, combined  either a or t5 field
eq_distance_threshold = 100;

cd([root_dir 'data/' station_nm '/sac']);
inputfiles = [root_dir 'data/' station_nm '/sac/list_all.info'];
out_file1  = ['CRS_' station_nm '_' BTime(8:11) upper(BTime(4:6)) BTime(1:2) '.DAT'];
out_file2  = ['CRS_' station_nm '_' BTime(8:11) upper(BTime(4:6)) BTime(1:2) '.BSL']; % Compatible with Taka'aki's routines
log_file   = ['CRS_' station_nm '_' BTime(8:11) upper(BTime(4:6)) BTime(1:2) '.LOG'];

fid        = fopen(out_file1,  'w');
fid2       = fopen(out_file2, 'w');
fid_log    = fopen(log_file,  'w');

A          = importdata(inputfiles);
N          = numel(A);

[dummy comp_info]  = system('uname -m -n -s');
line_log   = ['% Windows width = ' num2str(Win) ' Threshold = ' num2str(Threshold) ' STNM = ' station_nm...
              ' Low = ' num2str(low_f) 'Hz. High = ' num2str(high_f) 'Hz. N_poles = ' num2str(n_poles)  'p_pick = ' p_pick '.'];
fprintf(fid,  '% s',['% ' comp_info]);
fprintf(fid,  '% s\n',['% ' inputfiles]);
fprintf(fid,  '% Number of files: %d\n',N);
fprintf(fid,  '% Data proccesed on %s\n',date);
fprintf(fid,  '%s\n', line_log);
fprintf(fid,  '%s\n', ['% Start Time = ' BTime ]);

disp(['Searching repeaters for station ' station_nm ' ...'])

for k = 1:N
    master  = rsac(fullfile(pwd,char(A(k))));
    master  = filter_sac(master,low_f, high_f, n_poles); 
    fsample = 1/master.dt; 
    for n = k+1:N
        test    = rsac(fullfile(pwd,char(A(n))));
        disp([num2str([1/test.dt]) ' ' test.filename])
        test    = filter_sac(test, low_f, high_f, n_poles);
        eq_dist = distkm([test.evla test.evlo],[master.evla master.evlo]);
        if eq_dist <= eq_distance_threshold           
            [CorrelationCoefficient tshift S1 S2] = get_correlation_coefficient(master, test, Win, p_pick);
        else
            continue;
        end
        if CorrelationCoefficient >= Threshold
	    coherence  = coherency(S1, S2, low_f, high_f, fsample);
            outline = [ num2str(k) ' ' char(A(k)) ' ' char(A(n)) ' ' ...
                        num2str(CorrelationCoefficient,'%6.4f')  ' ' ...
                        num2str(tshift,'%6.2f') ' ' num2str(master.evla,'%5.2f') ' ' ...
                        num2str(master.evlo,'%6.2f') ' '  num2str(test.evla,'%5.2f') ];
            outline2 = [num2str(master.nz(1),'%.4d')  '.' num2str(master.nz(2),'%.3d') '.' ...
                        num2str(master.nz(3),'%.2d')      num2str(master.nz(4),'%.2d') ...
                        num2str(master.nz(5),'%.2d') ' '                               ...
                        num2str(test.nz(1),'%.4d')    '.' num2str(test.nz(2),'%.3d')   '.' ...
                        num2str(test.nz(3),'%.2d')        num2str(test.nz(4),'%.2d')  ...
                        num2str(test.nz(5),'%.2d')  ' ' ...
                        num2str(round(CorrelationCoefficient*1e4)) ' ' num2str(round(coherence*1e4)) ' ' master.kevnm ' ' test.kevnm];
            disp(outline)
            fprintf(fid, '%s\n',outline );
	        fprintf(fid2,'%s\n',outline2);
        end
    end
    log_line = ['k = ' num2str(k) ' out of ' num2str(N)];
    disp(log_line)
    fprintf(fid_log,'%s\n',log_line);
end
elapsed_time=toc/3600;   % Computing time in hours
ETime = datestr(now);
fprintf(fid, '%s\n', ['% End Time = ' ETime ' - Elapse Time = ' num2str(elapsed_time)]);
fclose(fid);
fclose(fid2);
fclose(fid_log);

disp(BTime)
disp(ETime)
system(['chmod -w ' out_file1]);
system(['chmod -w ' out_file2]);
system(['cp ' out_file2 ' ' home_dir 'output_crsmex/'])

if email_results == 1
	subject = ['[CRSMEX] Results from station ' station_nm '.'];
        message = line_log;
	setpref('Internet','E_mail','antonio@seismo.berkeley.edu');
	setpref('Internet','SMTP_Server','mail.geo.berkeley.edu')
	sendmail('antonio@moho.ess.ucla.edu',subject, message, {out_file1,out_file2,})
end
