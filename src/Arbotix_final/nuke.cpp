#include <ax12.h>
#include <BioloidController.h>
#include <Arduino.h>
#include <math.h>
#include "nuke.h"

// min and max positions for each servo
int mins[] = {226, 226, 159, 159, 200, 40, 226, 226, 159, 159, 200, 40, 226, 226, 159, 159, 200, 40};
int maxs[] = {790, 790, 859, 859, 980, 810, 790, 790, 859, 859, 980, 810, 790, 790, 859, 859, 980, 810};

// IK Engine
BioloidController bioloid = BioloidController(1000000);     // necessary to work
ik_req_t endpoints[LEG_COUNT];

// setup the starting positions of the legs
void setupIK(){
  
  endpoints[LEFT_FRONT].x = 52;
  endpoints[LEFT_FRONT].y = -118;
  endpoints[LEFT_FRONT].z = 117;
  
  endpoints[RIGHT_FRONT].x = 52;
  endpoints[RIGHT_FRONT].y = 118;
  endpoints[RIGHT_FRONT].z = 117;
  
  endpoints[LEFT_MIDDLE].x = 0;
  endpoints[LEFT_MIDDLE].y = -129;
  endpoints[LEFT_MIDDLE].z = 117;
  
  endpoints[RIGHT_MIDDLE].x = 0;
  endpoints[RIGHT_MIDDLE].y = 129;
  endpoints[RIGHT_MIDDLE].z = 117;
  
  endpoints[LEFT_REAR].x = -52;
  endpoints[LEFT_REAR].y = -118;
  endpoints[LEFT_REAR].z = 117;
  
  endpoints[RIGHT_REAR].x = -52;
  endpoints[RIGHT_REAR].y = 118;
  endpoints[RIGHT_REAR].z = 117;
  
  x[LEFT_FRONT] = endpoints[LEFT_FRONT].x;
  y[LEFT_FRONT] = endpoints[LEFT_FRONT].y;
  z[LEFT_FRONT] = endpoints[LEFT_FRONT].z;
  
  x[RIGHT_FRONT] = endpoints[RIGHT_FRONT].x;
  y[RIGHT_FRONT] = endpoints[RIGHT_FRONT].y;
  z[RIGHT_FRONT] = endpoints[RIGHT_FRONT].z;
  
  x[LEFT_MIDDLE] = endpoints[LEFT_MIDDLE].x;
  y[LEFT_MIDDLE] = endpoints[LEFT_MIDDLE].y;
  z[LEFT_MIDDLE] = endpoints[LEFT_MIDDLE].z;
  
  x[RIGHT_MIDDLE] = endpoints[RIGHT_MIDDLE].x;
  y[RIGHT_MIDDLE] = endpoints[RIGHT_MIDDLE].y;
  z[RIGHT_MIDDLE] = endpoints[RIGHT_MIDDLE].z;
  
  x[LEFT_REAR] = endpoints[LEFT_REAR].x;
  y[LEFT_REAR] = endpoints[LEFT_REAR].y;
  z[LEFT_REAR] = endpoints[LEFT_REAR].z;
  
  x[RIGHT_REAR] = endpoints[RIGHT_REAR].x;
  y[RIGHT_REAR] = endpoints[RIGHT_REAR].y;
  z[RIGHT_REAR] = endpoints[RIGHT_REAR].z;
}


// convert radians to servo position offset
double radToservo(double rads){
  double val = (rads+atan(1)*10/3)*1023/(atan(1)*20/3);
  return val;
}

// convert dynamixel servo offset to radians
double servoTorad(double val){
  double rads = val*(atan(1)*20/3)/1023-atan(1)*10/3;
  return rads;
}


// Simple 3dof leg solver. X,Y,Z are the coordinates of the endpoint
ik_sol_t legIK(double X, double Y, double Z){
  ik_sol_t ans;
  
  double trueX = sqrt(sq((double)X)+sq((double)Y)) - L_COXA;
  double im = sqrt(sq((double)trueX)+sq((double)Z));
  double q1 = atan2((double)trueX,(double)Z);
  double d1 = sq(L_FEMUR)-sq(L_TIBIA)+sq(im);
  double d2 = 2*L_FEMUR*im;
  double q2 = acos((double)d1/(double)d2);
  d1 = sq(L_FEMUR)-sq(im)+sq(L_TIBIA);
  d2 = 2*L_TIBIA*L_FEMUR;
  
  ans.coxa = -atan2((double)Y,(double)X);
  ans.femur = q1+q2;
  ans.tibia = acos((double)d1/(double)d2);
  
  return ans;
}

