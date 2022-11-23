% Speed multiplier to make all the gait types walk the same distance in a
% gait cycle

function [out] = multiplier(GaitType)

RIPPLE_SPEED = 1/6;
AMBLE_SPEED = 1/3;
TRIPOD_SPEED = 1/2;

for i = 1:length(GaitType)
    
    switch char(GaitType(i))
            
        case {'RIPPLE'}
            out(i) = RIPPLE_SPEED;
            
        case {'AMBLE'}
            out(i) = AMBLE_SPEED;
            
        case {'TRIPOD'}
            out(i) = TRIPOD_SPEED;
            
        case {'NONE'}
            out(i) = 0;
            
    end
    
end

end