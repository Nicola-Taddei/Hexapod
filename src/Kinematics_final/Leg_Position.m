function [Tv] = Leg_Position(theta,phi,psi,dim,pos)

Q0 = [cos(pos.epsilon) -sin(pos.epsilon) 0 0 ; sin(pos.epsilon) cos(pos.epsilon) 0 0 ; 0 0 1 0 ; 0 0 0 1];
M0 = [1 0 0 pos.x ; 0 1 0 pos.y ; 0 0 1 pos.z ; 0 0 0 1];

Q1 = [cos(theta) -sin(theta) 0 0 ; sin(theta) cos(theta) 0 0 ; 0 0 1 0 ; 0 0 0 1];
M1 = [1 0 0 dim.lc ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1];
Q2 = [cos(phi) 0 sin(phi) 0 ; 0 1 0 0 ; -sin(phi) 0 cos(phi) 0 ; 0 0 0 1];
M2 = [1 0 0 dim.lf ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1];
Q3 = [cos(psi) 0 sin(psi) 0 ; 0 1 0 0 ; -sin(psi) 0 cos(psi) 0 ; 0 0 0 1];
M3 = [1 0 0 dim.lt ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1];

M.coxa = M0*Q0*Q1*M1;
M.femur = M0*Q0*Q1*M1*Q2*M2;
M.tibia = M0*Q0*Q1*M1*Q2*M2*Q3*M3;

Tv.coxa = M.coxa*[0 ; 0 ; 0 ; 1];
Tv.femur = M.femur*[0 ; 0 ; 0 ; 1];
Tv.tibia = M.tibia*[0 ; 0 ; 0 ; 1];

end