% Used to compute the nearest point outside the dangerous zone

function [xn,yn] = NTZ(x,y,xv,yv)

A = [xv(1),yv(1)];
B = [xv(2),yv(2)];
C = [xv(3),yv(3)];
D = [xv(4),yv(4)];
n(1) = pdist2(A,B)/0.5+1;
n(2) = pdist2(B,C)/0.5+1;
n(3) = pdist2(C,D)/0.5+1;
n(4) = pdist2(D,A)/0.5+1;

perimeter(:,1) = [linspace(A(1),B(1),n(1)),linspace(B(1),C(1),n(2)),linspace(C(1),D(1),n(3)),linspace(D(1),A(1),n(4))];
perimeter(:,2) = [linspace(A(2),B(2),n(1)),linspace(B(2),C(2),n(2)),linspace(C(2),D(2),n(3)),linspace(D(2),A(2),n(4))];

P = [x,y];
k = dsearchn(perimeter,P);
Pnew = [perimeter(k,1), perimeter(k,2)];

xn = Pnew(1);
yn = Pnew(2);

end