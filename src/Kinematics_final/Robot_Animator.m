% For the animation

for i = 1:6
    plot3(data.(['gait' num2str(k)]).(['v' num2str(j)]).(['coxa' num2str(i)]).x,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['coxa' num2str(i)]).y,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['coxa' num2str(i)]).z,'b')
    hold on
    plot3(data.(['gait' num2str(k)]).(['v' num2str(j)]).(['femur' num2str(i)]).x,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['femur' num2str(i)]).y,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['femur' num2str(i)]).z,'g')
    plot3(data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).x,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).y,data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).z,'r')
    patch(data.(['gait' num2str(k)]).(['v' num2str(j)]).contour.x,data.(['gait' num2str(k)]).(['v' num2str(j)]).contour.y,data.(['gait' num2str(k)]).(['v' num2str(j)]).contour.z,'c')
    
    if ctrl.showfeet == 1
        plot3(data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).x(2),data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).y(2),data.(['gait' num2str(k)]).(['v' num2str(j)]).(['tibia' num2str(i)]).z(2),'mo')
    end
end
        
if ctrl.showterrain == 1
    TerrainGenerator(terrain)
end

if ctrl.showorigin == 1
    plot3(0,0,TerrainFun(0,0,terrain),'or')
end

if ctrl.boolP == 1
    plot3(ref.x,ref.y,ref.z,'g*')
    plot3(data.bodypos.x,data.bodypos.y,data.bodypos.z,'k--')
end

if ctrl.nobounce == 1
    plot3(0,0,300)
end

axis equal
view(ctrl.viewType)

drawnow

if ctrl.framebyframe == 0
    pause(ctrl.additionalpause/temp.Nsteps)
else
    disp('Press Enter to Continue')
    pause
end

if ctrl.gif.saveasgif == 1
    savegif(figure(1),ctrl.gif.filename,temp.iter)
    temp.iter = temp.iter + 1;
end
