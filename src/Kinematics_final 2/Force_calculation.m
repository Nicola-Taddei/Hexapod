%This is for calculating the forces each leg substain at each step

for m=1:6
    temp.fsrvoltage.(['leg' num2str(m)]) = ...
        (temp.fsr.(['leg' num2str(m)])/1023)*5;  %[V]
    temp.fsrresistance.(['leg' num2str(m)]) = ...
        ((5000/temp.fsrvoltage.(['leg' num2str(m)]))-1000)/1000;   %[k-ohm]
    temp.fsr.indexes.(['leg' num2str(m)]) = ...
        find(Resistance<temp.fsrresistance.(['leg' num2str(m)]));
    force.(['leg' num2str(m)])(p) = ...
        Force(temp.fsr.indexes.(['leg' num2str(m)])(1));
end


