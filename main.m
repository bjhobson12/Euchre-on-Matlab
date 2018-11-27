%% Copyright
% Author: Benjamin Hobson
% Date: Nov 1, 2018
% Name: Euchre V1 Verso L''Alto
% Version: 1.0

%% Setup
load 'CardDeck.mat' RedDeck
layout = [1, 3, 5, 9, 7];

username = safeInput('Enter your username: ','Enter a username excluding spaces: '); % Username collected

lobbies = getLobbies(); % Lobbies are retrieved
if lobbies ~= "No lobbies created"
    println("The current lobbies for euchre are: ");
    for i=1:length(lobbies)
        println(lobbies(i)); % Prints lobbies
    end
else
    println("No lobbies created"); % Prints no lobbbies
end

if input('Enter lobby (1) or make lobby (2): ') == 1 % Choice given to user
    lobby = safeInput('Enter lobby name: ','Enter a lobby name excluding spaces: '); % Lobby name collected
    joinLobby(lobby,username); % Enter lobby
else
    lobby = safeInput('Enter lobby name: ','Enter a lobby name excluding spaces: '); % Lobby name collected
    makeLobby(lobby,username); % Make lobby
end

while ~lobbyReady(lobby) % Wait for 4 users
    pause(8);
end

pause(randi([10 25],1)); % Offset users for the limited back-end capability

hands = readHand(lobby,username); % Read hands distributed for the entire game
users = hands("users"); % Stores users

println("Here we go...");

%% Main
team1 = [users(1),users(3)];
team2 = [users(2),users(4)];
team1Score = 0;
team2Score = 0;
team1TrickScore = 0;
team2TrickScore = 0;
figure('units','normalized','outerposition',[0 1 1 .7],'Name','Euchre V1 Verso L''Alto') % Est. figure

for point=1:19
    
    if team1Score == 10 || team2Score == 10 % Escape next round if someone wins
        break;
    end
    
    subplot(3,3,4);
    imshow([RedDeck{[]}]);
    title(users(1) + " & " + users(3) + " have " + team1Score + " points");
    subplot(3,3,6);
    imshow([RedDeck{[]}]);
    title(users(2) + " & " + users(4) + " have " + team2Score + " points");
    
    println("Starting new hand");
    
    reinitialze(username,users,point,hands,[55,55,55,55,55],true); % Est. display
    dealer = users(mod(point-1,4)+1); % Initial dealer is dependent of point
    
    if arrindex(users,dealer) == 4 % Determine who is "left" of the dealer
        start = users(1);
    else
        start = users(arrindex(users,dealer)+1);
    end
    
    cardTaken = createDialogue(lobby, username, users, start, dealer, "bid"); % Asks everyone what they want, when/if its their turn
    subplot(3,3,5);
    imshow([RedDeck{[]}]); % Hide kitty
    kitty = hands(char(""+point+"k"));
    if cardTaken
        trump = extractBetween(kitty(1),1,1); % Get trump
        if username == dealer
            temp = hands(""+point);
            temp(6) = kitty(1);
            hands(""+point) = temp;
            reinitialze(username,users,point,hands,[55,55,55,55,55],true);
            subplot(3,3,5);
            imshow([RedDeck{[]}]);
            inp = input('Deposit a card ex. ''S9'' == 9 of Spades: ','s');
            while arrindex(hands(char(""+point)),inp) == -1
                inp = input('Deposit a valid card: ','s');
            end
            temp = hands(""+point);
            temp(arrindex(hands(char(""+point)),inp)) = [];
            hands(""+point) = temp;
        else
            reinitialze(username,users,point,hands,[55,55,55,55,55],true);
            subplot(3,3,layout(arrindex(users,dealer)));
            imshow([RedDeck{[55,55,55,55,55,55]}]);
            title(dealer + " (dealer)");
            pause(5);
            imshow([RedDeck{[55,55,55,55,55]}]);
            title(dealer + " (dealer)");
        end
    else
        noSuite = extractBetween(kitty(1),1,1);
        trump = createDialogue(lobby, username, users, start, dealer, "trump", noSuite);
    end 
    
    
    println("The trump is " + trump);
    println("Round no. " + point);
    
    for trick=1:5
        
        subplot(3,3,2);
        imshow([RedDeck{[]}]);
        title(users(1) + " & " + users(3) + " have " + team1TrickScore + " tricks");
        subplot(3,3,8);
        imshow([RedDeck{[]}]);
        title(users(2) + " & " + users(4) + " have " + team2TrickScore + " tricks");
        
        subplot(3,3,5);
        imshow([RedDeck{[]}]);
        
        flippedCards(1,1:6-trick) = 55;
        id = ""+point+trick;
        
        reinitialze(username,users,point,hands,flippedCards,false);
        
        if trick ~= 1
            start = nextDealer;
        end
        
        if start == username
            inp = input('Play a card formatted ex. ''S9'' == 9 of Spades: ','s');
            while arrindex(hands(char(""+point)),inp) == -1
                inp = input('Play a card formatted ex. ''S9'' == 9 of Spades: ', 's');
            end
            temp = hands(""+point);
            temp(arrindex(temp,inp)) = [];
            hands(""+point) = temp;
            write(lobby, username, inp, id);
            reinitialze(username,users,point,hands,flippedCards,false);
        else
            while ~myTurn(lobby,username,users,id)
                update(lobby, point, trick);
                pause(randi([10 15],1));
            end
            update(lobby, point, trick);
            inp = input('Play a card formatted ''S9'' == 9 of Spades: ','s');
            while arrindex(hands(char(""+point)),inp) == -1
                inp = input('Play a card formatted ''S9'' == 9 of Spades: ', 's');
            end
            temp = hands(""+point);
            temp(arrindex(temp,inp)) = [];
            hands(""+point) = temp;
            write(lobby, username, inp, id);
            reinitialze(username,users,point,hands,flippedCards,false);
        end
        
        createKeyServer(lobby,"",id,false, point, trick);
        
        reinitialze(username,users,point,hands,flippedCards,false);
        
        pause(randi([5 10],1));
        
        res = request('read','lobby',lobby,'id',id);
        pause(randi([5 10],1));
        nextDealer = whoWon(users, res, trump, start);
        
        if arrindex(team1,nextDealer)
            team1TrickScore = team1TrickScore + 1;
        else
            team2TrickScore = team2TrickScore + 1;
        end
        
        clear flippedCards;
    end
    
    if team1TrickScore >= 3
        team1Score = team1Score + 1;
    else
        team2Score = team2Score + 1;
    end
    
    team1TrickScore = 0;
    team2TrickScore = 0;
    clear nextDealer;
    
    pause(10);
end

if team1Score == 10
    team1
    fprintf("Won");
else
    team2
    fprintf("Won");
end

fprintf("Thanks for playing\n");
close all;
pause(5);
clear all;