// inverse of legIk (which is the direct kinematics)
inv_ik_sol_t inv_legIK(double coxa, double femur, double tibia){
  inv_ik_sol_t ans;
  
  double im = sqrt(sq(L_FEMUR)+sq(L_TIBIA)-2*L_FEMUR*L_TIBIA*cos((double)tibia));
  double d1 = sq(L_FEMUR)-sq(L_TIBIA)+sq(im);
  double d2 = 2*L_FEMUR*im;
  double q2 = acos((double)d1/(double)d2);
  double q1 = (double)femur-q2;
  double trueX = im*sin(q1);
  
  ans.Z = im*cos(q1);
  ans.Y = (trueX+L_COXA)*sin(-coxa);
  ans.X = (trueX+L_COXA)*cos(-coxa);
  
  return ans;
}

// computes the final servo values from the coordinates of the final endpoints
void doAF(){
  int servo;
  ik_sol_t sol;
  test = 0;
  int i;
  
  // Left Front 1
  sol = legIK(x[0],y[0],z[0]);
  servo = radToservo(sol.coxa-atan(1));
  if(servo < maxs[LF_COXA-1] && servo > mins[LF_COXA-1]){
      bioloid.setNextPose(LF_COXA, servo);
  }
  else{
    test = 1;     // all these tests can be removed, it was useful for debugging
  }
  servo = radToservo(-sol.femur+2*atan(1));
  if(servo < maxs[LF_FEMUR-1] && servo > mins[LF_FEMUR-1]){
      bioloid.setNextPose(LF_FEMUR, servo);
  }
  else{
    test = 2;
  }
  servo = radToservo(4*atan(1)-sol.tibia)-150;
  if(servo < maxs[LF_TIBIA-1] && servo > mins[LF_TIBIA-1]){
      bioloid.setNextPose(LF_TIBIA, servo);
  }
  else{
    test = 3;
  }
  
  // Right Front 2
  sol = legIK(x[1],y[1],z[1]);
  servo = radToservo(sol.coxa+atan(1));
  if(servo < maxs[RF_COXA-1] && servo > mins[RF_COXA-1]){
      bioloid.setNextPose(RF_COXA, servo);
  }
  else{
    test = 4;
  }
  servo = radToservo(sol.femur-2*atan(1));
  if(servo < maxs[RF_FEMUR-1] && servo > mins[RF_FEMUR-1]){
      bioloid.setNextPose(RF_FEMUR, servo);
  }
  else{
    test = 5;
  }
  servo = 1023-(radToservo(4*atan(1)-sol.tibia)-150);
  if(servo < maxs[RF_TIBIA-1] && servo > mins[RF_TIBIA-1]){
      bioloid.setNextPose(RF_TIBIA, servo);
  }
  else{
    test = 6;
  }
  
  // Left Middle 3
  sol = legIK(x[2],y[2],z[2]);
  servo = radToservo(sol.coxa-2*atan(1));
  if(servo < maxs[LM_COXA-1] && servo > mins[LM_COXA-1]){
      bioloid.setNextPose(LM_COXA, servo);
  }
  else{
    test = 7;
  }
  servo = radToservo(-sol.femur+2*atan(1));
  if(servo < maxs[LM_FEMUR-1] && servo > mins[LM_FEMUR-1]){
      bioloid.setNextPose(LM_FEMUR, servo);
  }
  else{
    test = 8;
  }
  servo = radToservo(4*atan(1)-sol.tibia)-150;
  if(servo < maxs[LM_TIBIA-1] && servo > mins[LM_TIBIA-1]){
      bioloid.setNextPose(LM_TIBIA, servo);
  }
  else{
    test = 9;
  }
  
  // Right Middle 4
  sol = legIK(x[3],y[3],z[3]);
  servo = radToservo(sol.coxa+2*atan(1));
  if(servo < maxs[RM_COXA-1] && servo > mins[RM_COXA-1]){
      bioloid.setNextPose(RM_COXA, servo);
  }
  else{
    test = 10;
  }
  servo = radToservo(sol.femur-2*atan(1));
  if(servo < maxs[RM_FEMUR-1] && servo > mins[RM_FEMUR-1]){
      bioloid.setNextPose(RM_FEMUR, servo);
  }
  else{
    test = 11;
  }
  servo = 1023-(radToservo(4*atan(1)-sol.tibia)-150);
  if(servo < maxs[RM_TIBIA-1] && servo > mins[RM_TIBIA-1]){
      bioloid.setNextPose(RM_TIBIA, servo);
  }
  else{
    test = 12;
  }
  
  // Left Rear 5
  sol = legIK(x[4],y[4],z[4]);
  servo = radToservo(sol.coxa-3*atan(1));
  if(servo < maxs[LR_COXA-1] && servo > mins[LR_COXA-1]){
      bioloid.setNextPose(LR_COXA, servo);
  }
  else{
    test = 13;
  }
  servo = radToservo(-sol.femur+2*atan(1));
  if(servo < maxs[LR_FEMUR-1] && servo > mins[LR_FEMUR-1]){
      bioloid.setNextPose(LR_FEMUR, servo);
  }
  else{
    test = 14;
  }
  servo = radToservo(4*atan(1)-sol.tibia)-150;
  if(servo < maxs[LR_TIBIA-1] && servo > mins[LR_TIBIA-1]){
      bioloid.setNextPose(LR_TIBIA, servo);
  }
  else{
    test = 15;
  }
  
  // Right Rear 6
  sol = legIK(x[5],y[5],z[5]);
  servo = radToservo(sol.coxa+3*atan(1));
  if(servo < maxs[RR_COXA-1] && servo > mins[RR_COXA-1]){
      bioloid.setNextPose(RR_COXA, servo);
  }
  else{
    test = 16;
  }
  servo = radToservo(sol.femur-2*atan(1));
  if(servo < maxs[RR_FEMUR-1] && servo > mins[RR_FEMUR-1]){
      bioloid.setNextPose(RR_FEMUR, servo);
  }
  else{
    test = 17;
  }
  servo = 1023-(radToservo(4*atan(1)-sol.tibia)-150);
  if(servo < maxs[RR_TIBIA-1] && servo > mins[RR_TIBIA-1]){
      bioloid.setNextPose(RR_TIBIA, servo);
  }
  else{
    test = 18;
  }
  
}

