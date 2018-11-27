function ret = leftOf(users,dealer)
%leftOf Gets left element of array
%   Gets n-1 for n>1 else n
    if arrindex(users,dealer) == 4 % Determine who is "left" of the dealer
        ret = users(1);
    else
        ret = users(arrindex(users,dealer)+1);
    end
end

