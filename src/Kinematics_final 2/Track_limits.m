%This code is to detect when the robot is in a dangerous position because
%it is on the border of the testing terrain 

%x=290 limit


if temp.h==1
   if -TMatr.(['gait' num2str(k)]).M4(2,4)<200
        delete(h);
        clear('h');
       temp.h = 0;
       temp.h2 = 0;
   else
       temp.h2 = 1;
   end
end

if -TMatr.(['gait' num2str(k)]).M4(2,4)>200 && temp.h2==0
    h = msgbox('TERRAIN LIMITS REACHED!','WARNING!','warn');
    movegui(h,[950 100]);
    beep;
    temp.h = 1;
end


%left side limit
if temp.h3==1
   if -TMatr.(['gait' num2str(k)]).M4(2,4)>-1560
        delete(h);
        clear('h');
       temp.h3 = 0;
       temp.h4 = 0;
   else
       temp.h4 = 1;
   end
end

if -TMatr.(['gait' num2str(k)]).M4(2,4)<-1560 && temp.h4==0
    h = msgbox('TERRAIN LIMITS REACHED!','WARNING!','warn');
    movegui(h,[950 100]);
    beep;
    temp.h3 = 1;
end