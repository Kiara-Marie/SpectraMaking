% this function gives you the value in a sorted array closest to the one
% you are looking for
function [index,curr] = binarySearch(arr,lf,dir)
%arr = a sorted array
%lf = number you are looking for
%dir = true if the matrix is in reverse order
if(exist('dir','var'))
    arr = flip(arr,1);
end
index = round((1+length(arr))/2);
lower = 1;
upper = length(arr);

while (lower < upper)
    index = floor((lower+upper)/2);
    curr = arr(index,1);
    if (curr == lf)
        if(exist('dir','var'))
            index = length(arr) + 1 - index;
        end
        return;
    end
    if (curr > lf)
        upper = index;
    end
    
    if (curr < lf)
        lower = index +1;
    end
    
end

if (index<length(arr) && abs(arr(index+1)-lf) < abs(arr(index)-lf))
    index = index +1;
    curr = arr(index);
end
if (index>1 && abs(arr(index-1)-lf) < abs(arr(index)-lf))
    index = index -1;
    curr = arr(index);
end
if(exist('dir','var'))
    index = length(arr) + 1 - index;
end
return;
end