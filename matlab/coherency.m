function coherence = coherency(S1, S2, fmin, fmax, fs)

% UNIT TEST
if nargin == 0
    sac1 = rsac('./test_data/20080925043418.IG.PLIG.BHZ.sac');    
    sac2 = rsac('./test_data/20011105104504.IG.PLIG.BHZ.sac');
    S1   = sac1.d;
    S2   = sac2.d;
    fs   = 1/sac1.dt;
    fmin = 1;
    fmax = 8;
end


[coherence2 freq] = mscohere(S1, S2, [], [], [], fs);
coherence         = mean(sqrt(coherence2(freq>=fmin & freq<= fmax)));
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RESERVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[f1 X1] = FFourier(sac1);
[f2 X2] = FFourier(sac2);

f_ind1 = find(f1 >= fmin & f1 <= fmax);
f_ind2 = find(f2 >= fmin & f2 <= fmax);

N1     = numel(f_ind1);
N2     = numel(f_ind2);

if N1 == 0 || N2 == 0
    error('Empty vectors - coherency.m')
end

if N1 > N2  % This condition solves the error that arises when the records have different lenghts 
    freq = f2(f_ind2)';
    X1   = interp1(f1,X1,freq);
    X2   = X2(f_ind2);
elseif N1 < N2
    freq = f1(f_ind1)';
    X1   = X1(f_ind1);
    X2   = interp1(f2,X2,freq);
else   % N1 == N2
    X1 = X1(f_ind1);
    X2 = X2(f_ind2);
end
 
X12      = mean(abs(conj(X1).*X2));
X1_mean  = mean(abs(X1).^2);
X2_mean  = mean(abs(X2).^2);

coherence = X12/sqrt(X1_mean*X2_mean);




