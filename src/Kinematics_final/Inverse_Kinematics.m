% This is used to compute the endpoints of the legs knowing the body
% inclination and the terrain. It is runned every step

%% Finding Out Legs Action

for i = 1:6
    
    temp.islegpushing(i) = (eval(['temp.gait.leg' num2str(i) '.ispushing'])) == 1;
    temp.isleglowering(i) = (eval(['temp.gait.leg' num2str(i) '.islowering'])) == 1;
    
end

temp.legspushing = find(temp.islegpushing);
temp.legslowering = find(temp.isleglowering);

if sum(temp.legspushing) == 0
    temp.legtouse = 1;
else
    temp.legtouse = temp.legspushing(1);
end

temp.islegraised = 1 - temp.islegpushing;
temp.legsraised = find(temp.islegraised);

%% Body Translation Matrix Definition

temp.bodydisp.X = eval(['temp.gait.leg' num2str(temp.legtouse) '.x']);
temp.bodydisp.Y = eval(['temp.gait.leg' num2str(temp.legtouse) '.y']);
temp.bodydisp.Z = eval(['temp.gait.leg' num2str(temp.legtouse) '.z']);
temp.bodydisp.Zrot = eval(['temp.gait.leg' num2str(temp.legtouse) '.r']);

if ctrl.boolplot == 1 || temp.firstiter == 1
    temp.bodydisp.Zrot = temp.robotRotationZ;
end

temp.bodydisp.rotzp = [cos(temp.bodydisp.Zrot) -sin(temp.bodydisp.Zrot) 0 0 ;
    sin(temp.bodydisp.Zrot) cos(temp.bodydisp.Zrot) 0 0 ;
    0 0 1 0 ;
    0 0 0 1];

temp.bodydisp.mov = [1 0 0 temp.bodydisp.X ;
    0 1 0 temp.bodydisp.Y ;
    0 0 1 temp.bodydisp.Z ;
    0 0 0 1];

TMatr.(['gait' num2str(k)]).(['Q_Tr' num2str(j)]) = globalCS.M_globalbody*(temp.bodydisp.rotzp*temp.bodydisp.mov)/globalCS.M_globalbody;

%% Calculating Transformation Matrix

TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]) = eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j-1)])*eval(['TMatr.gait' num2str(k) '.Q_Tr' num2str(j)]);

%% Adjusting Positions according to Terrain

if terrain.compensator == 1
    TMatr.(['gait' num2str(k)]).(['Q_Ter' num2str(j)]) = TerrainCompensation1(globalCS,bodyCS,TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]),terrain);
else if terrain.compensator == 2
        TMatr.(['gait' num2str(k)]).(['Q_Ter' num2str(j)]) = TerrainCompensation2(globalCS,bodyCS,TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]),terrain);
    else if terrain.compensator == 3
            TMatr.(['gait' num2str(k)]).(['Q_Ter' num2str(j)]) = TerrainCompensation3(globalCS,bodyCS,TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]),terrain);
        else if terrain.compensator == 4
                TMatr.(['gait' num2str(k)]).(['Q_Ter' num2str(j)]) = TerrainCompensation4(globalCS,bodyCS,TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]),terrain);
            end
        end
    end
end

% TMatr.(['gait' num2str(k)]).(['Q_Ter' num2str(j)]) = TerrainCompensationPLUS(globalCS,bodyCS,TMatr.(['gait' num2str(k)]).(['M_Tr' num2str(j)]),terrain);

TMatr.(['gait' num2str(k)]).(['M_Ter' num2str(j)]) = eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j)])*eval(['TMatr.gait' num2str(k) '.Q_Ter' num2str(j)]);

%% Body Rotation and Position Matrices Definition

temp.bodydisp.rotz = [cos(temp.body.bodyRotZ) -sin(temp.body.bodyRotZ) 0 0 ;
    sin(temp.body.bodyRotZ) cos(temp.body.bodyRotZ) 0 0 ;
    0 0 1 0 ;
    0 0 0 1];

temp.bodydisp.roty = [cos(temp.body.bodyRotY) 0 sin(temp.body.bodyRotY) 0 ;
    0 1 0 0 ;
    -sin(temp.body.bodyRotY) 0 cos(temp.body.bodyRotY) 0 ;
    0 0 0 1];

temp.bodydisp.rotx = [1 0 0 0 ;
    0 cos(temp.body.bodyRotX) -sin(temp.body.bodyRotX) 0 ;
    0 sin(temp.body.bodyRotX) cos(temp.body.bodyRotX) 0 ;
    0 0 0 1];


temp.bodydisp.movbody = [1 0 0 temp.body.bodyPosX ;
    0 1 0 temp.body.bodyPosY ;
    0 0 1 temp.body.bodyPosZ ;
    0 0 0 1];

