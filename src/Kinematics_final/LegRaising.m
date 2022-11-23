% Computes the endpoint coordinates of a raising leg knowing the terrain
% and body inclination

function [out] = LegRaising(X,Y,Z,Zrot,endpointX,endpointY,endpointZ,Xdisp,Ydisp,Mgb,Mter,Mtras,mov,terrain,ctrl)

%% Position Matrices

M01 = [1 0 0 (Xdisp) ; 0 -1 0 (Ydisp) ; 0 0 -1 0 ; 0 0 0 1];

rotzp = [cos(Zrot) -sin(Zrot) 0 0 ; sin(Zrot) cos(Zrot) 0 0 ; 0 0 1 0 ; 0 0 0 1];


%% Raising Leg Position

Gpos = Mter*Mgb*M01*(rotzp*[X + endpointX ; Y + endpointY ; mov.maxlift ; 1]); % we raise the leg in the right x and y but at the max height
% Zter = TerrainFun(Gpos(1),Gpos(2),terrain); 
% Zlift = -Z;
Greq = [Gpos(1) ; Gpos(2) ; Gpos(3) ; 1];

%% Finalizing the LegCS Position

Lreq = inv(Mtras*Mgb*M01)*Greq;


%% Output Definition

out.x = Lreq(1);
out.y = Lreq(2);
out.z = Lreq(3);

end