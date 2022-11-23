% This is used to determine the angles that are necessary for the plot.
% Then we check that these angles do not exceed the servomotor limits.

%% Inverse Kinematics for Body and Legs

for i = 1:6
    
    temp.sol = legIK(eval(['temp.req.leg' num2str(i) '.x']),eval(['temp.req.leg' num2str(i) '.y']),eval(['temp.req.leg' num2str(i) '.z']),dim.lc,dim.lf,dim.lt);
    
    temp.sol.coxa = -temp.sol.coxa; % Coxa angle needs to be converted into body CS
    
    temp.angles.(['theta' num2str(i)]) = temp.sol.coxa - dim.posits.(['pos' num2str(i)]).epsilon;
    temp.angles.(['phi' num2str(i)]) = -(temp.sol.femur - pi/2);
    temp.angles.(['psi' num2str(i)]) = pi - temp.sol.tibia;
    
end

%% Servo values to check if it's feasible

servo=[];
servo(1) = rad2servo(temp.angles.theta1);
servo(2) = rad2servo(temp.angles.phi1);
servo(3) = rad2servo(temp.angles.psi1)-150;

servo(4) = rad2servo(temp.angles.theta1);
servo(5) = rad2servo(-temp.angles.phi1);
servo(6) = 1023-(rad2servo(temp.angles.psi1)-150);

servo(7) = rad2servo(temp.angles.theta1);
servo(8) = rad2servo(temp.angles.phi1);
servo(9) = rad2servo(temp.angles.psi1)-150;

servo(10) = rad2servo(temp.angles.theta1);
servo(11) = rad2servo(-temp.angles.phi1);
servo(12) = 1023-(rad2servo(temp.angles.psi1)-150);

servo(13) = rad2servo(temp.angles.theta1);
servo(14) = rad2servo(temp.angles.phi1);
servo(15) = rad2servo(temp.angles.psi1)-150;

servo(16) = rad2servo(temp.angles.theta1);
servo(17) = rad2servo(-temp.angles.phi1);
servo(18) = 1023-(rad2servo(temp.angles.psi1)-150);

servomins = [226, 159, 200, 226, 159, 40, 226, 159, 200, 226, 159, 40, 226, 159, 200, 226, 159, 40];
servomaxs = [790, 859, 980, 790, 859, 810, 790, 859, 980, 790, 859, 810, 790, 859, 980, 790, 859, 810];

for i = 1:6
    if(servo(i) < servomins(i) || servo(i) > servomaxs(i))
        fprintf('out of servo limits \n');
    end
end