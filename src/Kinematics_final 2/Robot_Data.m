% Some important data of the robot that are initialized

%% Defining Dimensions

dim.lc = 55; %[mm]
dim.lf = 66; %[mm]
dim.lt = 130; %[mm]

dim.body.x = 240; %[mm]
dim.body.y = 120; %[mm]
dim.body.h = 200; %[mm]

%% Body Height from the Ground

dim.height = 117; %[mm] % change this to change the height of the robot

%% Legs' Joints Positions in Body Coordinate System

% Leg 1 (Left Front)

dim.posits.pos1.x = dim.body.x/2;
dim.posits.pos1.y = dim.body.y/2;
dim.posits.pos1.z = 0;
dim.posits.pos1.epsilon = pi/4; %[rad]

% Leg 2 (Right Front)

dim.posits.pos2.x = dim.body.x/2;
dim.posits.pos2.y = -dim.body.y/2;
dim.posits.pos2.z = 0;
dim.posits.pos2.epsilon = -pi/4; %[rad]

% Leg 3 (Left Middle)

dim.posits.pos3.x = 0;
dim.posits.pos3.y = dim.body.h/2;
dim.posits.pos3.z = 0;
dim.posits.pos3.epsilon = pi/2; %[rad]

% Leg 4 (Right Middle)

dim.posits.pos4.x = 0;
dim.posits.pos4.y = -dim.body.h/2;
dim.posits.pos4.z = 0;
dim.posits.pos4.epsilon = -pi/2; %[rad]

% Leg 5 (Left Rear)

dim.posits.pos5.x = -dim.body.x/2;
dim.posits.pos5.y = dim.body.y/2;
dim.posits.pos5.z = 0;
dim.posits.pos5.epsilon = pi/2 + pi/4; %[rad]

% Leg 6 (Right Rear)

dim.posits.pos6.x = -dim.body.x/2;
dim.posits.pos6.y = -dim.body.y/2;
dim.posits.pos6.z = 0;
dim.posits.pos6.epsilon = -pi/2 - pi/4; %[rad]

%% Leg dim.endpoints

% Leg 1 (Left Front)

dim.stdx = 1*52;
dim.stdy = 1*118;
dim.stdym = 129;

dim.endpoints.leg1.x = dim.stdx; %[mm]
dim.endpoints.leg1.y = -dim.stdy; %[mm]
dim.endpoints.leg1.z = dim.height; %[mm]

% Leg 2 (Right Front)

dim.endpoints.leg2.x = dim.stdx; %[mm]
dim.endpoints.leg2.y = dim.stdy; %[mm]
dim.endpoints.leg2.z = dim.height; %[mm]

% Leg 3 (Left Middle)

dim.endpoints.leg3.x = 0; %[mm]
dim.endpoints.leg3.y = -dim.stdym; %[mm]
dim.endpoints.leg3.z = dim.height; %[mm]

% Leg 4 (Right Middle)

dim.endpoints.leg4.x = 0; %[mm]
dim.endpoints.leg4.y = dim.stdym; %[mm]
dim.endpoints.leg4.z = dim.height; %[mm]

% Leg 5 (Left Rear)

dim.endpoints.leg5.x = -dim.stdx; %[mm]
dim.endpoints.leg5.y = -dim.stdy; %[mm]
dim.endpoints.leg5.z = dim.height; %[mm]

% Leg 6 (Right Rear)

dim.endpoints.leg6.x = -dim.stdx; %[mm]
dim.endpoints.leg6.y = dim.stdy; %[mm]
dim.endpoints.leg6.z = dim.height; %[mm]
