function [] = joinLobby(lobby,user)
%joinLobby Given a lobby name and user, the program enters a lobby
%   This function connects to firestore database and user enters a lobby
    api = 'https://us-central1-euchre-sdp18.cloudfunctions.net';
    options = weboptions('MediaType','application/x-www-form-urlencoded','RequestMethod','post','Timeout',30);
    res = eval(webread([api, '/joinLobby?lobby=', lobby, '&user=', user], options)); % Request
    if res % Server returned 'true'
        println("Lobby '" + string(lobby) + "' joined successfully");
        println("Waiting for players...");
    else
        error("Lobby '" + string(lobby) + "' joined unsuccessfully. Lobby is full.");
    end
end