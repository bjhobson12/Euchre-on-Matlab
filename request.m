function res = request(varargin)
%request Speaks with firestore database vargs = [funcName, param1, val1, paramN, valN]
%   Using paramters, constructs http post request to firestore cloud functions
    urlParams = "https://us-central1-euchre-sdp18.cloudfunctions.net/" + varargin(1); % Finds function
    if length(varargin)-1 ~= 0
        urlParams = urlParams + "?";
        for i=2:2:(length(varargin)-1)
            if i ~= 2
                urlParams = urlParams + '&' + varargin(i) + '=' + char("" + varargin(i+1)); % Adds parameters to url
            else
                urlParams = urlParams + varargin(i) + '=' + varargin(i+1); % Adds first parameter to url
            end
        end
    end
    options = weboptions('MediaType','application/x-www-form-urlencoded','RequestMethod','post','Timeout',30); % Options
    res = webread([char(urlParams)], options); % Request
end

