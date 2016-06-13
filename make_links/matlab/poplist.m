function list = poplist(list,new)
% This functions pop an element into a stack like structure
ind = find(new == list, 1);
if isempty(ind)
    list(end+1) = new;
    list        = sort(list);
end
