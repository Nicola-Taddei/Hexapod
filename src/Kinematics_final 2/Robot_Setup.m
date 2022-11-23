% Used to place the robot in the initial position at the start of each run

% check=0;

std_h = 117;

StdPosition = [52 -118 117 52 118 117 0 -129 117 0 129 117 -52 -118 117 -52 118 117];

v(1) = 255;

v(2) = StdPosition(1)-dim.endpoints.leg1.x+128;
v(3) = StdPosition(2)-dim.endpoints.leg1.y+128;
v(4) = StdPosition(3)-std_h+128;

v(5) = StdPosition(4)-dim.endpoints.leg2.x+128;
v(6) = StdPosition(5)-dim.endpoints.leg2.y+128;
v(7) = StdPosition(6)-std_h+128;

v(8) = StdPosition(7)-dim.endpoints.leg3.x+128;
v(9) = StdPosition(8)-dim.endpoints.leg3.y+128;
v(10) = StdPosition(9)-std_h+128;

v(11) = StdPosition(10)-dim.endpoints.leg4.x+128;
v(12) = StdPosition(11)-dim.endpoints.leg4.y+128;
v(13) = StdPosition(12)-std_h+128;

v(14) = StdPosition(13)-dim.endpoints.leg5.x+128;
v(15) = StdPosition(14)-dim.endpoints.leg5.y+128;
v(16) = StdPosition(15)-std_h+128;

v(17) = StdPosition(16)-dim.endpoints.leg6.x+128;
v(18) = StdPosition(17)-dim.endpoints.leg6.y+128;
v(19) = StdPosition(18)-std_h+128;

v(20) = 200;

v(21) = 0;
v(22) = 0;
v(23) = 0;
v(24) = 0;
v(25) = 0;
v(26) = 0;


% for h = 21:s.UserData.NumBytes-1
%     v(h) = h;
% end

v(s.UserData.NumBytestoArb) = 255-mod(sum(v(2:s.UserData.NumBytestoArb-1)),256);

write(s,v,"uint8");


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

