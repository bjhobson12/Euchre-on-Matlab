function ret = myTurn(lobby,username,users,id)
%myTurn Determines if it is the users turn
%  Detailed explanation goes here ret = [quit,userPickedUp,true,false]
    res = request('read','lobby',char(lobby),'id',char(id)); % Request
    
    if ~(res=="{}") % Guard
        
        dataMap = struct2map(jsondecode(res));
        keyss = keys(dataMap);
    
        var = 0;
        for i=1:4
            if arrindex(keyss,users(i)) ~= -1
                var = i; % Find stable user who has spoken
            end
        end
        while true
            var = var + 1;
            var = mod(var,5);
            if var == 0
                var = var + 1;
            end
            if arrindex(keyss,users(var)) == -1 % Find unstable user
                userTurn = users(var); % Est. next user
                break;
            end
        end
        
        %{
        if arrindex(users,lastWriteUser) == 4
            p = 1;
        else
            p = arrindex(users,lastWriteUser) + 1;
        end
        %}
            
        ret = userTurn == username;

        if id == "trump"
           for i=1:length(keyss)
                currentKey = keyss(i);
                currentKey = currentKey{1};
                if dataMap(currentKey) ~= "P"
                    ret = currentKey;
                end
           end
           if length(keyss) == 4
               ret = "Quit";
           end
        elseif id == "bid"
            for i=1:length(keyss)
                currentKey = keyss(i);
                currentKey = currentKey{1};
                if eval(dataMap(currentKey))
                    ret = currentKey;
                end
            end
        end
    else
        ret = false;
    end
end

