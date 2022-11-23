%% Main Script Caller

clear
close all
clc

clear s

pause(1)

%% Control Panel

ctrl.control = 0; % Set to 1 to control the robot while the simulation plays

ctrl.boolanimate = 1; % Set to 1 to get the robot animated
ctrl.boolplot = 0; % Set to 1 to plot the robot

ctrl.boolgait = 1; % Set to 1 to get gait (predefined) movement, choose this or the following, not together
ctrl.boolP = 0; % Set to 1 to get P-controlled movementh, choose this or the previous one, not together


ctrl.showfeet = 1; % Set to 1 to put markers on leg endpoints
ctrl.showterrain = 1; % Set to 1 to show terrain mesh
ctrl.showorigin = 1; % Set to 1 to always show [0,0] point

ctrl.viewType = 3; % 3 for 3D Animation, 2 for 2D Animation (Top View)

terrain.type = 'FLAT'; % Terrain to use, choose from FLAT RAMP STEPS SINUSOIDAL SINUSOIDAL_LINEAR
[~,~,~,terrain] = TerrainFun(0,0,terrain);
terrain.radius = 1000; %[mm] Terrain Half Side length

terrain.compensator = 1; % Select terrain compensator algorithm to use: 1 - Quadratic Reduced

% For Animations Only

ctrl.gif.saveasgif = 0; % Set to 1 to save the plot as a GIF
ctrl.gif.filename = 'test.gif';

ctrl.framebyframe = 0; % Set to 1 for frame by frame animation
ctrl.additionalpause = 0; % Number of seconds increase for each cycle in the animation
ctrl.nobounce = 1; % System to prevent animation from bouncing due to legs raising


%% Initializing

% run('Position_and_Movement')
run('Robot_Data')
run('Data_Initialization')

if ctrl.control == 1
    run('Communication_Setup')
end

%% Plotting the Robot

if ctrl.boolplot == 1
    
    temp.gait = GaitSetup;
    
    run('Inverse_Kinematics')
    run('Leg_Angles')
    run('Robot_Visualizator')
    
end

%% Animating the Robot

if ctrl.boolanimate == 1
    
    if ctrl.boolgait == 1
        run('Gait')
    end
    
    if ctrl.boolP == 1
       run('P_control') 
    end
end

if ctrl.control ==1
    run('Plot_forces')
    run('Plot_trajectory2')
    run('Time_and_steps')
end

%% Closing Port

if ctrl.control == 1
%     check
    clear s
end
