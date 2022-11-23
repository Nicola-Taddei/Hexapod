% Here we define the desired motion and body pose of the robot in the whole
% animation and in the real world

%% Define Initial Position of the Robot

temp.body.globalBodyPosX = 0;
temp.body.globalBodyPosY = 0;
temp.robotRotationZ = 0;

%% FOR PLOTTING # Define Orientation of the Robot Body

if ctrl.boolplot == 1
    
    temp.body.bodyRotX = 0;
    temp.body.bodyRotY = 0;
    temp.body.bodyRotZ = 0;
    temp.body.bodyPosX = 0;
    temp.body.bodyPosY = 0;
    temp.body.bodyPosZ = 0;
    
    temp.body.absbodyPosX = 0;
    temp.body.absbodyPosY = 0;
    temp.body.absbodyPosZ = 0;
    
end

%% FOR ANIMATING # Define Movement of the Robot

if ctrl.boolgait == 1
    
    a = 'TRIPOD'; % Choose from AMBLE RIPPLE TRIPOD NONE
    b = 'AMBLE';
    w = 120;%33 per scale, 40 per rampe e circuito completo, 120 il massimo
    h = 0;
    r = pi/8;
    
%     mov.GaitType = {a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a};
%     mov.Xspeed =   [w w w w w w w w w w w w w w w w w w w w w 0 0 0 0 w w w w w w w w w w w w 0 0 0 0 w w w w w w w w w w w w w w w w w w w].*multiplier(mov.GaitType);
%     mov.Yspeed =   [h h h h h h h h h h h h h h h h h h h h h 0 0 0 0 h h h h h h h h h h h h 0 0 0 0 h h h h h h h h h h h h h h h h h h h].*multiplier(mov.GaitType);
%     mov.Rspeed =   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 r r r r 0 0 0 0 0 0 0 0 0 0 0 0 r r r r 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0].*multiplier(mov.GaitType);

%     mov.GaitType = {a a a a a a a a a a a a a a a a a a a a a a a a a};
%     mov.Xspeed =   [w w w w w w w w w w w w w w w w w w w w w 0 0 0 0].*multiplier(mov.GaitType);
%     mov.Yspeed =   [h h h h h h h h h h h h h h h h h h h h h 0 0 0 0].*multiplier(mov.GaitType);
%     mov.Rspeed =   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 r r r r].*multiplier(mov.GaitType);
    
    mov.GaitType = {a a a a a a a a a};
    mov.Xspeed =   [w w w w w w w w w].*multiplier(mov.GaitType);
    mov.Yspeed =   [h h h h h h h h h].*multiplier(mov.GaitType);
    mov.Rspeed =   [0 0 0 0 0 0 0 0 0].*multiplier(mov.GaitType);

%     mov.GaitType = {a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a};
%     mov.Xspeed =   [w w w w w w w w w w w w w w w w w w w w w 0 0 0 0 0 0 0 0 w w w w w w w w w w w w w w w w w w w].*multiplier(mov.GaitType);
%     mov.Yspeed =   [h h h h h h h h h h h h h h h h h h h h h 0 0 0 0 0 0 0 0 h h h h h h h h h h h h h h h h h h h].*multiplier(mov.GaitType);
%     mov.Rspeed =   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 r r r r r r r r 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0].*multiplier(mov.GaitType);

%     mov.GaitType = {'NONE' 'NONE' 'NONE' 'NONE'};
%     mov.Xspeed = [0 0 0 0].*multiplier(mov.GaitType);
%     mov.Yspeed = [0 0 0 0].*multiplier(mov.GaitType);
%     mov.Rspeed = [0 0 0 0].*multiplier(mov.GaitType);

    fun.body.bodyRotX = @(j,k,Nsteps,Nloops) 0*pi/10*sin(j/Nsteps*2*pi);
    fun.body.bodyRotY = @(j,k,Nsteps,Nloops) 0*pi/10*cos(j/Nsteps*2*pi);
    fun.body.bodyRotZ = @(j,k,Nsteps,Nloops) 0*pi/10*sin(j/Nsteps*2*pi);
    fun.body.bodyPosX = @(j,k,Nsteps,Nloops) 0*40*cos(j/Nsteps*2*pi);
    fun.body.bodyPosY = @(j,k,Nsteps,Nloops) 0*60*sin(j/Nsteps*2*pi);
    fun.body.bodyPosZ = @(j,k,Nsteps,Nloops) 0*(60*cos(j/Nsteps*2*pi));
    
    fun.body.absbodyPosX = @(j,k,Nsteps,Nloops) 0*40*cos(j/Nsteps*2*pi);
    fun.body.absbodyPosY = @(j,k,Nsteps,Nloops) 0*40*sin(j/Nsteps*2*pi);
    fun.body.absbodyPosZ = @(j,k,Nsteps,Nloops) 0*40*sin(j/Nsteps*2*pi);
    
end

if ctrl.boolP == 1
    
    mov.GaitType = {'TRIPOD'}; % Choose from RIPPLE  AMBLE  TRIPOD
    
    % # REFERENCE CASE 1
    
        fun.ref.x = @(k,l) 0*(l == 1) + 1000*cos(deg2rad(90-72))*(l == 4) + 1000*cos(deg2rad(90-144))*(l == 2) + 1000*cos(deg2rad(90+144))*(l == 5) + 1000*cos(deg2rad(90+72))*(l == 3) + 0*(l == 6);
        fun.ref.y = @(k,l) 1000*(l == 1) + 1000*sin(deg2rad(90-72))*(l == 4) + 1000*sin(deg2rad(90-144))*(l == 2) + 1000*sin(deg2rad(90+144))*(l == 5) + 1000*sin(deg2rad(90+72))*(l == 3) + 1000*(l == 6);
        ref.lmax = 6;
        ref.kmax = inf;
    
    % # REFERENCE CASE 2
    
%     fun.ref.x = @(k,l) 1000*cos(2*pi/50*k);
%     fun.ref.y = @(k,l) 1000*sin(2*pi/50*k);
%     ref.lmax = inf;
%     ref.kmax = 50;

    fun.body.bodyRotX = @(j,k,Nsteps) 0*pi/6*sin(j/Nsteps*2*pi);
    fun.body.bodyRotY = @(j,k,Nsteps) 0*pi/6*sin(j/Nsteps*2*pi);
    fun.body.bodyRotZ = @(j,k,Nsteps) 0*pi/6*sin(j/Nsteps*2*pi);
    fun.body.bodyPosX = @(j,k,Nsteps) 0*40*cos(j/Nsteps*2*pi);
    fun.body.bodyPosY = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
    fun.body.bodyPosZ = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
    
    fun.body.absbodyPosX = @(j,k,Nsteps) 0*40*cos(j/Nsteps*2*pi);
    fun.body.absbodyPosY = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
    fun.body.absbodyPosZ = @(j,k,Nsteps) 0*40*sin(j/Nsteps*2*pi);
    
end

mov.maxlift=55;
mov.maxfall=150;
