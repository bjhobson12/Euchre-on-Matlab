function ret = card(i)
%card Indexes the correct card image given a tag
%   Given a string, this function returns the img of card
    deck = [ "C9","C1","CJ","CQ","CK","CA";
    "S9","S1","SJ","SQ","SK","SA";
    "H9","H1","HJ","HQ","HK","HA";
    "D9","D1","DJ","DQ","DK","DA"];
    pos = [ 9,10,11,12,13,1;
    22,23,24,25,26,14;
    35,36,37,38,39,27;
    48,49,50,51,52,40];

    ret = [];

    if class(i)~="logical"
        dent = reshape(pos',[1,24]);
        if length(i) == 1
            ret = dent(find(reshape(deck',[1,24])==i));
        else
            for k=1:length(i) 
                ret(k) = dent(find(reshape(deck',[1,24])==i(k)));
            end
        end
    elseif class(i)=="logical"
        ret = deck;
    end
end

