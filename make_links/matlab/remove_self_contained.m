clear all
close all
clc

input  = 'output_xc9500_coh9500.dat';
output = 'test.dat';

fid = fopen(input,  'r' );
out = fopen(output, 'w' );

line1 = fgetl(fid);
fprintf(out,'%s\n',line1);


while 1
    line2 = fgetl(fid);
    
	if ~ischar(line2)
        	break
    end

	id1   = str2num(line1);
	id2   = str2num(line2);
    
	n1    = numel(id1);
	n2    = numel(id2);

	if n1 > n2 
		flag = 1;  % Assume that the next line is self contained
		for k = 1:n2
			if isempty( find(id2(k)==id1) )
				flag = 0;
			end
		end
		if flag == 0
			fprintf(out, '%s\n', line2);
		end
	else 
		fprintf(out, '%s\n', line2);
    end
    line1 = line2;
	clear id1 id2
end

fclose(fid);
fclose(out);
