%This code is for plotting the trajectory followed by the robot in the
%testing area, starting from the std position

figure(3)
movegui(figure(3),[700 200])
for k = 1:temp.k_total
    Traj.x(k) = -TMatr.(['gait' num2str(k)]).M4(2,4);
    Traj.y(k) = TMatr.(['gait' num2str(k)]).M4(1,4);
%     plot(-TMatr.(['gait' num2str(k)]).M4(2,4),TMatr.(['gait' num2str(k)]).M4(1,4),'bh-','MarkerSize',20);
%     hold on
end
plot(Traj.x,Traj.y)
hold on
title('Trajectory followed by the robot')


points.x1(1) = -1850;  %-1800 col muso perperndicolare al perimetro
points.x1(2) = 490;    %400 ""
points.y1(1) = 360;
points.y1(2) = 360;
plot(points.x1,points.y1,'k')

points.y2(1) = 2130;
points.y2(2) = 2130;
plot(points.x1,points.y2,'k')

points.x3(1) = -680;   %-680
points.x3(2) = -680;
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

%plot(-1400,2480,'g*')  %plot del punto di arrivo