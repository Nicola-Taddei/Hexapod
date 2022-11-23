% Initialization of the communication

s = serialport("COM3",38400)
flush(s); %viene sempre fatto all'inizio quindi l'ho messo anch'io


s.UserData = struct("NumBytes",1,"ReturnedData",[],"Ok",1) %inizializzo le variabili che riceverò dall'arduino

s.UserData.NumBytes = 27;

configureCallback(s,"byte",s.UserData.NumBytes,@readSerialData) %ogni volta che N byte sono disponibili si attiva la funzione readserialdata

pause (4) %giusto per dare il tempo che la serial port sia aperta









