% Function taken from NUKE used to generate the task of each leg in each
% step. Keep in mind that these coordinates will be modified by other codes

function [out] = DefaultGaitGen(nleg,step,ngait,mov,gaits,gaitData)

if(step == gaitData.gaitLegNo(nleg))
    % leg up, middle position
    gaits.(['leg' num2str(nleg)]).x = 0;
    gaits.(['leg' num2str(nleg)]).y = 0;
    gaits.(['leg' num2str(nleg)]).z = 0;%-mov.liftHeight;
    gaits.(['leg' num2str(nleg)]).r = 0;
    gaits.(['leg' num2str(nleg)]).ispushing = 0;
    gaits.(['leg' num2str(nleg)]).islowering = 0;
else if(((step == gaitData.gaitLegNo(nleg)+1) || (step == gaitData.gaitLegNo(nleg)-(gaitData.stepsInCycle-1))) )%&& (gaits.(['leg' num2str(nleg)]).z < 0))
        % leg down position  NOTE: dutyFactor = gaitType.pushSteps/gaitType.stepsInCycle
        gaits.(['leg' num2str(nleg)]).x = (mov.Xspeed(ngait)*gaitData.cycleTime*gaitData.pushSteps)/(2*gaitData.stepsInCycle);     % travel/Cycle = speed*gaitType.cycleTime
        gaits.(['leg' num2str(nleg)]).y = (mov.Yspeed(ngait)*gaitData.cycleTime*gaitData.pushSteps)/(2*gaitData.stepsInCycle);     % Stride = travel/Cycle * dutyFactor
        gaits.(['leg' num2str(nleg)]).z = 0;                                                                                       %   = speed*gaitType.cycleTime*gaitType.pushSteps/gaitType.stepsInCycle
        gaits.(['leg' num2str(nleg)]).r = (mov.Rspeed(ngait)*gaitData.cycleTime*gaitData.pushSteps)/(2*gaitData.stepsInCycle);     %   we move Stride/2 here
        gaits.(['leg' num2str(nleg)]).ispushing = 0;
        gaits.(['leg' num2str(nleg)]).islowering = 1;
    else
        % move body forward
        gaits.(['leg' num2str(nleg)]).x = (mov.Xspeed(ngait)*gaitData.cycleTime)/gaitData.stepsInCycle;    % note calculations for Stride above
        gaits.(['leg' num2str(nleg)]).y = (mov.Yspeed(ngait)*gaitData.cycleTime)/gaitData.stepsInCycle;    % we have to move Stride/gaitType.pushSteps here
        gaits.(['leg' num2str(nleg)]).z = 0;                                                               %   = speed*gaitType.cycleTime*gaitType.pushSteps/gaitType.stepsInCycle*gaitType.pushSteps
        gaits.(['leg' num2str(nleg)]).r = (mov.Rspeed(ngait)*gaitData.cycleTime)/gaitData.stepsInCycle;    %   = speed*gaitType.cycleTime/gaitType.stepsInCycle
        gaits.(['leg' num2str(nleg)]).ispushing = 1;
        gaits.(['leg' num2str(nleg)]).islowering = 0;
    end
end

out = gaits;

end
