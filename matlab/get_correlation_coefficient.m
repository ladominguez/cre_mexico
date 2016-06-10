function [CorrelationCoefficient tshift S1 S2] = get_correlation_coefficient(sac1,sac2,Win,p_pick,pplot)
% [CorrelationCoefficient tshift] = get_correlation_coefficient(sac1,sac2,Win)
%
%  Returns the correlation coefficient and time shift for two records.
%  With no input arguments, runs test unit.


if nargin <= 1
    % TEST UNIT
    disp('Running test unit ...')
    file1 = './test_data/20011105104504.IG.PLIG.BHZ.sac';
    file2 = './test_data/20080925043418.IG.PLIG.BHZ.sac';
    disp(['Opening file ' file1])
    disp(['Opening file ' file2])
    low        =  1.0;
    high       =  Inf;
    p_pick     = 'manual';
    sac1  = rsac(file1);
    sac2  = rsac(file2);
    Win   = 40;
    pplot = 0;
elseif nargin == 2
    Win = 40; % Widht of the window in seconds after sac.a
elseif nargin <= 4
    pplot = 0;
end
dt    = sac1.dt;
fs    = 1/dt;
dt    = 1/fs;

if Win == 0   % Variable mode
    [s1_signal s1_time dummy_A] = eq_window(sac1);
    [s2_signal s2_time dummy_B] = eq_window(sac2);
    
    if numel(s1_signal) < numel(s2_signal)
        s2_signal = s2_signal(1:numel(s1_signal));
        s2_time   = s2_time( 1:numel(s1_signal));
    else
        s1_signal = s1_signal(1:numel(s2_signal));
        s1_time   = s1_time( 1:numel(s2_signal));
    end
    
    Win = min([dummy_A dummy_B]);
end
year_1   = sac1.nz(1);
[month_1 day_1]  = julian2mmdd(year_1, sac1.nz(2));

year_2   = sac2.nz(1);
[month_2 day_2]  = julian2mmdd(year_2, sac2.nz(2));

Dates1   = [num2str(month_1,'%.2d') '/' num2str(day_1,'%.2d') '/' num2str(year_1)];
Dates2   = [num2str(month_2,'%.2d') '/' num2str(day_2,'%.2d') '/' num2str(year_2)];
dt_event = daysdif(Dates1, Dates2);
distEvnt = distkm([sac1.evla sac1.evlo],[sac2.evla sac2.evlo]);
Mag1     = sac1.mag;
Mag2     = sac2.mag;

if dt_event > 365
    dt_event  = dt_event./365;
    unit_time = 'years';
else
    unit_time = 'days';
end

% Read files
S1   = sac1.d;
S2   = sac2.d;

% Normalize files
%S1   = normalize(S1);
%S2   = normalize(S2);

% Trim files
T1 = sac1.t;
T2 = sac2.t;
%

switch p_pick
    case 'manual'
        P_arrival_1 = sac1.a;   % I typically picky a p_arrvial 0.8-1 before the actual onset.
        P_arrival_2 = sac2.a;
    case 'auto'
        P_arrival_1 = sac1.picks(6);
        P_arrival_2 = sac2.picks(6);
        
    case 'combined'
        if sac1.a ~= -12345;                % See i manual picking is available.
            P_arrival_1 = sac1.a;
        elseif sac1.picks[6]  ~= -12345;    % Checks if aic picking is available
            P_arrival_1 = sac1.picks(6);
        else
            error('No p_arrrival information_available. get_cotrrelation_coefficient.m')
        end
        if sac2.a ~= -12345;                % Checks if manual picking is available.
            P_arrival_2 = sac2.a;
        elseif sac2.picks[6]  ~= -12345;    % Checks if aic picking is available
            P_arrival_2 = sac2.picks(6);
        else
            error('No p_arrrival information_available. get_cotrrelation_coefficient.m')
        end
    otherwise
        error('get_correlation_coefficient.m - Invalid option. Choose either manual or auto');
end
Ntrim   = 2.^nextpow2(round(Win/sac1.dt));
index_1 = find(T1 >= P_arrival_1, Ntrim, 'first');
index_2 = find(T2 >= P_arrival_2, Ntrim, 'first');
if Win > 0  % Select all, I did this to check Taka's Java code. If Win is negative takes the whole record
    if numel(index_1) < Ntrim || numel(index_2) < Ntrim || numel(index_1) ~= numel(index_2)
        CorrelationCoefficient = 0;
        tshift                 = 0;
        return
    end
    
    S1 = S1(index_1);
    S2 = S2(index_2);
    T1 = T1(index_1);
    T2 = T2(index_2);
else
    Win = max([sac1.npts*sac1.dt sac2.npts*sac2.dt]);
end
N        = numel(S1);
Power_S1 = max(xcorr(S1))./N;
Power_S2 = max(xcorr(S2))./N;

A     =  xcorr(S1,S2)./( N*sqrt(Power_S1*Power_S2));
time2 = -(numel(S1)-1)*dt: dt : (numel(S2)-1)*dt;

[CorrelationCoefficient index] = max(A);
tshift = time2(index);

if nargout == 0 || pplot == 1
    close all
    S2shift   = FourierShift(S2,tshift/dt);
    figure(99)
    plot(T1, S1,'k');
    hold on
    plot(T1, S2shift,'r');
    %plot(T1, S1 - S2shift, 'b','LineWidth',2)
    legend(sac1.filename,sac2.filename)
    setw
    xlim([T1(1) T1(1)+Win])
    title_line = ['$cc = ' num2str(CorrelationCoefficient) ',\,\,\delta t = ' num2str(tshift) ...
        's\,\,\,M_1 = ' num2str(Mag1) '\,\,\,M_2 = ' num2str(Mag2) '\,\,\,\Delta t=' num2str(dt_event) ...
        '\,\,\,' unit_time '\,\,\, \Delta d=' num2str(distEvnt) '\,km.$'];
    title(title_line, 'Interpreter','latex','FontSize',16)
    xlabel('$time[s]$','Interpreter','latex','FontSize',16)
    fontsize(16)
    %draw_vert(Parrival,'k')
    setwin([46         220        1163         537])
end

if nargin == 0
    close all
    disp(['Correlation Coefficient ' num2str(CorrelationCoefficient)])
    if CorrelationCoefficient > 0.95
        disp('SUCCESS!!!')
        clear CorrelationCoefficient
    else
        error('Test Unit - get_correlation_coefficient.m FAILED!!!')
    end
end
