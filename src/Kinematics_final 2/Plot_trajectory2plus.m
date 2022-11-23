%This code is for plotting the trajectory followed by the robot in case the
%hexapod will stop for communication error in the frst attempt. The hexapod
%can be restarted directly in the position in which it is blocked and
%resume the "game". This code add to the second attempt the trajectory
%followed in the first

Traj.x = xlsread('trajectorydata');
Traj.y = xlsread('trajectorydatay');
ks = length(Traj.x);

figure(3)
movegui(figure(3),[700 200])
for k = (ks+1):(ks+temp.k_total)
    Traj.x(k) = -TMatr.(['gait' num2str(k-ks)]).M4(2,4)+Traj.x(ks);
    Traj.y(k) = TMatr.(['gait' num2str(k-ks)]).M4(1,4)+Traj.y(ks);
end


plot(Traj.x,Traj.y)
hold on
title('Trajectory followed by the robot')


points.x1(1) = -490;  %-1800 col muso perperndicolare al perimetro
points.x1(2) = 1850;    %400 ""
points.y1(1) = 360;
points.y1(2) = 360;
plot(points.x1,points.y1,'k')

points.y2(1) = 2130;
points.y2(2) = 2130;
plot(points.x1,points.y2,'k')

points.x3(1) = 680;   %-680
points.x3(2) = 680;
y3(1) = points.y1(1);
y3(2) = points.y2(2);
plot(points.x3,y3,'k')

points.y4(1) = 2830;
points.y4(2) = 2830;
plot(points.x1,points.y4,'k')

points.x5(1) = points.x1(2);
points.x5(2) = points.x3(1);
points.y5(1) = 3710;
points.y5(2) = 3710;
plot(points.x5,points.y5,'k')

points.y6(1) = 4700;
points.y6(2) = 4700;
plot(points.x1,points.y6,'k')   %solo contorno

points.y7(1) = -300;
points.y7(2) = -300;
plot(points.x1,points.y7,'k')   %solo contorno

points.x8(1) = points.x1(2);
points.x8(2) = points.x1(2);
points.y8(1) = points.y7(1);
points.y8(2) = points.y6(1);
plot(points.x8,points.y8,'k')  %solo contorno

points.x9(1) = points.x1(1);
points.x9(2) = points.x1(1);
plot(points.x9,points.y8,'k')  %solo contorno

points.y10(1) = points.y5(1);
points.y10(2) = points.y4(1);
plot(points.x3,points.y10,'k')

plot(1250,4300,'g*')