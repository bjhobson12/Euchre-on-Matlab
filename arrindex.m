function ret = arrindex(arr,val)
%arrindex Indexes the item in the array
%   Indexes the item in the array

    ret = -1;

    if class(arr) == "cell" % Support for cell arrays
        for i=1:length(arr)
            if arr{i} == val
                ret = i;
                break;
            end
        end
    else % Regular arrays
        ret = find(strcmp(arr,val));
        if isempty(ret)
            ret = -1;
        end
    end
end

