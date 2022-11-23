% Used when we want to control the real robot

%% Sending data

std_h = 117; 
% this is the standard height around we rescale the z when we send it. If
% you want to make the robot walk taller or shorter you need to change the
% height in the Robot_Data and not here. You need to change this only if
% you change it also in the arbotix code. This coordinate needs to be
% the same both on matlab and arbotix code

v(1) = 255; % initial packet that means 0xff

v(2) = round(temp.req.leg1.x)-dim.endpoints.leg1.x+128;
v(3) = round(temp.req.leg1.y)-dim.endpoints.leg1.y+128;
v(4) = round(temp.req.leg1.z)-std_h+128;

v(5) = round(temp.req.leg2.x)-dim.endpoints.leg2.x+128;
v(6) = round(temp.req.leg2.y)-dim.endpoints.leg2.y+128;
v(7) = round(temp.req.leg2.z)-std_h+128;

v(8) = round(temp.req.leg3.x)-dim.endpoints.leg3.x+128;
v(9) = round(temp.req.leg3.y)-dim.endpoints.leg3.y+128;
v(10) = round(temp.req.leg3.z)-std_h+128;

v(11) = round(temp.req.leg4.x)-dim.endpoints.leg4.x+128;
v(12) = round(temp.req.leg4.y)-dim.endpoints.leg4.y+128;
v(13) = round(temp.req.leg4.z)-std_h+128;

v(14) = round(temp.req.leg5.x)-dim.endpoints.leg5.x+128;
v(15) = round(temp.req.leg5.y)-dim.endpoints.leg5.y+128;
v(16) = round(temp.req.leg5.z)-std_h+128;

v(17) = round(temp.req.leg6.x)-dim.endpoints.leg6.x+128;
v(18) = round(temp.req.leg6.y)-dim.endpoints.leg6.y+128;
v(19) = round(temp.req.leg6.z)-std_h+128;

v(20) = temp.gaitData.tranTime/4;

v(21) = temp.isleglowering(1); % this is necessary to the tactile feedback
v(22) = temp.isleglowering(2);
v(23) = temp.isleglowering(3);
v(24) = temp.isleglowering(4);
v(25) = temp.isleglowering(5);
v(26) = temp.isleglowering(6);

% v(1) = 255;
% 
% v(2) = StdPosition(1)-dim.endpoints.leg1.x+128;
% v(3) = StdPosition(2)-dim.endpoints.leg1.y+128;
% v(4) = StdPosition(3)-std_h+128;
% 
% v(5) = StdPosition(4)-dim.endpoints.leg2.x+128;
% v(6) = StdPosition(5)-dim.endpoints.leg2.y+128;
% v(7) = StdPosition(6)-std_h+128;
% 
% v(8) = StdPosition(7)-dim.endpoints.leg3.x+128;
% v(9) = StdPosition(8)-dim.endpoints.leg3.y+128;
% v(10) = StdPosition(9)-std_h+128;
% 
% v(11) = StdPosition(10)-dim.endpoints.leg4.x+128;
% v(12) = StdPosition(11)-dim.endpoints.leg4.y+128;
% v(13) = StdPosition(12)-std_h+128;
% 
% v(14) = StdPosition(13)-dim.endpoints.leg5.x+128;
% v(15) = StdPosition(14)-dim.endpoints.leg5.y+128;
% v(16) = StdPosition(15)-std_h+128;
% 
% v(17) = StdPosition(16)-dim.endpoints.leg6.x+128;
% v(18) = StdPosition(17)-dim.endpoints.leg6.y+128;
% v(19) = StdPosition(18)-std_h+128;
% 
% v(20) = 200;
% 
% v(21) = 0;
% v(22) = 0;
% v(23) = 0;
% v(24) = 0;
% v(25) = 0;
% v(26) = 0;

% for h = 27:s.UserData.NumBytes-1 % for additional packets
%     v(h) = h;
% end

v(s.UserData.NumBytestoArb) = 255-mod(sum(v(2:s.UserData.NumBytestoArb-1)),256); % this is the checksum

write(s,v,"uint8");

% SentData(:,(k-1)*temp.gaitData.stepsInCycle+j) = v(2:s.UserData.NumBytes-1);

%% Waiting for response

waiting = 1;
s.UserData.Ok = 0;

while waiting == 1
    pause(0.001)
    if s.UserData.Ok == 255 %se ricevo l'ok dall'arduino allora agisco, altrimenti il while continua ad andare senza fare niente
        waiting = 0;