// computes the actual endpoints from the servo values after the motion
void readAF(){
  int servo;
  ik_sol_t sol;
  inv_ik_sol_t points;
//  delay(5);
//  bioloid.readPose();
  
  
  // Left Front 1
  servo = bioloid.getCurPose(LF_COXA);
  sol.coxa = servoTorad(servo)+atan(1);
  servo = bioloid.getCurPose(LF_FEMUR);
  sol.femur = 2*atan(1)-servoTorad(servo);
  servo = bioloid.getCurPose(LF_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[0] = points.X;
  yr[0] = points.Y;
  zr[0] = points.Z;

  
  // Right Front 2
  servo = bioloid.getCurPose(RF_COXA);
  sol.coxa = servoTorad(servo)-atan(1);
  servo = bioloid.getCurPose(RF_FEMUR);
  sol.femur = 2*atan(1)+servoTorad(servo);
  servo = bioloid.getCurPose(RF_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(1023-servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[1] = points.X;
  yr[1] = points.Y;
  zr[1] = points.Z;
   
  // Left Middle 3
  servo = bioloid.getCurPose(LM_COXA);
  sol.coxa = servoTorad(servo)+2*atan(1);
  servo = bioloid.getCurPose(LM_FEMUR);
  sol.femur = 2*atan(1)-servoTorad(servo);
  servo = bioloid.getCurPose(LM_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[2] = points.X;
  yr[2] = points.Y;
  zr[2] = points.Z;
  
  // Right Middle 4
  servo = bioloid.getCurPose(RM_COXA);
  sol.coxa = servoTorad(servo)-2*atan(1);
  servo = bioloid.getCurPose(RM_FEMUR);
  sol.femur = 2*atan(1)+servoTorad(servo);
  servo = bioloid.getCurPose(RM_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(1023-servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[3] = points.X;
  yr[3] = points.Y;
  zr[3] = points.Z;
  
  // Left Rear 5
  servo = bioloid.getCurPose(LR_COXA);
  sol.coxa = servoTorad(servo)+3*atan(1);
  servo = bioloid.getCurPose(LR_FEMUR);
  sol.femur = 2*atan(1)-servoTorad(servo);
  servo = bioloid.getCurPose(LR_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[4] = points.X;
  yr[4] = points.Y;
  zr[4] = points.Z;
  
  // Right Rear 6
  servo = bioloid.getCurPose(RR_COXA);
  sol.coxa = servoTorad(servo)-3*atan(1);
  servo = bioloid.getCurPose(RR_FEMUR);
  sol.femur = 2*atan(1)+servoTorad(servo);
  servo = bioloid.getCurPose(RR_TIBIA);
  sol.tibia = 4*atan(1)-servoTorad(1023-servo+150);
  points = inv_legIK(sol.coxa, sol.femur, sol.tibia);
  xr[5] = points.X;
  yr[5] = points.Y;
  zr[5] = points.Z;
  
}
