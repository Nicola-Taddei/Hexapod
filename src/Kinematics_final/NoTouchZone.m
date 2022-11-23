% Used to avoid placing the feet in dangerous zones. Here we define these
% zones for each terrain type. In particular it is used for the steps.

function [xn,yn,zn] = NoTouchZone(x,y,terrain)

switch char(terrain.type)
    
    case {'RAMP'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
%         ntz.area1.xv = [400, 400, 500, 500];
%         ntz.area1.yv = [0, -600, -600, 0];
%         in = inpolygon(x,y,ntz.area1.xv,ntz.area1.yv);
%         if in == 1
%             [xn,yn] = NTZ(x,y,ntz.area1.xv,ntz.area1.yv);
%         end
%         zn = TerrainFun(xn,yn,terrain);
        
    case {'RAMP2'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    case {'RAMP3'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    case {'FLAT'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
%         ntz.area1.xv = [300, 300, 500, 500];
%         ntz.area1.yv = [-100, -400, -400, -100];
%         in = inpolygon(x,y,ntz.area1.xv,ntz.area1.yv);
%         if in == 1
%             [xn,yn] = NTZ(x,y,ntz.area1.xv,ntz.area1.yv);
%         end
%         zn = TerrainFun(xn,yn,terrain);
        
    case {'OBSTACLE'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
     case {'OBSTACLES'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    case {'STEP'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    case {'STEPS'}
        
        step_length = terrain.step_length;
        step_height = terrain.step_height;
        origin = terrain.origin;
        
        ntz.margin = 50;
        for p = 1:8
            ntz.(['area' num2str(p)]).xv = [origin+(p-1)*step_length-ntz.margin, origin+(p-1)*step_length-ntz.margin, origin+(p-1)*step_length+ntz.margin, origin+(p-1)*step_length+ntz.margin];
            ntz.(['area' num2str(p)]).yv = [625, -625, -625, 625];
            in(p) = inpolygon(x,y,ntz.(['area' num2str(p)]).xv,ntz.(['area' num2str(p)]).yv);
        end
        
        idx = find(in);
        if idx > 0
                [xn,yn] = NTZ(x,y,ntz.(['area' num2str(idx)]).xv,ntz.(['area' num2str(idx)]).yv);
        else
            xn = x;
            yn = y;
        end
        zn = TerrainFun(xn,yn,terrain);
        
    case {'SINUSOIDAL'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    case {'SINUSOIDAL_LINEAR'}
        
        xn = x;
        yn = y;
        zn = TerrainFun(xn,yn,terrain);
        
    otherwise
        error('%s Terrain type not recognized', terrain.type);
end

end