function ret = getLobbies()
%getLobbies Gets lobbies from firestore
%   Gets each lobby from firestore database
    res = request('getLobbies'); % Request
    res = eval(res); % Eval response
    if class(res) == "logical"  % Check to see if return 'false'
        error("Fatal Error: Could not connect to server");
    end
    ret = eval(res);
end

