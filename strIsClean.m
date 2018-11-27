function ret = strIsClean(str)
%strIsClean Checks if a string is formatted properly
%   Returns bool if string doesn't contain spaces
    ret = isempty(strfind(str,' ')); % Returns bool where string is not found == true
end

