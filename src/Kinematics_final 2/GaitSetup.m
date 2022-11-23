% Necessary at the start

function [out] = GaitSetup

for nleg = 1:6
    
    gaits.(['leg' num2str(nleg)]).x = 0;
    gaits.(['leg' num2str(nleg)]).y = 0;
    gaits.(['leg' num2str(nleg)]).z = 0;
    gaits.(['leg' num2str(nleg)]).r = 0;
    gaits.(['leg' num2str(nleg)]).ispushing = 1;
    gaits.(['leg' num2str(nleg)]).islowering = 0;
    
end

out = gaits;

end
