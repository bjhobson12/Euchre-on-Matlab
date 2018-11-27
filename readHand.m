function ret = readHand(lobby,user)
%readHand Gets the hands assigned to each person
%   Reads hands and stores them
    res = request('hand','lobby',char(lobby));
    
    dataMap = struct2map(jsondecode(res));
    users = dataMap("users");
    users = [""+users{1},""+users{2},""+users{3},""+users{4}];
    dataMap = struct2map(dataMap('hands'));
    hand = containers.Map;
    keyss = keys(dataMap);
    
    for i=1:length(keyss)
        currentKey = keyss{i};
        data = struct2map(dataMap(currentKey));
        hand(char(""+i)) = data(user);
        hand(char("kitty" + i)) = data('kitty');
    end
    
    ret = hand;
    clear res;
    clear dataMap;
    clear hand;
    clear keyss;
    clear data;
    temp = containers.Map;
    
    for i=1:length(ret)/2
        deal = cell2mat(ret(char(""+i)));
        kitty = cell2mat(ret(char("kitty" + i)));
        temp(""+i) = [""+deal(1,1)+deal(1,2),""+deal(2,1)+deal(2,2),""+deal(3,1)+deal(3,2),""+deal(4,1)+deal(4,2),""+deal(5,1)+deal(5,2)];
        temp(""+i+"k") = [""+kitty(1,1)+kitty(1,2),""+kitty(2,1)+kitty(2,2),""+kitty(3,1)+kitty(3,2),""+kitty(4,1)+kitty(4,2)];
    end
    
    temp("users") = users;
    ret = temp;
end