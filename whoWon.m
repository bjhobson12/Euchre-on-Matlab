function ret = whoWon(users,res,trump, start)
%whoWon Returns who won the point
%   Returns who won the point

    D = {"DJ","HJ","DA","DK","DQ","D1","D9"};
    H = {"HJ","DJ","HA","HK","HQ","H1","H9"};
    S = {"SJ","CJ","SA","SK","SQ","S1","S9"};
    C = {"CJ","SJ","CA","CK","CQ","C1","C9"};
    
    dataMap = struct2map(jsondecode(res));
    keyss = keys(dataMap);
    
    dealerPlay = extractBetween(dataMap(start),1,1);
    dealerPlay = dealerPlay{1};
    indexer = eval(trump);
    deal = eval(dealerPlay);
    for i=1:length(deal)
        indexer{length(indexer)+1} = deal{i};
    end
    usr = 1;
    while arrindex(indexer,dataMap(users(usr))) == -1
        usr = usr + 1;
    end
    for i=1:4
        if arrindex(indexer,dataMap(users(i))) < arrindex(indexer,dataMap(users(usr))) && arrindex(indexer,dataMap(users(i)))~=-1
            usr = i;
        end
    end
    
    ret = users(usr);
end

