% Computes the servo angles from the endpoint coordinates

function [out] = legIK(X,Y,Z,lc,lf,lt)

trueX = sqrt(X^2 + Y^2) - lc;
im = sqrt(trueX^2 + Z^2);
q1 = atan2(trueX,Z);
q2 = acos((lf^2 + im^2 - lt^2)/(2*im*lf));

out.coxa = atan2(Y,X);
out.femur = q1 + q2;
out.tibia = acos((lf^2 + lt^2 - im^2)/(2*lt*lf));

end
