% Function to compute the optimal orientation of the body knowing the
% terrain type

function [out] = TerrainCompensation1(globalCS,bodyCS,M,terrain)


%% Defining Data

Mrotonly = [M(1:3,1:3) zeros(3,1) ; zeros(1,3) 1];

T = M*[0 ; 0 ; 0 ; 1];

%% Gathering Data

x1 = bodyCS.posits.pos1(1);
x2 = bodyCS.posits.pos2(1);
x3 = bodyCS.posits.pos3(1);
x4 = bodyCS.posits.pos4(1);
x5 = bodyCS.posits.pos5(1);
x6 = bodyCS.posits.pos6(1);

y1 = bodyCS.posits.pos1(2);
y2 = bodyCS.posits.pos2(2);
y3 = bodyCS.posits.pos3(2);
y4 = bodyCS.posits.pos4(2);
y5 = bodyCS.posits.pos5(2);
y6 = bodyCS.posits.pos6(2);

z1 = bodyCS.posits.pos1(3);
z2 = bodyCS.posits.pos2(3);
z3 = bodyCS.posits.pos3(3);
z4 = bodyCS.posits.pos4(3);
z5 = bodyCS.posits.pos5(3);
z6 = bodyCS.posits.pos6(3);

%% Lagrange Multipliers Method

% Rotation Equations

x1rotp = @(x) x1*x(4) + z1*x(3)*x(2) + y1*x(5)*x(2);
x2rotp = @(x) x2*x(4) + z2*x(3)*x(2) + y2*x(5)*x(2);
x3rotp = @(x) x3*x(4) + z3*x(3)*x(2) + y3*x(5)*x(2);
x4rotp = @(x) x4*x(4) + z4*x(3)*x(2) + y4*x(5)*x(2);
x5rotp = @(x) x5*x(4) + z5*x(3)*x(2) + y5*x(5)*x(2);
x6rotp = @(x) x6*x(4) + z6*x(3)*x(2) + y6*x(5)*x(2);

y1rotp = @(x) y1*x(3) - z1*x(5);
y2rotp = @(x) y2*x(3) - z2*x(5);
y3rotp = @(x) y3*x(3) - z3*x(5);
y4rotp = @(x) y4*x(3) - z4*x(5);
y5rotp = @(x) y5*x(3) - z5*x(5);
y6rotp = @(x) y6*x(3) - z6*x(5);

z1rotp = @(x) x(1) - x1*x(2) + z1*x(3)*x(4) + y1*x(4)*x(5);
z2rotp = @(x) x(1) - x2*x(2) + z2*x(3)*x(4) + y2*x(4)*x(5);
z3rotp = @(x) x(1) - x3*x(2) + z3*x(3)*x(4) + y3*x(4)*x(5);
z4rotp = @(x) x(1) - x4*x(2) + z4*x(3)*x(4) + y4*x(4)*x(5);
z5rotp = @(x) x(1) - x5*x(2) + z5*x(3)*x(4) + y5*x(4)*x(5);
z6rotp = @(x) x(1) - x6*x(2) + z6*x(3)*x(4) + y6*x(4)*x(5);

x1rot = @(x) [1 0 0 0]*Mrotonly*[x1rotp(x) ; y1rotp(x) ; z1rotp(x) ; 1];
y1rot = @(x) [0 1 0 0]*Mrotonly*[x1rotp(x) ; y1rotp(x) ; z1rotp(x) ; 1];
z1rot = @(x) [0 0 1 0]*Mrotonly*[x1rotp(x) ; y1rotp(x) ; z1rotp(x) ; 1];

x2rot = @(x) [1 0 0 0]*Mrotonly*[x2rotp(x) ; y2rotp(x) ; z2rotp(x) ; 1];
y2rot = @(x) [0 1 0 0]*Mrotonly*[x2rotp(x) ; y2rotp(x) ; z2rotp(x) ; 1];
z2rot = @(x) [0 0 1 0]*Mrotonly*[x2rotp(x) ; y2rotp(x) ; z2rotp(x) ; 1];

x3rot = @(x) [1 0 0 0]*Mrotonly*[x3rotp(x) ; y3rotp(x) ; z3rotp(x) ; 1];
y3rot = @(x) [0 1 0 0]*Mrotonly*[x3rotp(x) ; y3rotp(x) ; z3rotp(x) ; 1];
z3rot = @(x) [0 0 1 0]*Mrotonly*[x3rotp(x) ; y3rotp(x) ; z3rotp(x) ; 1];

x4rot = @(x) [1 0 0 0]*Mrotonly*[x4rotp(x) ; y4rotp(x) ; z4rotp(x) ; 1];
y4rot = @(x) [0 1 0 0]*Mrotonly*[x4rotp(x) ; y4rotp(x) ; z4rotp(x) ; 1];
z4rot = @(x) [0 0 1 0]*Mrotonly*[x4rotp(x) ; y4rotp(x) ; z4rotp(x) ; 1];

