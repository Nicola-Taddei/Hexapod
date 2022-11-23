% Initialization of some data as matrices and coordinates

% check = 0;

%% Generating Transformation Matrices

for i = 1:6
    
    globalCS.(['M_globalleg' num2str(i)]) = [1 0 0 eval(['dim.posits.pos' num2str(i) '.x']) ;
                                             0 -1 0 eval(['dim.posits.pos' num2str(i) '.y']) ;
                                             0 0 -1 eval(['dim.endpoints.leg' num2str(i) '.z']) ;
                                             0 0 0 1];
    
    bodyCS.(['M_bodyleg' num2str(i)]) = [1 0 0 eval(['dim.posits.pos' num2str(i) '.x']) ;
                                         0 -1 0 eval(['dim.posits.pos' num2str(i) '.y']) ;
                                         0 0 -1 0 ;
                                         0 0 0 1];
    
end

globalCS.M_globalbody = [1 0 0 0 ;
                         0 1 0 0 ;
                         0 0 1 eval(['dim.endpoints.leg' num2str(i) '.z']) ;
                         0 0 0 1];

%% Generating Vectors

for i = 1:6
    
    temp.dummy = eval(['globalCS.M_globalleg' num2str(i)])*[eval(['dim.endpoints.leg' num2str(i) '.x']) ; eval(['dim.endpoints.leg' num2str(i) '.y']) ; eval(['dim.endpoints.leg' num2str(i) '.z']) ; 1];
    globalCS.endpoints.(['leg' num2str(i)]) = temp.dummy;
    
    temp.dummy = globalCS.M_globalbody*[eval(['dim.posits.pos' num2str(i) '.x']) ; eval(['dim.posits.pos' num2str(i) '.y']) ; eval(['dim.posits.pos' num2str(i) '.z']) ; 1];
    globalCS.posits.(['pos' num2str(i)]) = temp.dummy;
    
    temp.dummy = eval(['bodyCS.M_bodyleg' num2str(i)])*[eval(['dim.endpoints.leg' num2str(i) '.x']) ; eval(['dim.endpoints.leg' num2str(i) '.y']) ; eval(['dim.endpoints.leg' num2str(i) '.z']) ; 1];
    bodyCS.endpoints.(['leg' num2str(i)]) = temp.dummy;
    
    bodyCS.posits.(['pos' num2str(i)]) = [eval(['dim.posits.pos' num2str(i) '.x']) ; eval(['dim.posits.pos' num2str(i) '.y']) ; eval(['dim.posits.pos' num2str(i) '.z']) ; 1];
    
end

%% Generating initial values

% Indices

j = 1;
k = 1;

if ctrl.boolP == 1
    l = 1;
end

% Position matrix at instant zero

TMatr.gait1.M_Tr0 = [1 0 0 temp.body.globalBodyPosX ;
                      0 1 0 temp.body.globalBodyPosY ;
                      0 0 1 0 ;
                      0 0 0 1];

TMatr.gait1.M0 = [1 0 0 temp.body.globalBodyPosX ;
                      0 1 0 temp.body.globalBodyPosY ;
                      0 0 1 0 ;
                      0 0 0 1];

% Temporary values at instant zero

for i = 1:6
    
    temp.reqold.(['leg' num2str(i)]) = eval(['dim.endpoints.leg' num2str(i)]);
    
end

temp.gaitold = GaitSetup;

temp.firstiter = 0;

% Gait values

if ctrl.boolgait == 1
    vars.Nloops = length(mov.GaitType);
end

temp.gait = GaitSetup;

%% Creating auxiliary Positions for Plot

% Leg 1 (Left Front)

dim.posits.aux.pos1_1.x = 100;
dim.posits.aux.pos1_1.y = 20;
dim.posits.aux.pos1_1.z = 0;

dim.posits.aux.pos1_2.x = 80;
dim.posits.aux.pos1_2.y = 40;
dim.posits.aux.pos1_2.z = 0;

% Leg 2 (Right Front)

dim.posits.aux.pos2_1.x = 100;
dim.posits.aux.pos2_1.y = -20;
dim.posits.aux.pos2_1.z = 0;

dim.posits.aux.pos2_2.x = 80;
dim.posits.aux.pos2_2.y = -40;
dim.posits.aux.pos2_2.z = 0;

% Leg 3 (Left Middle)

dim.posits.aux.pos3_1.x = 20;
dim.posits.aux.pos3_1.y = 60;
dim.posits.aux.pos3_1.z = 0;

dim.posits.aux.pos3_2.x = -20;
dim.posits.aux.pos3_2.y = 60;
dim.posits.aux.pos3_2.z = 0;

% Leg 3 (Right Middle)

dim.posits.aux.pos4_1.x = 20;
dim.posits.aux.pos4_1.y = -60;
dim.posits.aux.pos4_1.z = 0;

dim.posits.aux.pos4_2.x = -20;
dim.posits.aux.pos4_2.y = -60;
dim.posits.aux.pos4_2.z = 0;

% Leg 5 (Left Rear)

dim.posits.aux.pos5_1.x = -80;
dim.posits.aux.pos5_1.y = 40;
dim.posits.aux.pos5_1.z = 0;

dim.posits.aux.pos5_2.x = -100;
dim.posits.aux.pos5_2.y = 20;
dim.posits.aux.pos5_2.z = 0;

% Leg 6 (Right Rear)

dim.posits.aux.pos6_1.x = -80;
dim.posits.aux.pos6_1.y = -40;
dim.posits.aux.pos6_1.z = 0;

dim.posits.aux.pos6_2.x = -100;
dim.posits.aux.pos6_2.y = -20;
dim.posits.aux.pos6_2.z = 0;

% Generating Vectors

for i = 1:6
    
    temp.dummy = globalCS.M_globalbody*[eval(['dim.posits.aux.pos' num2str(i) '_1.x']) ; eval(['dim.posits.aux.pos' num2str(i) '_1.y']) ; eval(['dim.posits.aux.pos' num2str(i) '_1.z']) ; 1];
    globalCS.posits.aux.(['pos' num2str(i) '_1']) = temp.dummy;
    
    temp.dummy = globalCS.M_globalbody*[eval(['dim.posits.aux.pos' num2str(i) '_2.x']) ; eval(['dim.posits.aux.pos' num2str(i) '_2.y']) ; eval(['dim.posits.aux.pos' num2str(i) '_2.z']) ; 1];
    globalCS.posits.aux.(['pos' num2str(i) '_2']) = temp.dummy;
    
end
