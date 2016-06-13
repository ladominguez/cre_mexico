function list=find_next(key, index, list,level)
% This is a subroutine of the main code make_links.m. Takes an ID from the right column and seeks
% if there is a later earthquake with hight coherency and correlation coefficient.
%
% June 2015 - antonio@seismo.berkeley.edu

global register NR


for k = index + 1:NR
        if register(k,1) == key
            next = register(k,2);
            list = poplist(list,next);
            level = level - 1;
            if level > 1
                list = find_next(next,k,list, level);
                list = find_previous(next,k,list, level);
            end
        end
end


