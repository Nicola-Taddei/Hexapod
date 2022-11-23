% This generates the movement. It runs every step the inverse kinematics,
% the controller and all the codes for the animation.

%% Initial Point Generation

fun.body.bodyRotX = @(j,k,Nsteps) 0*pi/10*sin(j/Nsteps*2*pi);
fun.body.bodyRotY = @(j,k,Nsteps) 0*pi/10*cos(j/Nsteps*2*pi);
fun.body.bodyRotZ = @(j,k,Nsteps) 0*pi/10*sin(j/Nsteps*2*pi);
fun.body.bodyPosX = @(j,k,Nsteps) 0*40*cos(j/Nsteps*2*pi);
fun.body.bodyPosY = @(j,k,Nsteps) 0*60*sin(j/Nsteps*2*pi);
fun.body.bodyPosZ = @(j,k,Nsteps) 0*(60*cos(j/Nsteps*2*pi));
    
fun.body.absbodyPosX = @(j,k,Nsteps) 0*40*cos(j/Nsteps*2*pi);
fun.body.absbodyPosY = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
fun.body.absbodyPosZ = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
    
temp.body.bodyRotX = fun.body.bodyRotX(1,1,1);
temp.body.bodyRotY = 0;
temp.body.bodyRotZ = 0;
temp.body.bodyPosX = 0;
temp.body.bodyPosY = 0;
temp.body.bodyPosZ = 0;

temp.body.absbodyPosX = 0;
temp.body.absbodyPosY = 0;
temp.body.absbodyPosZ = 0;

% % temp.body.bodyRotX = fun.body.bodyRotX(1,1,1,1); %from Position_and_Control
% % temp.body.bodyRotY = fun.body.bodyRotY(1,1,1,1);
% % temp.body.bodyRotZ = fun.body.bodyRotZ(1,1,1,1);
% % temp.body.bodyPosX = fun.body.bodyPosX(1,1,1,1);
% % temp.body.bodyPosY = fun.body.bodyPosY(1,1,1,1);
% % temp.body.bodyPosZ = fun.body.bodyPosZ(1,1,1,1);
% % 
% % temp.body.absbodyPosX = fun.body.absbodyPosX(1,1,1,1);
% % temp.body.absbodyPosY = fun.body.absbodyPosY(1,1,1,1);
% % temp.body.absbodyPosZ = fun.body.absbodyPosZ(1,1,1,1);

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
    Force = xlsread('Vettore_forza_R','Foglio3','A1:A1254');
    Resistance = xlsread('Vettore_forza_R','Foglio3','B1:B1254');
end

%% Picture Vectors Storage

% figure(1)

if ctrl.gif.saveasgif == 1
    temp.iter = 1;
end


figure(1)
movegui(figure(1),[30 70])
myicon = imread('arbotixcommander.jpg');
myicon2 = imread('ragno.jpg');
[myicon3,~] = imread('salita.png');
[myicon4,iconcmap] = imread('discesa.png');
gaitselectjoy = msgbox({'5 = TRIPOD';'6 = RIPPLE';'8 = AMBLE';'4 = target reached (STOP)'},'1. Select the gait type...','custom',myicon2);
f = msgbox({'Use LEFT analogue stick to:';'--> MOVE forward/backward';'--> TURN left/right';'Use POV buttons to:';'--> MOVE sideways'},'2. Wait for input from joystick...','custom',myicon);
movegui(gaitselectjoy,[10 600])
movegui(f,[300 600])

temp.h = 0;
temp.h2 = 0;
temp.h3 = 0;
temp.h4 = 0;

p = 2;
z(1) = 0;
k = 1;
tic;
while k ~= 100
    
    joystick = vrjoystick(1);
    state = true;
    while(state)
        if (button(joystick,5)==1)
            mov.GaitType(k) = {'TRIPOD'};
            state = false;
        elseif (button(joystick,6)==1)
            mov.GaitType(k) = {'RIPPLE'};
            state = false;
        elseif (button(joystick,8)==1)
            mov.GaitType(k) = {'AMBLE'};
            state = false;
        elseif (button(joystick,4)==1)
            k = 99;
            mov.GaitType(k) = {'TRIPOD'};
            state = false;
        end
    end
    

    temp.gaitData = gaitSelect(mov.GaitType(k));
    
    
    if k<99

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
    
    else
        mov.Xspeed(k) = 0;
        mov.Yspeed(k) = 0;
        mov.Rspeed(k) = 0;
    end
    


%     figure(1)
    if k<99
    for j = 1:temp.Nsteps
        hold off
        
        %---------------------------------------------------------------------------------------
        mov.Xspeed(k) = axis(joystick,2)*(-120)*multiplier(mov.GaitType(k));
        mov.Yspeed(k) = 0*multiplier(mov.GaitType(k));
        if (pov(joystick)==270)
            mov.Yspeed(k) = 50*multiplier(mov.GaitType(k));
        elseif (pov(joystick)==90)
            mov.Yspeed(k) = -50*multiplier(mov.GaitType(k));
        end
        if axis(joystick,2)<=0
            mov.Rspeed(k) = ...
                axis(joystick,1)*(-22.5)*(pi/180)*multiplier(mov.GaitType(k));
        else
            mov.Rspeed(k) = ...
                axis(joystick,1)*(22.5)*(pi/180)*multiplier(mov.GaitType(k));
        end
        mov.maxlift=55;
        mov.maxfall=150;
        %---------------------------------------------------------------------------------------
        
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
%         temp.body.bodyRotY = fun.body.bodyRotY(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.bodyRotZ = fun.body.bodyRotZ(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.bodyPosX = fun.body.bodyPosX(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.bodyPosY = fun.body.bodyPosY(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.bodyPosZ = fun.body.bodyPosZ(j,k,temp.Nsteps,vars.Nloops);
%         
%         temp.body.absbodyPosX = fun.body.absbodyPosX(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.absbodyPosY = fun.body.absbodyPosY(j,k,temp.Nsteps,vars.Nloops);
%         temp.body.absbodyPosZ = fun.body.absbodyPosZ(j,k,temp.Nsteps,vars.Nloops);
        
        run('Inverse_Kinematics')
        
        
        if ctrl.control == 1
            run('Slope_detection')
        end

        if ctrl.control == 1
            run('Robot_Controller')
            run('Force_calculation')
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
        
        p = p+1;
    end
        temp.k_total = k;
        if ctrl.control ==1
            run('Track_limits2')
        end
    end
    k = k+1;
    
end
time = toc;

if exist('gaitselectjoy', 'var')
    delete(gaitselectjoy);
    clear('gaitselectjoy');
end

if exist('f', 'var')  %chiude la finestra di dialogo
    delete(f);
    clear('f');
end

if exist('g', 'var')
    delete(g);
    clear('g');
end

if exist('h', 'var')
    delete(h);
    clear('h');
end