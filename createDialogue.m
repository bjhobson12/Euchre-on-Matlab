function ret = createDialogue(varargin)
%createDialogue Inputs accepted
%   This function creates a dialogue and tailors to the user, letting them input when appropriate
        lobby = varargin(1);
        username = varargin(2);
        users = varargin(3);
        start = varargin(4);
        dealer = varargin(5);
        id = varargin(6);
        try 
            point = varargin(9);
            point = point{1};
            trick = varargin(8);
            trick = trick{1};
        catch
            try
                point = varargin(8);
                point = point{1};
                trick = varargin(7);
                trick = trick{1};
            catch
                try
                    noSuite = varargin(7);
                    noSuite = noSuite{1};
                catch
                end
            end
        end
        username = username{1};
        lobby = lobby{1};
        users = users{1};
        start = start{1};
        dealer = dealer{1};
        id = id{1};
    if id == "bid" % If the dialogue is about the first bid
        if start == username % I start
            write(lobby, username, input('Should ' + dealer + ' take the card? Yes(1), or No(0): ')==1, "bid"); % Asynchronous petition
        else % I dont start
            awaitTurn(lobby,username,users,dealer,"bid"); % Wait for my turn
        end
        if exist('trick','var')
            ret = createKeyServer(lobby,true,"bid",false, point, trick);
        else
            ret = createKeyServer(lobby,true,"bid",false);
        end
    elseif id == "trump" % If the dialogue is about the trump
         if start==username % If the user started the game == If user is "left" of dealer
            verdict = upper(input('Choose trump or pass Diamonds(D), Hearts(H), Spades(S), Clubs(C), Pass(P): ','s'));
            while noSuite == verdict
                println("That suite was already turned down");
                verdict = upper(input('Choose trump or pass Diamonds(D), Hearts(H), Spades(S), Clubs(C), Pass(P): ','s'));
            end
            write(lobby, username, verdict, "trump");
         else
            awaitTurn(lobby,username,users,dealer,"trump",noSuite);
         end
        if exist('trick','var')
            ret = createKeyServer(lobby,true,"bid",false,point, trick);
        else
            ret = createKeyServer(lobby,true,"bid",false);
        end
    end
end

