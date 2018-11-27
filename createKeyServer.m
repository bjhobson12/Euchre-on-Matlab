function ret = createKeyServer(varargin)
%createKeyServer Returns database changes
%   Synchronous listener at /lobby/id

    lobby = varargin(1);
    val = varargin(2);
    id = varargin(3);
    inv = varargin(4);
    lobby = lobby{1};
    val = val{1};
    id = id{1};
    inv = inv{1};
    try
        point = varargin(5);
        trick = varargin(6);
        point = point{1};
        trick = trick{1};
    catch
    end

    while true
        
        if exist('trick','var')
            update(lobby, point, trick);
        end
        
        res = request('read','lobby',char(""+lobby),'id',char(""+id));
        if ~(res=="{}")
            dataMap = struct2map(jsondecode(res));
            keyss = keys(dataMap);

            for i=1:length(keyss)
                cmp = dataMap(keyss{i});
                if cmp == "true"
                    cmp = eval(cmp);
                end
                if inv
                    if cmp ~= val
                        ret = cmp;
                    end
                else
                    if cmp == val
                        ret = cmp;
                    end
                end
            end
            if exist('ret','var')
                break;
            end
        end
        
        if (id~="trump") && length(keyss) == 4 
            ret = false;
            break;
        end
        pause(randi([20 35],1));
    end
end

