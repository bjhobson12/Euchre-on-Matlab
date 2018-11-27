function [] = reinitialze(username,users,point,hands,flippedCards,showKitty)
%reinitialize Draw to figure for setup
%   Draws to figure

	load 'CardDeck.mat' RedDeck
    
    layout = [1, 3, 5, 9, 7];
    
    for view=1:5
        subplot(3,3,layout(view));
        i = view;
        if view~=3
            if i>3
                i = i - 1;
            end
            if ""+username~=users(i)
                imshow([RedDeck{flippedCards}]);
            else
                imshow([RedDeck{card(hands(char(""+point)))}]);
            end
            title(users(i)); 
        elseif showKitty
            k = hands(char(""+point+"k"));
            imshow([RedDeck{card(k(1))}]);
            title("Kitty");
        else
            imshow([RedDeck{[]}]);
        end
    end
end

