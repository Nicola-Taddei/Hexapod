% Robot Visualizator

%% Leg Definitions

for i = 1:6
    
    temp.Tvecs.(['Tv' num2str(i)]) = Leg_Position(eval(['temp.angles.theta' num2str(i)]),eval(['temp.angles.phi' num2str(i)]),eval(['temp.angles.psi' num2str(i)]),dim,eval(['dim.posits.pos' num2str(i)]));
    
    temp.Tvecs.(['Tv' num2str(i)]).coxa = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*globalCS.M_globalbody*temp.Tvecs.(['Tv' num2str(i)]).coxa;
    temp.Tvecs.(['Tv' num2str(i)]).femur = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*globalCS.M_globalbody*temp.Tvecs.(['Tv' num2str(i)]).femur;
    temp.Tvecs.(['Tv' num2str(i)]).tibia = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*globalCS.M_globalbody*temp.Tvecs.(['Tv' num2str(i)]).tibia;
    
end

%% Creating the Picture Vectors

for i = 1:6
    
    % Creating Joint Positions to Leg CS
    
    temp.dummy = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*eval(['globalCS.posits.pos' num2str(i)]);
    
    temp.jpos.x(i) = temp.dummy(1);
    temp.jpos.y(i) = temp.dummy(2);
    temp.jpos.z(i) = temp.dummy(3);
    
    temp.dummy = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*eval(['globalCS.posits.aux.pos' num2str(i) '_1']);
    
    temp.auxjpos1.x(i) = temp.dummy(1);
    temp.auxjpos1.y(i) = temp.dummy(2);
    temp.auxjpos1.z(i) = temp.dummy(3);
    
    temp.dummy = eval(['TMatr.gait' num2str(k) '.M' num2str(j)])*eval(['globalCS.posits.aux.pos' num2str(i) '_2']);
    
    temp.auxjpos2.x(i) = temp.dummy(1);
    temp.auxjpos2.y(i) = temp.dummy(2);
    temp.auxjpos2.z(i) = temp.dummy(3);
    
    % Creating Coxa Vectors
    
    temp.v.(['coxa' num2str(i)]).x = [temp.jpos.x(i) eval(['temp.Tvecs.Tv' num2str(i) '.coxa(1)'])];
    temp.v.(['coxa' num2str(i)]).y = [temp.jpos.y(i) eval(['temp.Tvecs.Tv' num2str(i) '.coxa(2)'])];
    temp.v.(['coxa' num2str(i)]).z = [temp.jpos.z(i) eval(['temp.Tvecs.Tv' num2str(i) '.coxa(3)'])];
    
    % Creating femur Vectors
    
    temp.v.(['femur' num2str(i)]).x = [eval(['temp.Tvecs.Tv' num2str(i) '.coxa(1)']) eval(['temp.Tvecs.Tv' num2str(i) '.femur(1)'])];
    temp.v.(['femur' num2str(i)]).y = [eval(['temp.Tvecs.Tv' num2str(i) '.coxa(2)']) eval(['temp.Tvecs.Tv' num2str(i) '.femur(2)'])];
    temp.v.(['femur' num2str(i)]).z = [eval(['temp.Tvecs.Tv' num2str(i) '.coxa(3)']) eval(['temp.Tvecs.Tv' num2str(i) '.femur(3)'])];
    
    % Creating Tibia Vectors
    
    temp.v.(['tibia' num2str(i)]).x = [eval(['temp.Tvecs.Tv' num2str(i) '.femur(1)']) eval(['temp.Tvecs.Tv' num2str(i) '.tibia(1)'])];
    temp.v.(['tibia' num2str(i)]).y = [eval(['temp.Tvecs.Tv' num2str(i) '.femur(2)']) eval(['temp.Tvecs.Tv' num2str(i) '.tibia(2)'])];
    temp.v.(['tibia' num2str(i)]).z = [eval(['temp.Tvecs.Tv' num2str(i) '.femur(3)']) eval(['temp.Tvecs.Tv' num2str(i) '.tibia(3)'])];
    
