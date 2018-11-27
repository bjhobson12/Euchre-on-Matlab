function [] = update(lobby, point, trick)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    load 'CardDeck.mat' RedDeck
    res = request('read','lobby',lobby,'id',""+point+trick);
    subplot(3,3,5);
    if res ~= "{}"
        dataMap = struct2map(jsondecode(res));
        keyss = keys(dataMap);
        for i=1:length(keyss)
            currentKey = keyss{i};
            show{i} = dataMap(currentKey);
        end
        imshow([RedDeck{card(show)}]);
    end
    
end

