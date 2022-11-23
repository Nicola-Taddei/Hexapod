% For a particular gait type that keeps the feet on the ground not moving
% them

function [out] = NoGaitGen(nleg,step,ngait,mov,gaits,gaitData)

gaits.(['leg' num2str(nleg)]).x = gaits.(['leg' num2str(nleg)]).x;
gaits.(['leg' num2str(nleg)]).y = gaits.(['leg' num2str(nleg)]).y;
gaits.(['leg' num2str(nleg)]).z = gaits.(['leg' num2str(nleg)]).z;
gaits.(['leg' num2str(nleg)]).r = gaits.(['leg' num2str(nleg)]).r;
gaits.(['leg' num2str(nleg)]).ispushing = gaits.(['leg' num2str(nleg)]).ispushing;

out = gaits;

end
