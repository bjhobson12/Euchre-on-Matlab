function ret = lobbyReady(lobby)
%lobbyReady Checks if all players are ready
%   Connects to firestore and checks if start val == true
    res = request('lobbyReady','lobby',char(lobby));
    ret = eval(res);
end

