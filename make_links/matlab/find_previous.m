function list=find_previous(key,index,list, level)
% This is a subroutine of the main code make_links.m. Takes an ID from the left column and seeks
% if there is a previous earthquake with hight coherency and correlation coefficient.
%
% June 2015 - antonio@seismo.berkeley.edu
global register NR

for k = 1: index - 1
        if register(k,2) == key
            previous = register(k,1);
            list     = poplist(list, previous);
            level    = level - 1;
            if level > 1
                list     = find_next(previous,k,list, level);
                list     = find_previous(previous,k,list, level);
            end
        end
end
