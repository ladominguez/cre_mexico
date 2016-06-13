clear all
close all
clc

input  = 'output_xc9500_coh9500.dat';
output = 'test.dat';

fid = fopen(input,  'r' );
out = fopen(output, 'w' );

line1 = fgetl(fid);
%fprintf(out,'%s\n',line1);

disp(['Processing ... ' input])
while 1
    line2 = fgetl(fid);
    
	if ~ischar(line2)
        	break
    end

	id1   = str2num(line1);
	id2   = str2num(line2);
        A     = intersect(id1, id2);
        An    = numel(A);

	if An == 0 % The two lines are independent
		fprintf(out, '%s\n', line1);
		%fprintf(out, '%s\n', line2);
		line1 = line2;
	else
		B = union(id1, id2);
		B = sort(B);
		fprintf(out, '%s\n', num2str(B));
		line1 = fgetl(fid);
	end
	 
	clear id1 id2 A An
end
disp(['Writting ... ' output])
fclose(fid);
fclose(out);
