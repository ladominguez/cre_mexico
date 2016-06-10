clear all
close all
clc

[files N ] = ValidateComponent('all');

j = 0;
for k = 1:N
    a = rsac(files(k).name);
    if a.picks(6) ~= -12345
        j    = j + 1; 
        t(j) = a.picks(6);
        d(j) = sqrt(a.evdp^2 + a.dist^2);
    end
end

A = [d' t'];
save t5_dist.dat A -ascii

