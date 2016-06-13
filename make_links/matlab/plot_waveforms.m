clear all
close all
clc

[files N] = ValidateComponent('all');

figure()
for k = 1:N
    a = rsac(files(k).name);
    hold all
    %subplot(N,1,k)
    t2 = a.picks(3);
    a=filter_sac(a,1,inf);
    ind = find(a.t >= t2,250, 'first');
    plot(a.t(ind) - a.t(ind(1)),a.d(ind))
end