x5rot = @(x) [1 0 0 0]*Mrotonly*[x5rotp(x) ; y5rotp(x) ; z5rotp(x) ; 1];
y5rot = @(x) [0 1 0 0]*Mrotonly*[x5rotp(x) ; y5rotp(x) ; z5rotp(x) ; 1];
z5rot = @(x) [0 0 1 0]*Mrotonly*[x5rotp(x) ; y5rotp(x) ; z5rotp(x) ; 1];

x6rot = @(x) [1 0 0 0]*Mrotonly*[x6rotp(x) ; y6rotp(x) ; z6rotp(x) ; 1];
y6rot = @(x) [0 1 0 0]*Mrotonly*[x6rotp(x) ; y6rotp(x) ; z6rotp(x) ; 1];
z6rot = @(x) [0 0 1 0]*Mrotonly*[x6rotp(x) ; y6rotp(x) ; z6rotp(x) ; 1];

% Lagrangian System

par1 = @(x) z1rot(x) - (TerrainFun(T(1) + x1rot(x),T(2) + y1rot(x),terrain) + T(3));
par2 = @(x) z2rot(x) - (TerrainFun(T(1) + x2rot(x),T(2) + y2rot(x),terrain) + T(3));
par3 = @(x) z3rot(x) - (TerrainFun(T(1) + x3rot(x),T(2) + y3rot(x),terrain) + T(3));
par4 = @(x) z4rot(x) - (TerrainFun(T(1) + x4rot(x),T(2) + y4rot(x),terrain) + T(3));
par5 = @(x) z5rot(x) - (TerrainFun(T(1) + x5rot(x),T(2) + y5rot(x),terrain) + T(3));
par6 = @(x) z6rot(x) - (TerrainFun(T(1) + x6rot(x),T(2) + y6rot(x),terrain) + T(3));

system = @(x) [2*par1(x) + 2*par2(x) + 2*par3(x) + 2*par4(x) + 2*par5(x) + 2*par6(x) ;
               2*par1(x)*(-x1) + 2*par2(x)*(-x2) + 2*par3(x)*(-x3) + 2*par4(x)*(-x4) + 2*par5(x)*(-x5) + 2*par6(x)*(-x6) + x(7)*2*x(2) ;
               2*par1(x)*(z1*x(4)) + 2*par2(x)*(z2*x(4)) + 2*par3(x)*(z3*x(4)) + 2*par4(x)*(z4*x(4)) + 2*par5(x)*(z5*x(4)) + 2*par6(x)*(z6*x(4)) + x(6)*2*x(3) ;
               2*par1(x)*(z1*x(3)+y1*x(5)) + 2*par2(x)*(z2*x(3)+y2*x(5)) + 2*par3(x)*(z3*x(3)+y3*x(5)) + 2*par4(x)*(z4*x(3)+y4*x(5)) + 2*par5(x)*(z5*x(3)+y5*x(5)) + 2*par6(x)*(z6*x(3)+y6*x(5)) + x(7)*2*x(4) ;
               2*par1(x)*(y1*x(4)) + 2*par2(x)*(y2*x(4)) + 2*par3(x)*(y3*x(4)) + 2*par4(x)*(y4*x(4)) + 2*par5(x)*(y5*x(4)) + 2*par6(x)*(y6*x(4)) + x(6)*2*x(5) ;
               x(3)^2 + x(5)^2 - 1;
               x(2)^2 + x(4)^2 - 1];
           
% # Solver

x0 = [TerrainFun(T(1),T(2),terrain) 0 1 1 0 0 0];

x0 = x0' - 1;
xnew = x0 + 1;

% i = 1;

while sum(abs((xnew-x0))) > 0.01
    
    x0 = xnew;
    
    direction = system(x0);
    
    weight = 1e-5;
    
    xnew = x0 - weight*direction;

%     i = i + 1;
    
end

estimation = xnew;

%% Translation Matrix Formation

beta = atan2(estimation(2),estimation(4));
alpha = atan2(estimation(5),estimation(3));
bodyZ = estimation(1);

roty = [cos(beta) 0 sin(beta) 0 ;
        0 1 0 0 ;
        -sin(beta) 0 cos(beta) 0 ;
        0 0 0 1];

rotx = [1 0 0 0 ;
        0 cos(alpha) -sin(alpha) 0 ;
        0 sin(alpha) cos(alpha) 0 ;
        0 0 0 1];

tras = [1 0 0 0 ;
        0 1 0 0 ;
        0 0 1 bodyZ ;
        0 0 0 1];

Q = tras*roty*rotx;
% Q = tras;

out = globalCS.M_globalbody*Q/globalCS.M_globalbody;

end