function ret = awaitTurn(varargin)
%awaitTurn This function cray
%   Idek

    lobby = varargin(1);
    username = varargin(2);
    users = varargin(3);
    dealer = varargin(4);
    id = varargin(5);
    try 
        noSuite = varargin(6);
        noSuite = noSuite{1};
    catch
    end
    
    lobby = lobby{1};
    username = username{1};
    users = users{1};
    dealer = dealer{1};
    id = id{1};

    ret = false;
    layout = [1, 3, 5, 9, 7];
    load 'CardDeck.mat' RedDeck
    c = myTurn(lobby,username,users,id);
    if class(c) ~= "char" &&  class(c) ~= "Double" % Bool
        while ~c % Not your turn
            pause(randi([10 15],1));
            c = myTurn(lobby,username,users,id);
            if class(c) == "char" % True when someone has decided, and their name becomes c
                break;
            end
        end
        if class(c) == "char" % Someone said yes
            i = arrindex(users,dealer);
            if i >=3
                i = i + 1;
            end
            subplot(3,3,layout(i));
            imshow([RedDeck{[55,55,55,55,55,55]}]); % Add card to dealer if requested
            title(dealer); % Add their name
            ret = true;
        else % My turn
            if dealer == username % Made back around to dealer
                if id == "trump"
                    println("Stuck the dealer");
                    verdict = upper(input('Choose Diamonds(D), Hearts(H), Spades(S), Clubs(C): ','s'));
                    while noSuite == verdict
                        println("That suite was already turned down");
                        verdict = upper(input('Choose Diamonds(D), Hearts(H), Spades(S), Clubs(C): ','s'));
                    end
                    pause(4);
                    ret = write(lobby, username, verdict, "trump"); % Bool response of server
                else
                    pause(4);
                    ret = write(lobby, username, input('Do you want the card? Yes(1), or No(0): ')==1,id);
                end
            else
                if id == "trump"
                    verdict = upper(input('Choose trump or pass Diamonds(D), Hearts(H), Spades(S), Clubs(C), Pass(P): ','s'));
                    while noSuite == verdict
                        println("That suite was already turned down");
                        verdict = upper(input('Choose trump or pass Diamonds(D), Hearts(H), Spades(S), Clubs(C), Pass(P): ','s'));
                    end
                    pause(4);
                    ret = write(lobby, username, verdict, "trump");
                else
                    pause(4);
                    ret = write(lobby, username, input('Should ' + dealer + ' take the card? Yes(1), or No(0): ')==1,id);
                end
            end
            
        end
    else
        if id == "trump"
            if class(c) == "char"
                ret = c; % Return suite chosen
            end
        else
            if class(c) == "char"
                i = arrindex(users,dealer);
                if i >=3
                    i = i + 1;
                end
                subplot(3,3,layout(i));
                imshow([RedDeck{[55,55,55,55,55,55]}]); % Add card to dealer if requested
                title(dealer); % Add their name
                ret = true;
            end
        end
    end
end