temp.bodydisp.absmovbody = [1 0 0 temp.body.absbodyPosX ;
    0 1 0 temp.body.absbodyPosY ;
    0 0 1 temp.body.absbodyPosZ ;
    0 0 0 1];


TMatr.(['gait' num2str(k)]).(['M' num2str(j)]) = (globalCS.M_globalbody*temp.bodydisp.absmovbody/globalCS.M_globalbody)*eval(['TMatr.gait' num2str(k) '.M_Ter' num2str(j)])*(globalCS.M_globalbody*(temp.bodydisp.movbody*temp.bodydisp.rotz*temp.bodydisp.roty*temp.bodydisp.rotx)/globalCS.M_globalbody);
TMatr.(['gait' num2str(k)]).(['BM_rel' num2str(j)]) = (globalCS.M_globalbody\eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j)])*globalCS.M_globalbody)\temp.bodydisp.absmovbody*(globalCS.M_globalbody\eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j)])*globalCS.M_globalbody)*eval(['TMatr.gait' num2str(k) '.Q_Ter' num2str(j)])*((temp.bodydisp.movbody*temp.bodydisp.rotz*temp.bodydisp.roty*temp.bodydisp.rotx));
% TMatr.(['gait' num2str(k)]).(['BM_rel' num2str(j)]) = (globalCS.M_globalbody\eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j)])*globalCS.M_globalbody)\temp.bodydisp.absmovbody*(globalCS.M_globalbody\eval(['TMatr.gait' num2str(k) '.M_Tr' num2str(j)])*globalCS.M_globalbody)*eval(['TMatr.gait' num2str(k) '.Q_Tr' num2str(j)])*eval(['TMatr.gait' num2str(k) '.Q_Ter' num2str(j)])*((temp.bodydisp.movbody*temp.bodydisp.rotz*temp.bodydisp.roty*temp.bodydisp.rotx));

%% Position of the Pushing Legs regarding Body Position and Inclination

TMatr.(['gait' num2str(k)]).(['Q' num2str(j)]) = eval(['TMatr.gait' num2str(k) '.M' num2str(j-1)])\eval(['TMatr.gait' num2str(k) '.M' num2str(j)]);
TMatr.(['gait' num2str(k)]).(['BQ' num2str(j)]) = inv(globalCS.M_globalbody)*eval(['TMatr.gait' num2str(k) '.Q' num2str(j)])*globalCS.M_globalbody;

for i = temp.legspushing
    
    temp.LQter = eval(['bodyCS.M_bodyleg' num2str(i)])\inv(eval(['TMatr.gait' num2str(k) '.BQ' num2str(j)]))*eval(['bodyCS.M_bodyleg' num2str(i)]);
    
    if ctrl.boolplot == 1
        temp.LQter = diag(ones(4,1));
    end
    
    temp.dummy = temp.LQter*[eval(['temp.reqold.leg' num2str(i) '.x']) ; eval(['temp.reqold.leg' num2str(i) '.y']) ; eval(['temp.reqold.leg' num2str(i) '.z']) ; 1];
    
    temp.req.(['leg' num2str(i)]).x = temp.dummy(1);
    temp.req.(['leg' num2str(i)]).y = temp.dummy(2);
    temp.req.(['leg' num2str(i)]).z = temp.dummy(3);
    
end

%% Position of the Raised Legs regarding Body Position and Inclination

for i = temp.legsraised
    if temp.isleglowering(i) == 1
        temp.req.(['leg' num2str(i)]) = LegLowering(temp.gait.(['leg' num2str(i)]).x, temp.gait.(['leg' num2str(i)]).y, temp.gait.(['leg' num2str(i)]).z, temp.gait.(['leg' num2str(i)]).r, dim.endpoints.(['leg' num2str(i)]).x, dim.endpoints.(['leg' num2str(i)]).y, dim.endpoints.(['leg' num2str(i)]).z, dim.posits.(['pos' num2str(i)]).x, dim.posits.(['pos' num2str(i)]).y, globalCS.M_globalbody, TMatr.(['gait' num2str(k)]).(['M_Ter' num2str(j)]), TMatr.(['gait' num2str(k)]).(['M' num2str(j)]), mov, terrain, ctrl);
    else
        temp.req.(['leg' num2str(i)]) = LegRaising(temp.gait.(['leg' num2str(i)]).x, temp.gait.(['leg' num2str(i)]).y, temp.gait.(['leg' num2str(i)]).z, temp.gait.(['leg' num2str(i)]).r, dim.endpoints.(['leg' num2str(i)]).x, dim.endpoints.(['leg' num2str(i)]).y, dim.endpoints.(['leg' num2str(i)]).z, dim.posits.(['pos' num2str(i)]).x, dim.posits.(['pos' num2str(i)]).y, globalCS.M_globalbody, TMatr.(['gait' num2str(k)]).(['M_Ter' num2str(j)]), TMatr.(['gait' num2str(k)]).(['M' num2str(j)]), mov, terrain, ctrl);
    end
end