end

% temp.v.contour.x = [temp.jpos.x(1) temp.jpos.x(2) temp.jpos.x(4) temp.jpos.x(6) temp.jpos.x(5) temp.jpos.x(3) temp.jpos.x(1)];
% temp.v.contour.y = [temp.jpos.y(1) temp.jpos.y(2) temp.jpos.y(4) temp.jpos.y(6) temp.jpos.y(5) temp.jpos.y(3) temp.jpos.y(1)];
% temp.v.contour.z = [temp.jpos.z(1) temp.jpos.z(2) temp.jpos.z(4) temp.jpos.z(6) temp.jpos.z(5) temp.jpos.z(3) temp.jpos.z(1)];

temp.v.contour.x = [temp.jpos.x(1) temp.auxjpos1.x(1) temp.auxjpos1.x(2) temp.jpos.x(2) temp.auxjpos2.x(2) temp.auxjpos1.x(4) temp.jpos.x(4) temp.auxjpos2.x(4) temp.auxjpos1.x(6) temp.jpos.x(6) temp.auxjpos2.x(6) temp.auxjpos2.x(5) temp.jpos.x(5) temp.auxjpos1.x(5) temp.auxjpos2.x(3) temp.jpos.x(3) temp.auxjpos1.x(3) temp.auxjpos2.x(1) temp.jpos.x(1)];
temp.v.contour.y = [temp.jpos.y(1) temp.auxjpos1.y(1) temp.auxjpos1.y(2) temp.jpos.y(2) temp.auxjpos2.y(2) temp.auxjpos1.y(4) temp.jpos.y(4) temp.auxjpos2.y(4) temp.auxjpos1.y(6) temp.jpos.y(6) temp.auxjpos2.y(6) temp.auxjpos2.y(5) temp.jpos.y(5) temp.auxjpos1.y(5) temp.auxjpos2.y(3) temp.jpos.y(3) temp.auxjpos1.y(3) temp.auxjpos2.y(1) temp.jpos.y(1)];
temp.v.contour.z = [temp.jpos.z(1) temp.auxjpos1.z(1) temp.auxjpos1.z(2) temp.jpos.z(2) temp.auxjpos2.z(2) temp.auxjpos1.z(4) temp.jpos.z(4) temp.auxjpos2.z(4) temp.auxjpos1.z(6) temp.jpos.z(6) temp.auxjpos2.z(6) temp.auxjpos2.z(5) temp.jpos.z(5) temp.auxjpos1.z(5) temp.auxjpos2.z(3) temp.jpos.z(3) temp.auxjpos1.z(3) temp.auxjpos2.z(1) temp.jpos.z(1)];

%% Plotting the Robot

if ctrl.boolplot == 1
    
    hold off
    
    for i = 1:6
        
        plot3(temp.v.(['coxa' num2str(i)]).x,temp.v.(['coxa' num2str(i)]).y,temp.v.(['coxa' num2str(i)]).z,'b')
        hold on
        plot3(temp.v.(['femur' num2str(i)]).x,temp.v.(['femur' num2str(i)]).y,temp.v.(['femur' num2str(i)]).z,'g')
        plot3(temp.v.(['tibia' num2str(i)]).x,temp.v.(['tibia' num2str(i)]).y,temp.v.(['tibia' num2str(i)]).z,'r')
        patch(temp.v.contour.x,temp.v.contour.y,temp.v.contour.z,'c')
        
        if ctrl.showfeet == 1
            plot3(temp.v.(['tibia' num2str(i)]).x(2),temp.v.(['tibia' num2str(i)]).y(2),temp.v.(['tibia' num2str(i)]).z(2),'mo')
        end
        
        if ctrl.showorigin == 1
            plot3(0,0,TerrainFun(0,0,terrain),'or')
        end
        
    end
    
    axis equal
    view(ctrl.viewType)
    
end

if ctrl.boolplot == 1
    if ctrl.showterrain == 1
        TerrainGenerator(terrain)
    end
end
