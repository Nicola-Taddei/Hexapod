% This is used to place the body parallel to the terrain even in case of
% climb or descent. It modifies the endpoints of the legs.


% if temp.islegpushing(1)==1
%     if temp.req.leg1.z < 95
% %         temp.req.leg1.z = temp.req.leg1.z + 20;  %provare ad aggiungere solo +20 alla prima
% %         temp.req.leg5.z = temp.req.leg5.z - 20;
%         temp.req.leg1.z = temp.req.leg4.z;    %da provare!!
%         temp.req.leg5.z = temp.req.leg4.z;
%     elseif temp.req.leg1.z > 140
%         temp.req.leg1.z = temp.req.leg1.z - 20;
%         temp.req.leg5.z = temp.req.leg5.z + 20;
%     end
%     
% elseif temp.islegpushing(2)==1
%     if temp.req.leg2.z < 95
% %         temp.req.leg2.z = temp.req.leg2.z + 20;
% %         temp.req.leg6.z = temp.req.leg6.z - 20;
%       temp.req.leg2.z = temp.req.leg3.z;    %da provare!!
%       temp.req.leg6.z = temp.req.leg3.z;
%     elseif temp.req.leg2.z > 140
%         temp.req.leg2.z = temp.req.leg2.z - 20;
%         temp.req.leg6.z = temp.req.leg6.z + 20;
%     end
%     
%     
% end

%Metodo 2: std_h
if temp.islegpushing(1)==1
    if temp.req.leg1.z < (std_h-5)
        temp.req.leg1.z = std_h;
        temp.req.leg5.z = std_h;
    elseif temp.req.leg1.z > (std_h+5)
        temp.req.leg1.z = std_h;
        temp.req.leg5.z = std_h;
    end
    
elseif temp.islegpushing(2)==1
    if temp.req.leg2.z < (std_h-5)
        temp.req.leg2.z = std_h;
        temp.req.leg6.z = std_h;
    elseif temp.req.leg2.z > (std_h+5)
        temp.req.leg2.z = std_h;
        temp.req.leg6.z = std_h;
    end
    
end

%bisogna capire perchè col leg adjust non riesce a pushare 60 ma arriva
%solo a 40 (quindi fa 80 al posto di 120)

%aggiungere qualcosa alla coordinata x (per la leg 1,2) e togliere(?) alle
%leg 5,6.   Valutare anche cosa fare con la y (ma non penso sia un
%problema)