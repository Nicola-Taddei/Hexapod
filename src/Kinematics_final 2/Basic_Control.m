% This can be used directly to impose the endpoints to the robot without
% all the other codes. Useful for debugging

%% Initialization

clear all
close all
clc


s = serialport("COM3",38400)
flush(s); %viene sempre fatto all'inizio quindi l'ho messo anch'io


s.UserData = struct("NumBytes",1,"ReturnedData",[],"Ok",1) %inizializzo le variabili che riceverò dall'arduino

s.UserData.NumBytes = 27;

configureCallback(s,"byte",s.UserData.NumBytes,@readSerialData) %ogni volta che N byte sono disponibili si attiva la funzione readserialdata

pause (4) %giusto per dare il tempo che la serial port sia aperta

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

%% Trantime

tranTime = 500;

%% Sending data

std_h = 117; 
% this is the standard height around we rescale the z when we send it. If
% you want to make the robot walk taller or shorter you need to change the
% height in the Robot_Data and not here. You need to change this only if
% you change it also in the arbotix code. This coordinate needs to be
% the same both on matlab and arbotix code

x = [52 52 0 0 -52 -52];
y = [-118 118 -129 129 -118 118];
z = [117 117 117 117 117 117];

v(1) = 255;

v(2) = x(1)-dim.endpoints.leg1.x+128;
v(3) = y(1)-dim.endpoints.leg1.y+128;
v(4) = z(1)-std_h+128;

v(5) = x(2)-dim.endpoints.leg2.x+128;
v(6) = y(2)-dim.endpoints.leg2.y+128;
v(7) = z(2)-std_h+128;

v(8) = x(3)-dim.endpoints.leg3.x+128;
v(9) = y(3)-dim.endpoints.leg3.y+128;
v(10) = z(3)-std_h+128;

v(11) = x(4)-dim.endpoints.leg4.x+128;
v(12) = y(4)-dim.endpoints.leg4.y+128;
v(13) = z(4)-std_h+128;

v(14) = x(5)-dim.endpoints.leg5.x+128;
v(15) = y(5)-dim.endpoints.leg5.y+128;
v(16) = z(5)-std_h+128;

v(17) = x(6)-dim.endpoints.leg6.x+128;
v(18) = y(6)-dim.endpoints.leg6.y+128;
v(19) = z(6)-std_h+128;

v(20) = tranTime/4;

v(21) = 0;
v(22) = 0;
v(23) = 0;
v(24) = 0;
v(25) = 0;
v(26) = 0;

% for h = 27:s.UserData.NumBytes-1
%     v(h) = h;
% end

v(s.UserData.NumBytes) = 255-mod(sum(v(2:s.UserData.NumBytes-1)),256);

write(s,v,"uint8");

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


