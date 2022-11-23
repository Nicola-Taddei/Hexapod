% testing joystick features
clear all
clc

% joy = vrjoystick('Saitek P2600 Rumble Force Pad');
% joy = vrjoystick(id,'forcefeedback');

% s = serialport("COM2",38400);
% fopen(s);
% joy = vrjoystick(1);
% 
% joystickPress = readJoystick (mysh);

% if ~isempty(instrfind)
%      fclose(instrfind);
%       delete(instrfind);
% end

joystick = vrjoystick(1);
stateX = true;
stateR = true;
state = [stateX stateR];
% clear s2;
% s2 = serialport('COM3',38400);
% flush(s2);
% delete(s2);
% clear s2
% s2 = serial('COM3','BaudRate',38400);
% fopen(s2);

% while(state)
%     if(axis(joystick,3)>0.99)
%         a = -22.5;
%         state = false;
% %         fprintf(s2,'4');   
%     elseif(axis(joystick,3)<-0.99)
%         a = 22.5;
%         state = false;
%     elseif(axis(joystick,1)>0.5)
%         a = -10;
%         state = false;
% %         fprintf(s2,'3');
%     elseif(button(joystick,4)==1)
%         a=666;
%         state = false;
%     end
%     
% end


%% Lettura valore axis

% while(state)
%     a = axis(joystick,2);
%     pause(1);
%     b = axis(joystick,2);
%     if abs(a-b)<0.1 && b~=0
%         mov.Xspeed = mean([a b])*(-120); %*multiplier(mov.GaitType(k));
%         stateX = false;
% %         stateR = false;
%     end
% end


%% Vecchio codice per comandarlo ad ogni gait

%             prompt = {'Forward speed (max 120)','Rotation [°]'};
%             dlg_title = 'Input';
%             num_lines = 1;
%             def = {'',''};
%             answer = inputdlg(prompt,dlg_title,num_lines,def);
%             mov.Xspeed(k) = str2double(answer{1})*multiplier(mov.GaitType(k));
%             mov.Yspeed(k) = 0*multiplier(mov.GaitType(k));
%             mov.Rspeed(k) = str2double(answer{2})*(pi/180)*multiplier(mov.GaitType(k));
%                     COMUNICAZIONE VIA JOYSTICK
%             state = true;
%             stateR = true;
%             f = msgbox({'Left analogue stick --> move forward/backward';'Right analogue stick --> turn left/right'},'Wait for input from joystick...','custom',myicon);
%             while(state)
%                 if(axis(joystick,2)>0.9)
%                     mov.Xspeed(k) = (-120)*multiplier(mov.GaitType(k));
%                     state = false;
%                 elseif(axis(joystick,2)<-0.9)
%                     mov.Xspeed(k) = (120)*multiplier(mov.GaitType(k));
%                     state = false;
%                 elseif(axis(joystick,2)>0.5)
%                     mov.Xspeed(k) = (-60)*multiplier(mov.GaitType(k));
%                     state = false;
%                 elseif(axis(joystick,2)<-0.5)
%                     mov.Xspeed(k) = (60)*multiplier(mov.GaitType(k));
%                     state = false;
%                 end
%             end
%             while(state)           %ciclo per determinare la velocità su X proveniente dal joystick
%                 a = axis(joystick,2);
% %                 pause(0.3);
%                 b = axis(joystick,2);
%                 if abs(a-b)<0.1 && b~=0
%                     mov.Xspeed(k) = mean([a b])*(-120)*multiplier(mov.GaitType(k));
%                     state = false;
%                 end
%             end
%             
%             while(stateR)        %ciclo per determinare la rotazione R proveniente dal joystick
%                 c = axis(joystick,3);
% %                 pause(0.3);
%                 d = axis(joystick,3);
%                 if abs(c-d)<0.1
%                     mov.Rspeed(k) = mean([c d])*(-22.5)*(pi/180)*multiplier(mov.GaitType(k));
%                     stateR = false;
%                 end
%             end
%             state = true;
%             while(state)
%                 if(axis(joystick,3)>0.9)
%                     mov.Rspeed(k) = (-22.5)*(pi/180)*multiplier(mov.GaitType(k));
%                     state = false;  
%                 elseif(axis(joystick,3)<-0.9)
%                     mov.Rspeed(k) = (22.5)*(pi/180)*multiplier(mov.GaitType(k));
%                     state = false;
%                 elseif(axis(joystick,3)>0.4)
%                     mov.Rspeed(k) = (-10)*(pi/180)*multiplier(mov.GaitType(k));
%                     state = false;
%                 elseif(axis(joystick,3)<-0.4)
%                     mov.Rspeed(k) = (10)*(pi/180)*multiplier(mov.GaitType(k));
%                     state = false;
%                 else
%                     mov.Rspeed(k) = (0)*(pi/180)*multiplier(mov.GaitType(k));
%                     state = false;
%                 end
%             end

%% Prova pov buttons

a = pov(joystick);


%% Vecchio codice da mettere al posto del joystick per inserire gait type

%     choice = menu('Insert the desired gait type:','TRIPOD','RIPPLE','AMBLE','Target reached (STOP)');
%     if choice==1
%         mov.GaitType(k) = {'TRIPOD'};
%     elseif choice==2
%         mov.GaitType(k) = {'RIPPLE'};
%     elseif choice==3
%         mov.GaitType(k) = {'AMBLE'};
%     elseif choice==4
%         k = 99;
%         mov.GaitType(k) = {'TRIPOD'};
%     end
%     gaitselectjoy = msgbox({'5 = TRIPOD';'6 = RIPPLE';'8 = AMBLE';'4 = target reached (STOP)'},'Select the gait type...','custom',myicon2);
