% Correction of the position considering the slip effect. This is not
% final, it needs to be upgraded

temp.position_error = 0/temp.Nsteps*2; %15 per tripod, 18 per amble

TMatr.(['gait' num2str(k)]).(['M' num2str(j)])(1,4) = TMatr.(['gait' num2str(k)]).(['M' num2str(j)])(1,4)-temp.position_error;