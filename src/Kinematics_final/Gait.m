% This generates the movement. It runs every step the inverse kinematics,
% the controller and all the codes for the animation.

%% Initial Point Generation

temp.body.bodyRotX = fun.body.bodyRotX(1,1,1,1); %from Position_and_Control
temp.body.bodyRotY = fun.body.bodyRotY(1,1,1,1);
temp.body.bodyRotZ = fun.body.bodyRotZ(1,1,1,1);
temp.body.bodyPosX = fun.body.bodyPosX(1,1,1,1);
temp.body.bodyPosY = fun.body.bodyPosY(1,1,1,1);
temp.body.bodyPosZ = fun.body.bodyPosZ(1,1,1,1);

temp.body.absbodyPosX = fun.body.absbodyPosX(1,1,1,1);
temp.body.absbodyPosY = fun.body.absbodyPosY(1,1,1,1);
temp.body.absbodyPosZ = fun.body.absbodyPosZ(1,1,1,1);

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
data.gait1.endpoints0 = temp.req;


temp.reqold = temp.req;
temp.gaitold = temp.gait;
temp.bodyold = temp.body;

if ctrl.control == 1
    run('Robot_Setup') % this is used to return the robot in the initial position at the start
end

%% Picture Vectors Storage

% figure(1)

if ctrl.gif.saveasgif == 1
    temp.iter = 1;
end

figure(1)
for k = 1:vars.Nloops
    
    temp.gaitData = gaitSelect(mov.GaitType(k));
    
    temp.Nsteps = temp.gaitData.stepsInCycle;
    
    if k ~= 1
        
        TMatr.(['gait' num2str(k)]).M0 = TMatr.(['gait' num2str(k-1)]).(['M' num2str(j)]);
        TMatr.(['gait' num2str(k)]).M_Tr0 = TMatr.(['gait' num2str(k-1)]).(['M_Tr' num2str(j)]);
        
        TMatr.(['gait' num2str(k)]).BM_rel0 = TMatr.(['gait' num2str(k-1)]).(['BM_rel' num2str(j)]);
        data.(['gait' num2str(k)]).v0 =  data.(['gait' num2str(k-1)]).(['v' num2str(j)]);
        data.(['gait' num2str(k)]).angles0 =  data.(['gait' num2str(k-1)]).(['angles' num2str(j)]);
        data.(['gait' num2str(k)]).legdata0.islegpushing = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).islegpushing;
        data.(['gait' num2str(k)]).legdata0.islegraised = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).islegraised;
        data.(['gait' num2str(k)]).legdata0.isleglowering = data.(['gait' num2str(k-1)]).(['legdata' num2str(j)]).isleglowering;
        data.(['gait' num2str(k)]).endpoints0 = data.(['gait' num2str(k-1)]).(['endpoints' num2str(j)]);
        
    end
    
    data.bodypos.x(k) = [1 0 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    data.bodypos.y(k) = [0 1 0 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    data.bodypos.z(k) = [0 0 1 0]*eval(['TMatr.gait' num2str(k) '.M0'])*globalCS.M_globalbody*[0 ; 0 ; 0 ; 1];
    
    figure(1)
    
    for j = 1:temp.Nsteps
        
        hold off
        
        for i = 1:6
            
            temp.gait = temp.gaitData.gaitGen(i,j,k,mov,temp.gait,temp.gaitData);
            
        end
        
        temp.body.bodyRotX = fun.body.bodyRotX(j,k,temp.Nsteps,vars.Nloops);
        temp.body.bodyRotY = fun.body.bodyRotY(j,k,temp.Nsteps,vars.Nloops);
        temp.body.bodyRotZ = fun.body.bodyRotZ(j,k,temp.Nsteps,vars.Nloops);
        temp.body.bodyPosX = fun.body.bodyPosX(j,k,temp.Nsteps,vars.Nloops);
        temp.body.bodyPosY = fun.body.bodyPosY(j,k,temp.Nsteps,vars.Nloops);
        temp.body.bodyPosZ = fun.body.bodyPosZ(j,k,temp.Nsteps,vars.Nloops);
        
        temp.body.absbodyPosX = fun.body.absbodyPosX(j,k,temp.Nsteps,vars.Nloops);
        temp.body.absbodyPosY = fun.body.absbodyPosY(j,k,temp.Nsteps,vars.Nloops);
        temp.body.absbodyPosZ = fun.body.absbodyPosZ(j,k,temp.Nsteps,vars.Nloops);
        
        run('Inverse_Kinematics')
        
        if ctrl.control == 1
            run('Legs_adjust')
        end
        
        if ctrl.control == 1
            run('Robot_Controller')
        end
        
        run('Leg_Angles')
        run('Robot_Visualizator')
        
        if sum(temp.isleglowering) > 0
            run('Height_Correction')
            run('Position_Correction')
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
    
end
