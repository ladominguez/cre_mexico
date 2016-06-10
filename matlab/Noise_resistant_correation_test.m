clear all
close all
clc

fidA = fopen('Group_A.info');
fidB = fopen('Group_B.info');

counter = 1;

while 1
    file_A = fgetl(fidA);
    file_B = fgetl(fidB);
    if ~ischar(file_A)
        break
    end
    
    
    F_raw = rsac(file_A);
    G_raw = rsac(file_B);
    
    F = filter_sac(F_raw,1,Inf,4);
    G = filter_sac(G_raw,1,Inf,4);
    
    [Fsignal F_time dummy_A] = eq_window(F);
    [Gsignal G_time dummy_B] = eq_window(G);
    
    if numel(Fsignal) < numel(Gsignal)
        Gsignal = Gsignal(1:numel(Fsignal));
        G_time  = G_time( 1:numel(Fsignal));
    else
        Fsignal = Fsignal(1:numel(Gsignal));
        F_time  = F_time( 1:numel(Gsignal));
    end
    
    win_length = min([dummy_A dummy_B]);
    [cc tt]=get_correlation_coefficient(F_raw,G_raw,0,1,Inf,'manual');

    [fsp frequencies_f time_fsp] = spectrogram(Fsignal,hanning(32), [], 64, 1/F.dt);
    gsp = spectrogram(Gsignal,hanning(32), [], 64, 1/G.dt);
    
    whos fsp gsp
    fsp = fsp(1:2^(nextpow2(size(fsp,1))-1),1:2^(nextpow2(size(fsp,2))-1));
    gsp = gsp(1:2^(nextpow2(size(gsp,1))-1),1:2^(nextpow2(size(gsp,2))-1));
    whos fsp gsp
    
    Fsp = fft2(abs(fsp));
    Gsp = fft2(abs(gsp));
    
    R = Fsp.*conj(Gsp)./abs(Fsp.*conj(Gsp));
    
    r = ifft2(R);
    %imagesc(abs(r))
    %colorbar
    test_r(counter)  = max(max(abs(r)));
    test_cc(counter) = cc;
    counter = counter+1;
    
    figure(1)
    subplot(2,1,1)
    plot(F.t, F.d)
    hold on
    plot(F_time, Fsignal,'r')
    title(['cc = ' num2str(cc)])
    subplot(2,1,2)
    plot(G.t, G.d)
    hold on
    plot(G_time, Gsignal,'r')
    title(['r_{max} = ' num2str(test_r(counter-1))])
    
    pause
    clf
    
end
close all


return

subplot(2,1,1)
semilogy(abs(fftshift(fft(F.d))))
yl = get(gca,'ylim')

subplot(2,1,2)
plot(ifft(fft(F.d)))
set(gca,'ylim',yl)