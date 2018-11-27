function [] = println(str)
%println Prints with formatting
%   Wrapper for fprintf with new line
fprintf(string(str)+"\n");
end