%         check = check + (mod(sum(s.UserData.ReturnedData),256)~=255);
        s.UserData.Ok = 0;
    elseif s.UserData.Ok == 254
        write(s,v,"uint8");
        fprintf('communication error \n');
        s.UserData.Ok = 0;
    elseif s.UserData.Ok == 253
        write(s,v,"uint8");
        fprintf('checksum error \n');
        s.UserData.Ok = 0;
    end
end

%% Saving the returned data

ReturnedData(1,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(1)+dim.endpoints.leg1.x-128;
ReturnedData(2,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(2)+dim.endpoints.leg1.y-128;
ReturnedData(3,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(3)+std_h-128;

ReturnedData(4,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(4)+dim.endpoints.leg2.x-128;
ReturnedData(5,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(5)+dim.endpoints.leg2.y-128;
ReturnedData(6,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(6)+std_h-128;

ReturnedData(7,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(7)+dim.endpoints.leg3.x-128;
ReturnedData(8,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(8)+dim.endpoints.leg3.y-128;
ReturnedData(9,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(9)+std_h-128;

ReturnedData(10,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(10)+dim.endpoints.leg4.x-128;
ReturnedData(11,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(11)+dim.endpoints.leg4.y-128;
ReturnedData(12,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(12)+std_h-128;

ReturnedData(13,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(13)+dim.endpoints.leg5.x-128;
ReturnedData(14,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(14)+dim.endpoints.leg5.y-128;
ReturnedData(15,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(15)+std_h-128;

ReturnedData(16,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(16)+dim.endpoints.leg6.x-128;
ReturnedData(17,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(17)+dim.endpoints.leg6.y-128;
ReturnedData(18,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(18)+std_h-128;

ReturnedData(19,(k-1)*temp.gaitData.stepsInCycle+j) = s.UserData.ReturnedData(19)/10;

ReturnedData(20,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(20)+s.UserData.ReturnedData(21)/100)*10;
ReturnedData(21,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(22)+s.UserData.ReturnedData(23)/100)*10-180;
ReturnedData(22,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(24)+s.UserData.ReturnedData(25)/100)*10-180;

ReturnedData(23,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(26)*4);
ReturnedData(24,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(27)*4);
ReturnedData(25,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(28)*4);
ReturnedData(26,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(29)*4);
ReturnedData(27,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(30)*4);
ReturnedData(28,(k-1)*temp.gaitData.stepsInCycle+j) = (s.UserData.ReturnedData(31)*4);

%% Substitution of the endpoints with the ones given by the servos

for m = 1:6
    temp.req.(['leg' num2str(m)]).x = s.UserData.ReturnedData((m-1)*3+1)+dim.endpoints.(['leg' num2str(m)]).x-128;
    temp.req.(['leg' num2str(m)]).y = s.UserData.ReturnedData((m-1)*3+2)+dim.endpoints.(['leg' num2str(m)]).y-128;
    temp.req.(['leg' num2str(m)]).z = s.UserData.ReturnedData((m-1)*3+3)+std_h-128;
end

%% Substitution of the angles of the body with the ones given by the IMU

yaw = ReturnedData(20,(k-1)*temp.gaitData.stepsInCycle+j)*pi/180;
pitch = ReturnedData(21,(k-1)*temp.gaitData.stepsInCycle+j)*pi/180;
roll = ReturnedData(22,(k-1)*temp.gaitData.stepsInCycle+j)*pi/180;

rotz = [cos(yaw) -sin(yaw) 0;
        sin(yaw) cos(yaw) 0;
        0 0 1];
roty = [cos(pitch) 0 sin(pitch);
        0 1 0;
        -sin(pitch) 0 cos(pitch)];
rotx = [1 0 0;
        0 cos(roll) -sin(roll);
        0 sin(roll) cos(roll)];
rot = rotz*roty*rotx;

A = TMatr.(['gait' num2str(k)]).(['M' num2str(j)])*globalCS.M_globalbody;
A(1:3,1:3) = rot;
TMatr.(['gait' num2str(k)]).(['M' num2str(j)]) = A/globalCS.M_globalbody;


%% New lectures from FSR

for m = 1:6
    temp.fsr.(['leg' num2str(m)]) = s.UserData.ReturnedData(25+m)*4;
end

% sommafsr(p) = temp.fsr.leg1+temp.fsr.leg2+temp.fsr.leg3+temp.fsr.leg4+temp.fsr.leg5+temp.fsr.leg6;