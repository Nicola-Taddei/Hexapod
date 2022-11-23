% This computes the z coordinate of the terrain for the x,y point depending
% on the terrain type

function[zt,dztdx,dztdy,out] = TerrainFun(x,y,terrain)

out = terrain;

switch char(terrain.type)
    
    case {'RAMP'}
        
        alpha = 0;
        beta = -deg2rad(9.7524);
        origin = [300 ; 0 ; 0];
        
        roty = [cos(beta) 0 sin(beta) 0 ; 0 1 0 0 ; -sin(beta) 0 cos(beta) 0 ; 0 0 0 1];
        rotx = [1 0 0 0 ; 0 cos(alpha) -sin(alpha) 0 ; 0 sin(alpha) cos(alpha) 0 ; 0 0 0 1];
        M = roty*rotx;
        v = M*[0 0 1 1]';
        d = -v(1:3)'*origin;
        
        zt = x.*0 -(x*v(1) + y*v(2) + d)/v(3).*(x > origin(1)).*(x < 1910) + 276*(x >= 1910);
        dztdx = x.*0 -v(1)/v(3).*(x > origin(1));
        dztdy = x.*0 -v(2)/v(3).*(x > origin(1));

        out.plottype = 1;
        
    case {'RAMP2'}
        
        alpha = 0;
        beta = -deg2rad(15.3);
        origin = [300 ; 0 ; 0];
        
        roty = [cos(beta) 0 sin(beta) 0 ; 0 1 0 0 ; -sin(beta) 0 cos(beta) 0 ; 0 0 0 1];
        rotx = [1 0 0 0 ; 0 cos(alpha) -sin(alpha) 0 ; 0 sin(alpha) cos(alpha) 0 ; 0 0 0 1];
        M = roty*rotx;
        v = M*[0 0 1 1]';
        d = -v(1:3)'*origin;
        
        zt = x.*0 -(x*v(1) + y*v(2) + d)/v(3).*(x > origin(1)).*(x < 2270) + 538*(x >= 2270);
        dztdx = x.*0 -v(1)/v(3).*(x > origin(1));
        dztdy = x.*0 -v(2)/v(3).*(x > origin(1));
        
        out.plottype = 1;
        
    case {'RAMP3'}
        
        alpha = 0;
        beta = -deg2rad(19.7);
        origin = [300 ; 0 ; 0];
        
        roty = [cos(beta) 0 sin(beta) 0 ; 0 1 0 0 ; -sin(beta) 0 cos(beta) 0 ; 0 0 0 1];
        rotx = [1 0 0 0 ; 0 cos(alpha) -sin(alpha) 0 ; 0 sin(alpha) cos(alpha) 0 ; 0 0 0 1];
        M = roty*rotx;
        v = M*[0 0 1 1]';
        d = -v(1:3)'*origin;
        
        zt = x.*0 -(x*v(1) + y*v(2) + d)/v(3).*(x > origin(1)).*(x < 2370) + 733*(x >= 2370);
        dztdx = x.*0 -v(1)/v(3).*(x > origin(1));
        dztdy = x.*0 -v(2)/v(3).*(x > origin(1));
        
        out.plottype = 1;
        
    case {'FLAT'}
        
        zt = x.*0;
        dztdx = x.*0;
        dztdy = x.*0;
        
        out.plottype = 1;
        
    case {'OBSTACLE'}
        
        zt = 30.*(x >= 372).*(x < 585).*(y >= 0).*(y < 270);
        dztdx = x.*0;
        dztdy = x.*0;
        
        out.plottype = 1;
        
     case {'OBSTACLES'}
        
        zt = 35.*(x >= 550).*(x < 750).*(y >= 0).*(y < 300) + 30.*(x >= 750).*(x < 950).*(y < 0).*(y > -300);
        dztdx = x.*0;
        dztdy = x.*0;
        
        out.plottype = 1;
        
    case {'STEP'}
        
        origin = 250;
        step_height = 30;
        
        zt = step_height*(x > origin-10);
        dztdx = x.*0;
        dztdy = x.*0;
        
        out.origin = origin;
        out.plottype = 2;
                
    case {'STEPS'}
        
        step_length = 200;
        step_height = 34;
        origin = 360;
        platform = 800;
        
        zt = step_height*(x > origin).*(x <= origin + step_length) ...
            + 2*step_height*(x > origin + step_length).*(x <= origin + 2*step_length) ...
            + 3*step_height*(x > origin + 2*step_length).*(x <= origin + 3*step_length) ...
            + 4*step_height*(x > origin + 3*step_length).*(x <= origin + 4*step_length) ...
            + 5*step_height*(x > origin + 4*step_length).*(x <= origin + 5*step_length) ...
            + 6*step_height*(x > origin + 5*step_length).*(x <= origin + 6*step_length) ...
            + 7*step_height*(x > origin + 6*step_length).*(x <= origin + 7*step_length) ...
            + 8*step_height*(x > origin + 7*step_length).*(x <= origin + 7*step_length + platform);
        dztdx = x.*0;
        dztdy = x.*0;
        
        out.step_length = step_length;
        out.step_height = step_height;
        out.origin = origin;
        out.plottype = 4;
        
    case {'SINUSOIDAL'}
        
        zt = 10*(cos(x/100) + sin(y/100));
        dztdx = 10*(-sin(x/100)/100);
        dztdy = 10*(cos(y/100)/100);
        
        out.plottype = 3;
        
    case {'SINUSOIDAL_LINEAR'}
        
        zt = 50*(cos(x/100) + sin(y/100)) - sqrt(x.^2 + y.^2)/2;
        dztdx = 50*(-sin(x/100)/100) - x./(2*sqrt(x.^2 + y.^2));
        dztdy = 50*(cos(y/100)/100) - y./(2*sqrt(x.^2 + y.^2));
        
        out.plottype = 3;
        
    otherwise
        error('%s Terrain type not recognized', terrain.type);
end

end