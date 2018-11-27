function ret = safeInput(petition,petitionSafe)
%safeInput Gets info from user safely
%   Gets info from user, repeating until desirable
    ret = input(petition,'s'); % Data collected
    while ~strIsClean(ret) % Checks data for formatting
        ret = input(petitionSafe,'s');
    end
end

