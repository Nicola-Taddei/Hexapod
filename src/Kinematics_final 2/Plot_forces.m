%This is for plotting the forces acting on the legs during the entire route
%performed by the robot

% force.leg1 = xlsread('forcedata.xlsx',1); %uncomment this to plot forces from the Excel file
% force.leg2 = xlsread('forcedata.xlsx',2);
% force.leg3 = xlsread('forcedata.xlsx',3);
% force.leg4 = xlsread('forcedata.xlsx',4);
% force.leg5 = xlsread('forcedata.xlsx',5);
% force.leg6 = xlsread('forcedata.xlsx',6);


for m=1:6
    force.mean.(['leg' num2str(m)]) = mean(force.(['leg' num2str(m)]));
end

for i=1:p
    force.x(i)=i;
%     force.ystair(i)=2;
%     force.yrear(i)=1;
    for m=1:6
        force.mean.(['legg' num2str(m)])(i) = force.mean.(['leg' num2str(m)]);
    end
end


xlswrite('forcedata.xlsx', force.leg1, 1); %save data to Excel file "forcedata"
xlswrite('forcedata.xlsx', force.leg2, 2);
xlswrite('forcedata.xlsx', force.leg3, 3);
xlswrite('forcedata.xlsx', force.leg4, 4);
xlswrite('forcedata.xlsx', force.leg5, 5);
xlswrite('forcedata.xlsx', force.leg6, 6);


%Plotting...
figure(2)
movegui(figure(2),[100 200])
subplot(3,2,1)
plot(force.leg1)
xlim([0 i])
hold on
plot(force.x,force.mean.legg1,'--','LineWidth',2)
ylabel('[N]')
title('Leg 1')
subplot(3,2,2)
plot(force.leg2)
xlim([0 i])
hold on
plot(force.x,force.mean.legg2,'--','LineWidth',2)
ylabel('[N]')
title('Leg 2')
subplot(3,2,3)
plot(force.leg3)
xlim([0 i])
hold on
plot(force.x,force.mean.legg3,'--','LineWidth',2)
ylabel('[N]')
title('Leg 3')
subplot(3,2,4)
plot(force.leg4)
xlim([0 i])
hold on
plot(force.x,force.mean.legg4,'--','LineWidth',2)
ylabel('[N]')
title('Leg 4')
subplot(3,2,5)
plot(force.leg5)
xlim([0 i])
hold on
plot(force.x,force.mean.legg5,'--','LineWidth',2)
ylabel('[N]')
title('Leg 5')
xlabel('Steps no.')
subplot(3,2,6)
plot(force.leg6)
xlim([0 i])
hold on
plot(force.x,force.mean.legg6,'--','LineWidth',2)
ylabel('[N]')
title('Leg 6')
xlabel('Steps no.')