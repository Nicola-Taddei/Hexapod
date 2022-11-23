% This generates the terrain in the plot

function[] = TerrainGenerator(terrain)

switch terrain.plottype
    
    case 1
        
        vector = (-terrain.radius:100:terrain.radius);
        
    case 2
        
        
        N = floor(terrain.radius/terrain.origin);
        
        j = 1;
        
        for i = 1:N
            
            vector(2*N+2 - 2*j) = -(i*terrain.origin);
            vector(2*N+2 - (2*j+1)) = -(i*terrain.origin) - 10;
            
            vector(2*N+2 + 2*j) = (i*terrain.origin) - 10;
            vector(2*N+2 + (2*j+1)) = (i*terrain.origin);
            
            j = j + 1;
            
        end
        
        vector(2*N+2 - 1) = -10;
        vector(2*N+2) = 0;
        
        vector = [-terrain.radius vector(1:2*N+2) vector(2*N+4:end) terrain.radius];
        
    case 3
        
        vector = -terrain.radius:50:terrain.radius;
        
    case 4
        
        vector = (-terrain.radius:10:terrain.radius);
        
    otherwise
        error('%s Terrain plot type not recognized', terrain.plottype);
end

[terrain.x,terrain.y] = meshgrid(vector);
terrain.z = TerrainFun(terrain.x,terrain.y,terrain);

terrain.s = surf(terrain.x,terrain.y,terrain.z);

% terrain.s.EdgeColor = 'none';
terrain.s.EdgeAlpha = 0.2;
terrain.s.CData = ones(size(terrain.x)*[1 ; 0],size(terrain.x)*[0 ; 1],3)*220/255;
