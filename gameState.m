function ret = gameState(lob)
%gameState Checks score to update gameState
%   Checks firestore to see if 10 points have been achieved
    res = request('gameState', 'lobby', char(lob));
    ret = eval(res);
end

