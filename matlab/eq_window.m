function [A_signal T_signal win_length] = eq_window(sac)
% [tw Ad] = eq_window(sac)
%
% Returns a time window tw that containts the complete waveform.
% a maker must be set to the onet of the p-wave.
%
%                           Luis A. Dominguez (2014)

wn   = 1;  % Window counter
step = 5;  % Window step in seconds
SNR  = 3;

if sac.a ~= -12345;
	start_time = sac.a;
elseif sac.picks(6) ~= -12345;
	start_time = sac.picks(6);
else
    error('Not enough header information - a and t5 missing.')
end

time      = sac.t;

% Noise statistics
ind_noise  = find(time >= start_time - step & time <= start_time);
t_noise    = time(ind_noise);
A_noise    = sac.d(ind_noise);

rms_noise  = rms(A_noise);

% Signal statistics
ind_signal = time >= start_time & time <= start_time + step*wn;
A_signal   = sac.d(ind_signal);
rms_signal = rms(A_signal);

while rms_signal >= SNR*rms_noise
    wn = wn + 1; 
    ind_signal = time >= start_time + step*(wn - 1) & time <= start_time + step*wn;
    A_signal   = sac.d(ind_signal);
    rms_signal = rms(A_signal);
end

ind_signal = time >= start_time - step & time <= start_time + step*(wn - 1);
T_signal   = sac.t(ind_signal);
A_signal   = sac.d(ind_signal);
rms_signal = rms(A_signal);
win_length = (wn)*step;
if nargout == 0
    close all
    plot(sac.t,sac.d,'k')
    hold on
    plot(t_noise,  A_noise, 'r')
    plot(T_signal, A_signal,'b')
    title((wn+1)*step)

    draw_vert(start_time)
    draw_horz(rms_noise)
end
