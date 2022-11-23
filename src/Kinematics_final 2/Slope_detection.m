%This code is used for detect if the robot is moving uphill or downhill
...and plot the corresponding figure

%case TRIPOD
if temp.Nsteps==4
if temp.islegpushing(1)==1
    if temp.req.leg1.z < (std_h-10)   
        z(p) = 1;
        if temp.req.leg5.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg1.z > (std_h+10)
        z(p) = 1;
        if temp.req.leg5.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
    
elseif temp.islegpushing(2)==1
    if temp.req.leg2.z < (std_h-10)     %caso salita
%         text_str = ['WARNING! DIFFICULT TERRAIN'];
%         instimage = myicon3;
%         position =  [90 95];
        z(p) = 1;
        if temp.req.leg6.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg2.z > (std_h+10) %caso discesa
%         text_str = ['WARNING! DIFFICULT TERRAIN'];
%         instimage = myicon4;
%         position =  [104 136];
        z(p) = 1;
        if temp.req.leg6.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
end
end

%case AMBLE
if temp.Nsteps==6
if temp.islegpushing(1)==1
    if temp.req.leg1.z < (std_h-10)     %caso salita
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon3;
        position =  [90 95];
        z(p) = 1;
        if temp.req.leg6.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg1.z > (std_h+10) %caso discesa
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon4;
        position =  [104 136];
        z(p) = 1;
        if temp.req.leg6.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
    
elseif temp.islegpushing(2)==1
    if temp.req.leg2.z < (std_h-10)     %caso salita
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon3;
        position =  [90 95];
        z(p) = 1;
        if temp.req.leg5.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg2.z > (std_h+10) %caso discesa
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon4;
        position =  [104 136];
        z(p) = 1;
        if temp.req.leg5.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
    
end
end


%case RIPPLE
if temp.Nsteps==12
if temp.islegpushing(1)==1 && temp.islegpushing(5)==1
    if temp.req.leg1.z < (std_h-10)     %caso salita
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon3;
        position =  [90 95];
        z(p) = 1;
        if temp.req.leg5.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg1.z > (std_h+10) %caso discesa
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon4;
        position =  [104 136];
        z(p) = 1;
        if temp.req.leg5.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
    
elseif temp.islegpushing(2)==1 && temp.islegpushing(6)==1
    if temp.req.leg2.z < (std_h-10)     %caso salita
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon3;
        position =  [90 95];
        z(p) = 1;
        if temp.req.leg6.z > (std_h+10)
        else
            z(p) = 0;
        end
    elseif temp.req.leg2.z > (std_h+10) %caso discesa
        text_str = ['WARNING! DIFFICULT TERRAIN'];
        instimage = myicon4;
        position =  [104 136];
        z(p) = 1;
        if temp.req.leg6.z < (std_h-10)
        else
            z(p) = 0;
        end
    end
    
end
end


if z(p)~=z(p-1)
    if z(p)==0
        if exist('g', 'var')
            delete(g);
            clear('g');
        end
    else
        g = msgbox('DANGEROUS TERRAIN!','WARNING!','warn','replace');
        movegui(g,[600 100]);
        beep;
    end
end
