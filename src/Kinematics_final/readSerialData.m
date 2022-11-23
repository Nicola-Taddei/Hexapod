% This function is called by configurecallback every time there are
% NumBytes bytes available. We read the data and save them in the struct

function readSerialData(src,evt)


data = read(src,src.UserData.NumBytes,"uint8");

src.UserData.Ok = data(1);
src.UserData.ReturnedData = data(2:src.UserData.NumBytes);


% flush(src);

end