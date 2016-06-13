clear all
close all
clc
global register NR

%low_xc  = load('xc_link_xc9000_coh9000_2015JUL02.out');
high_xc = load('xc_link_xc9500_coh9500_2015JUL02.out');

%register = [ 1  25
%     1  35
%     15 25
%     20 30
%     25 30
%     20 35 ]4
 
%register = low_xc(:,1:2);
register = high_xc(:,1:2);


NR    = size(register, 1);
RL    = 20;
level = RL - 1; 
set(0,'RecursionLimit',RL)
fid = fopen('output_xc9500_coh9500.dat','w');
%fid = fopen('output_xc9000_coh9000.dat','w');

for k = 1:NR 
    disp(['Processing line ' num2str(k) ' out of ' num2str(NR)])
    level = RL - 1;
    key1  =  register(k, 1);
    key2  =  register(k, 2);
    list  = [key1 key2];
    list  = find_next(key1, k, list, level);
    list  = find_next(key2, k, list, level);
    list  = find_previous(key1, k, list, level);
    list  = find_previous(key2, k, list, level);
    n     = numel(list);
    for j = 1:n
        fprintf(fid,'%d ',list(j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
