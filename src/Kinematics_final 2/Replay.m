%% Robot Animation

figure(1)

data.bodypos = {};
vars.Nloops = numel(fieldnames(data)) - 1;
l=1;

if ctrl.gif.saveasgif == 1
    temp.iter = 1;
end

for k = 1:vars.Nloops
    
    temp.Nsteps = (numel(fieldnames(data.(['gait' num2str(k)]))) - 3)/3;
    
    if ctrl.boolP == 1
        
        if not(k==1 || temp.distance > 10)
            l = l + 1;
        end
        
        ref.x = fun.ref.x(k,l);
        ref.y = fun.ref.y(k,l);
        ref.z = TerrainFun(ref.x,ref.y,terrain);
        
        temp.dummy = inv(eval(['TMatr.gait' num2str(k) '.M0']))*[ref.x ; ref.y ; ref.z ; 1];
        bodyref.x = temp.dummy(1);
        bodyref.y = temp.dummy(2);
        temp.distance = sqrt((bodyref.y)^2 + (bodyref.x)^2);
        
        data.bodypos.x(k) = [1 0 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
        data.bodypos.y(k) = [0 1 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
        data.bodypos.z(k) = [0 0 1 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
        
    end
    
    run('Robot_Animator')
    
end