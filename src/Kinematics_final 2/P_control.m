% This generates the movement, running every step the inverse kinematics,
% the controller and all the codes for the animation.

%% Initial Point Generation

temp.body.bodyRotX = fun.body.bodyRotX(1,1,1);
temp.body.bodyRotY = fun.body.bodyRotY(1,1,1);
temp.body.bodyRotZ = fun.body.bodyRotZ(1,1,1);
temp.body.bodyPosX = fun.body.bodyPosX(1,1,1);
temp.body.bodyPosY = fun.body.bodyPosY(1,1,1);
temp.body.bodyPosZ = fun.body.bodyPosZ(1,1,1);

temp.body.absbodyPosX = fun.body.absbodyPosX(1,1,1);
temp.body.absbodyPosY = fun.body.absbodyPosY(1,1,1);
temp.body.absbodyPosZ = fun.body.absbodyPosZ(1,1,1);

temp.firstiter = 1;
run('Inverse_Kinematics')
run('Leg_Angles')
temp.firstiter = 0;
run('Robot_Visualizator')

TMatr.gait1.M0 = TMatr.gait1.M1;
TMatr.gait1.M_Tr0 = TMatr.gait1.M_Tr1;

TMatr.gait1.BM_rel0 = TMatr.gait1.BM_rel1;
data.gait1.v0 =  temp.v;
data.gait1.angles0 =  temp.angles;
data.gait1.legdata0.islegpushing = temp.islegpushing;
data.gait1.legdata0.islegraised = temp.islegraised;
data.gait1.legdata0.isleglowering = temp.isleglowering;

temp.reqold = temp.req;
temp.gaitold = temp.gait;
temp.bodyold = temp.body;

if ctrl.control == 1
    run('Robot_Setup') % this is used to return the robot in the initial position at the start
end

%% Control Loop

figure(1)

if ctrl.gif.saveasgif == 1
    temp.iter = 1;
end

% temp.cumdistance = 0;
% temp.cumtheta = 0;
% ind = 1;

while(l <= ref.lmax && k <= ref.kmax)
    
    if k==1 || temp.distance > 20
        temp.gaitData = gaitSelect(mov.GaitType);
    else
        temp.gaitData = gaitSelect('NONE');
        l = l + 1;
    end
    
    ref.x = fun.ref.x(k,l);
    ref.y = fun.ref.y(k,l);
    ref.z = TerrainFun(ref.x,ref.y,terrain);
    
    temp.Nsteps = temp.gaitData.stepsInCycle;
    
    if k ~=1
        
        TMatr.(['gait' num2str(k)]).M0 = TMatr.(['gait' num2str(k-1)]).(['M' num2str(j)]);
        TMatr.(['gait' num2str(k)]).M_Tr0 = TMatr.(['gait' num2str(k-1)]).(['M_Tr' num2str(j)]);
        
        TMatr.(['gait' num2str(k)]).BM_rel0 = TMatr.(['gait' num2str(k-1)]).(['BM_rel' num2str(j)]);
        data.(['gait' num2str(k)]).v0 =  data.(['gait' num2str(k-1)]).(['v' num2str(j)]);
        data.(['gait' num2str(k)]).angles0 =  data.(['gait' num2str(k-1)]).(['angles' num2str(j)]);
        data.(['gait' num2str(k)]).legdata0.islegpushing = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).islegpushing;
        data.(['gait' num2str(k)]).legdata0.islegraised = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).islegraised;
        data.(['gait' num2str(k)]).legdata0.isleglowering = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).isleglowering;
        
    end
    
    data.bodypos.x(k) = [1 0 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    data.bodypos.y(k) = [0 1 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    data.bodypos.z(k) = [0 0 1 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    
    temp.dummy = inv(eval(['TMatr.gait' num2str(k) '.M_Tr0']))*[ref.x ; ref.y ; ref.z ; 1];
    
    bodyref.x = temp.dummy(1);
    bodyref.y = temp.dummy(2);
    
    temp.theta = atan2(bodyref.y,bodyref.x);
    temp.distance = sqrt((bodyref.y)^2 + (bodyref.x)^2);
%     temp.cumdistance = temp.cumdistance + temp.distance;
%     temp.cumtheta = temp.cumtheta + temp.theta;
    
%     temp.vdistance(ind) = temp.distance;
%     temp.vtheta(ind) = temp.theta;
%     ind = ind + 1;
    
    temp.kp = 100*(temp.distance > 125) + temp.distance*(temp.distance <= 125)/2;
%     temp.ki = 0.01*temp.cumdistance;
%     temp.ki = 0; % For P-control only
    
%     mov.Xspeed(k) = (temp.kp + temp.ki)*cos(temp.theta);
%     mov.Yspeed(k) = (temp.kp + temp.ki)*sin(temp.theta)/2;
%     mov.Rspeed(k) = (1*temp.theta + 0.1*temp.cumtheta)/pi;

    mov.Xspeed(k) = temp.kp*cos(temp.theta)*multiplier(mov.GaitType);
    mov.Yspeed(k) = temp.kp*sin(temp.theta)*multiplier(mov.GaitType)/2;
    mov.Rspeed(k) = temp.kp*temp.theta/pi/100*multiplier(mov.GaitType);
    
    figure(1)
    
    for j = 1:temp.Nsteps
        
        hold off
        
        for i = 1:6
            
            temp.gait = temp.gaitData.gaitGen(i,j,k,mov,temp.gait,temp.gaitData);
            
        end
        
        temp.body.bodyRotX = fun.body.bodyRotX(j,k,temp.Nsteps);
        temp.body.bodyRotY = fun.body.bodyRotY(j,k,temp.Nsteps);
        temp.body.bodyRotZ = fun.body.bodyRotZ(j,k,temp.Nsteps);
        temp.body.bodyPosX = fun.body.bodyPosX(j,k,temp.Nsteps);
        temp.body.bodyPosY = fun.body.bodyPosY(j,k,temp.Nsteps);
        temp.body.bodyPosZ = fun.body.bodyPosZ(j,k,temp.Nsteps);
        
        temp.body.absbodyPosX = fun.body.absbodyPosX(j,k,temp.Nsteps);
        temp.body.absbodyPosY = fun.body.absbodyPosY(j,k,temp.Nsteps);
        temp.body.absbodyPosZ = fun.body.absbodyPosZ(j,k,temp.Nsteps);
        
        run('Inverse_Kinematics')
        
        if ctrl.control == 1
            run('Robot_Controller')
        end
        
        run('Leg_Angles')
        run('Robot_Visualizator')
        
        if sum(temp.isleglowering) > 0
            run('Height_Correction')
        end
        
        run('Leg_Angles')
        run('Robot_Visualizator')
        
        data.(['gait' num2str(k)]).(['v' num2str(j)]) =  temp.v;
        data.(['gait' num2str(k)]).(['angles' num2str(j)]) = temp.angles;
        data.(['gait' num2str(k)]).gaitData =  temp.gaitData;
        data.(['gait' num2str(k)]).(['legdata' num2str(j)]).islegpushing = temp.islegpushing;
        data.(['gait' num2str(k)]).(['legdata' num2str(j)]).islegraised = temp.islegraised;
        data.(['gait' num2str(k)]).(['legdata' num2str(j)]).isleglowering = temp.isleglowering;
        data.(['gait' num2str(k)]).(['endpoints' num2str(j)]) = temp.req;
        
        run('Robot_Animator')
        
        temp.reqold = temp.req;
        temp.gaitold = temp.gait;
        temp.bodyold = temp.body;
        
    end
    
    
    k = k + 1;
    
end
