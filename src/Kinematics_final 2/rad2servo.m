% Converts the angles from radiant to servo values

function [out] = rad2servo(angle)

out = 1023/(2*(5/6*pi))*(angle + 5/6*pi);

end