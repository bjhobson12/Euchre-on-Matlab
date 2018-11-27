function [] = makeLobby(lobby,user)
%makeLobby Makes lobby in firestore database
%   Given the name of a lobby and user, a lobby is constructed in firestore database, iff the name is unique. The user is added.
    res = request('createLobby','lobby',char(lobby),'user',char(user)); % Request
    res = eval(res);
    if res % Server returned 'true'
        println("Lobby '" + string(lobby) + "' made successfully");
        println("Waiting for players...");
    else
        error("Lobby '" + string(lobby) + "' made unsuccessfully");
    end
end

