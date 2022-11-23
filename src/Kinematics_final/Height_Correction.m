% Used to avoid the cumulative lowering or raising of the body, but also
% improving the interaction of the robot with unmodeled terrains

for i = 1:6
    temp.height_error(i) = temp.v.(['tibia' num2str(i)]).z(2) - TerrainFun(temp.v.(['tibia' num2str(i)]).x(2),temp.v.(['tibia' num2str(i)]).y(2),terrain);
end


temp.mean_height_error = mean(temp.height_error);

TMatr.(['gait' num2str(k)]).(['M' num2str(j)])(3,4) = TMatr.(['gait' num2str(k)]).(['M' num2str(j)])(3,4)-temp.mean_height_error; 

