% Determines some particular parameters for each gait type

function [out] = gaitSelect(GaitType)

tranTime = 500; % 98 is defined as STD_TRANSITION
out.cycleTime = 0;

switch char(GaitType)
    
    case {'RIPPLE'}
        out.gaitGen = @(nleg,step,ngait,mov,gaits,gaitData) DefaultGaitGen(nleg,step,ngait,mov,gaits,gaitData);
        out.gaitLegNo(2) = 0 + 1;
        out.gaitLegNo(5) = 2 + 1;
        out.gaitLegNo(3) = 4 + 1;
        out.gaitLegNo(1) = 6 + 1;
        out.gaitLegNo(6) = 8 + 1;
        out.gaitLegNo(4) = 10 + 1;
        out.pushSteps = 10;
        out.stepsInCycle = 12;
        
    case {'AMBLE'}
        out.gaitGen = @(nleg,step,ngait,mov,gaits,gaitData) DefaultGaitGen(nleg,step,ngait,mov,gaits,gaitData);
        out.gaitLegNo(2) = 0 + 1;
        out.gaitLegNo(5) = 0 + 1;
        out.gaitLegNo(1) = 2 + 1;
        out.gaitLegNo(6) = 2 + 1;
        out.gaitLegNo(4) = 4 + 1;
        out.gaitLegNo(3) = 4 + 1;
        out.pushSteps = 4;
        out.stepsInCycle = 6;
        
    case {'TRIPOD'}
        out.gaitGen = @(nleg,step,ngait,mov,gaits,gaitData) DefaultGaitGen(nleg,step,ngait,mov,gaits,gaitData);
        out.gaitLegNo(2) = 0 + 1;
        out.gaitLegNo(3) = 0 + 1;
        out.gaitLegNo(6) = 0 + 1;
        out.gaitLegNo(1) = 2 + 1;
        out.gaitLegNo(4) = 2 + 1;
        out.gaitLegNo(5) = 2 + 1;
        out.pushSteps = 2;
        out.stepsInCycle = 4;
        
    case {'NONE'}
        out.gaitGen = @(nleg,step,ngait,mov,gaits,gaitData) NoGaitGen(nleg,step,ngait,mov,gaits,gaitData);
        out.gaitLegNo(2) = 0;
        out.gaitLegNo(3) = 0;
        out.gaitLegNo(6) = 0;
        out.gaitLegNo(1) = 0;
        out.gaitLegNo(4) = 0;
        out.gaitLegNo(5) = 0;
        out.stepsInCycle = 6;
        
    otherwise
        error('%s Gait type not recognized', GaitType);
end

if(out.cycleTime == 0)
    out.cycleTime = (out.stepsInCycle*tranTime)/1000;
end

out.tranTime = tranTime;

end