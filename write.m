function ret = write(lob, usr, inp, id)
%write Writes initial decisions to database
%   Stores whether or not user wants dealer to pickup
    request('write','lobby',char(lob),'user',char(usr),'data',char(""+inp),'id',char(id));
    ret = inp;
end