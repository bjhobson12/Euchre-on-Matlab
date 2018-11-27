function ret = struct2map(struc)
%struc2map Given a struct returns a map
%   Converts struct in container.Map
ret = containers.Map(fieldnames(struc), struct2cell(struc));
end

