% Computes the endpoint coordinates of a lowering leg knowing the terrain
% and body inclination

function [out] = LegLowering(X,Y,Z,Zrot,endpointX,endpointY,endpointZ,Xdisp,Ydisp,Mgb,Mter,Mtras,mov,terrain,ctrl)

%% Position Matrices

M01 = [1 0 0 (Xdisp) ; 0 -1 0 (Ydisp) ; 0 0 -1 0 ; 0 0 0 1];

rotzp = [cos(Zrot) -sin(Zrot) 0 0 ; sin(Zrot) cos(Zrot) 0 0 ; 0 0 1 0 ; 0 0 0 1];

%% Lowering Leg Position

Gpos = Mter*Mgb*M01*(rotzp*[X + endpointX ; Y + endpointY ; endpointZ + Z ; 1]);
[xnew,ynew,znew] = NoTouchZone(Gpos(1),Gpos(2),terrain);
Greq = [xnew ; ynew ; znew ; 1];

%% Finalizing the LegCS Position

Lreq = inv(Mtras*Mgb*M01)*Greq;

if ctrl.control == 1
    Lreq(3) = mov.maxfall; % when controlling the real robot we impose the max fall in this way it stops only when touching the ground
end

%% Output Definition

out.x = Lreq(1);
out.y = Lreq(2);
out.z = Lreq(3);

end