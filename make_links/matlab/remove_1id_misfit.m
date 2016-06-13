clear all
close all
clc

input  ='output_xc9000_coh9000_short.dat';
output = 'test.dat';

fid = fopen(input,  'r' );
out = fopen(output, 'w' );

while 1
    line1 = fgetl(fid);
    
    if ~ischar(line1)
        	break
    end

    id1   = str2num(line1);
    n1    = numel(id1);

    id2   = id1(1);
    n2    = n1;
    line2 = '';
    for k = 2:n1
        misfit = id1(k) - id1(k-1);
        if misfit > 100
            id2(k) = id1(k);
            line2  = [line2 ' ' num2str(id2(k))];
        else
            n2 = n2 - 1;
        end
    end
    if n2 > 1
        line2 = num2str(id2);
        fprintf(out,'%s\n',line2);
    end
    clear id1 id2
end

fclose(fid);
fclose(out);
