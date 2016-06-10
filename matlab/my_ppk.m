clear all
close all


npoles = 4;
low    = 1;
high   = Inf;

A =importdata('/Users/antonio/Repeating/data/PLIG/sac/list_all.info');

N = numel(A);

figure(1)
setwin([23 470 1572 579])
setw

for k = 1:N
    
    filename = fullfile(pwd,char(A(k)));
    S = rsac(filename);
    
    Nyquist  = 0.5*(1/S.dt);
	[b, a]   = butter(npoles,[low]./Nyquist,'high');
    waveform = filter(b,a,S.d);
    waveform = filter(b,a,waveform);
    
    
    plot(S.t,waveform)
    
    if S.dist ~= -12345 && S.evdp ~= -12345
        p_arrival = sqrt(S.dist^2 + S.evdp^2)./(3.5*sqrt(3));    
    else
        
        title('No P-arrvial found','FontSize',20)
    end
    
    draw_vert(p_arrival)
    draw_vert(p_arrival-3, 'b')
    xlim([p_arrival-10 p_arrival + 40 ])
    disp([num2str(k) ' out of ' num2str(N) ' - ' filename])
    [time_p dummy] = ginput(1);
    S.picks(1)     = p_arrival;
    S.a            = time_p;
    S.npts
    filename_out   = fullfile(pwd,['A' char(A(k))]);
    wsac(S,[ filename_out])
    
end