#include <ax12.h>
#include <BioloidController.h>
#include "nuke.h"

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

//some definitions
#define numin   27     // previously we used the same number of input and output variables but it is not a must
#define numout   33
unsigned char vals[numin-1];     // variables that we recieve from matlab
unsigned char valsr[numout-1];     // variables that we send back to matlab
int x[LEG_COUNT];
int y[LEG_COUNT];
int z[LEG_COUNT];
int trantime;
int leglowering[LEG_COUNT];     // used to determine if the leg is lowering: 1 if the leg is lowering, 0 otherwise
int lowering[18]={0};     // used to determine if the servo belongs to a lowering leg
int FSR[LEG_COUNT];
int xr[LEG_COUNT];
int yr[LEG_COUNT];
int zr[LEG_COUNT];
double test;     // used only for debugging
unsigned long lastframe;

int index = -1;
int checksum;
int sum;
int m;

float Bias;     // for the calibration of the yaw angle

Adafruit_BNO055 bno = Adafruit_BNO055(55);     // IMU initialization



void setup(){
  pinMode(0,OUTPUT);
  pinMode(A0,INPUT);     // this are the 6 FSR sensors
  pinMode(A1,INPUT);
  pinMode(A2,INPUT);
  pinMode(A3,INPUT);
  pinMode(A4,INPUT);
  pinMode(A5,INPUT);
  
  setupIK();     // set the initial position when the robot is turned on
  
  Serial.begin(38400);

  
  delay (1000);     // wait, then check the voltage (LiPO safety)
  float voltage = (ax12GetRegister(1,AX_PRESENT_VOLTAGE,1))/10.0;
  if (voltage < 10.0)
    while(1);     // if the voltage is too low the robot doesn't move

  bioloid.poseSize = 18;
  bioloid.readPose();
  
  doAF();     // compute the motion necessary for standing up
  
  bioloid.interpolateSetup(1000,lowering);     // actuate the motion
  while(bioloid.interpolating > 0){
    bioloid.interpolateStep();
    delay(3);
  }
  
  if(!bno.begin())     // check if the imu is working
  {
    while(1);
  }
  bno.setExtCrystalUse(true);
  
  delay(5000);     // 5 seconds to place the robot in the right direction
  sensors_event_t event;     // we measure the yaw at the start and save it, this will be our origin
  bno.getEvent(&event);
  
  Bias = event.orientation.x;
}

void loop(){
  // take commands
  while(Serial.available() > 0){
    if(index == -1){
      if(Serial.read() == 0xff){     // 0xff corresponds to 255 in char
        checksum = 0;
        index = 0;
        lastframe = millis();     // we save the last time we received a packet
      }
      else{
        for(m = 0; m <= numout-1; m++){
          valsr[m] = 254;
          Serial.write(valsr[m]);
        }
      }
    }
    else if(index == 0){
      vals[index] = (unsigned char)Serial.read();
      if(vals[index] != 0xff){
        checksum += (int)vals[index];
        index++;
        lastframe = millis();     // we save the last time we received a packet
      }
    }
    else{
      vals[index] = (unsigned char)Serial.read();
      checksum += (int)vals[index];
      index++;
      lastframe = millis();     // we save the last time we received a packet
      if(index == numin-1){                    // if this is the last packet we do the checksum
        if(checksum%256 != 255){     // packet error!
          for(m = 0; m <= numout-1; m++){
            valsr[m] = 253;
            Serial.write(valsr[m]);
          }
          index = -1;
        }
        else{     
          // the packet has arrived complete and without errors so we save the variables
          // all the corrections are used to allow an intelligent range of 0-254 values (a char)
          x[LEFT_FRONT] = (int)vals[0]+endpoints[LEFT_FRONT].x-128;
          y[LEFT_FRONT] = (int)vals[1]+endpoints[LEFT_FRONT].y-128;
          z[LEFT_FRONT] = (int)vals[2]+endpoints[LEFT_FRONT].z-128;
          x[RIGHT_FRONT] = (int)vals[3]+endpoints[RIGHT_FRONT].x-128;
          y[RIGHT_FRONT] = (int)vals[4]+endpoints[RIGHT_FRONT].y-128;
          z[RIGHT_FRONT] = (int)vals[5]+endpoints[RIGHT_FRONT].z-128;
          x[LEFT_MIDDLE] = (int)vals[6]+endpoints[LEFT_MIDDLE].x-128;
          y[LEFT_MIDDLE] = (int)vals[7]+endpoints[LEFT_MIDDLE].y-128;
          z[LEFT_MIDDLE] = (int)vals[8]+endpoints[LEFT_MIDDLE].z-128;
          x[RIGHT_MIDDLE] = (int)vals[9]+endpoints[RIGHT_MIDDLE].x-128;
          y[RIGHT_MIDDLE] = (int)vals[10]+endpoints[RIGHT_MIDDLE].y-128;
          z[RIGHT_MIDDLE] = (int)vals[11]+endpoints[RIGHT_MIDDLE].z-128;
          x[LEFT_REAR] = (int)vals[12]+endpoints[LEFT_REAR].x-128;
          y[LEFT_REAR] = (int)vals[13]+endpoints[LEFT_REAR].y-128;
          z[LEFT_REAR] = (int)vals[14]+endpoints[LEFT_REAR].z-128;
          x[RIGHT_REAR] = (int)vals[15]+endpoints[RIGHT_REAR].x-128;
          y[RIGHT_REAR] = (int)vals[16]+endpoints[RIGHT_REAR].y-128;
          z[RIGHT_REAR] = (int)vals[17]+endpoints[RIGHT_REAR].z-128;
          trantime = (int)vals[18]*4;
          leglowering[0] = (int)vals[19];
          leglowering[1] = (int)vals[20];
          leglowering[2] = (int)vals[21];
          leglowering[3] = (int)vals[22];
          leglowering[4] = (int)vals[23];
          leglowering[5] = (int)vals[24];
          lowering[0] = (int)vals[19];     // assign to each servomotor the right lowering value
          lowering[2] = (int)vals[19];
          lowering[4] = (int)vals[19];
          lowering[1] = (int)vals[20];
          lowering[3] = (int)vals[20];
          lowering[5] = (int)vals[20];
          lowering[12] = (int)vals[21];
          lowering[14] = (int)vals[21];
          lowering[16] = (int)vals[21];
          lowering[13] = (int)vals[22];
          lowering[15] = (int)vals[22];
          lowering[17] = (int)vals[22];
          lowering[6] = (int)vals[23];
          lowering[8] = (int)vals[23];
          lowering[10] = (int)vals[23];
          lowering[7] = (int)vals[24];
          lowering[9] = (int)vals[24];
          lowering[11] = (int)vals[24];
          
          doAF();     // compute and set the final positions of the servomotors
          bioloid.interpolateSetup(trantime,lowering);     // determine the first ministep each servo needs to accomplish
        }
        index = -1;
      }
      Serial.flush();
    }
  }
  // this is a first attempt of solving the communication issue
//  if(index > -1 && (millis()-lastframe) > 1000){
//    for(m = 0; m <= num-1; m++){
//      valsr[m] = 254;
//      Serial.write(valsr[m]);
//    }
//    index = -1;
//    Serial.flush();
//  }
  
  // update joints
  if(bioloid.interpolating == 1){
    bioloid.interpolateStep();     // actuate the first ministep, it is repeated until all the legs have completed the motion
    if(bioloid.interpolating == 0){     // if the motion is completed
      
      readAF();     // read the position of the endpoints
      
      float voltage = (ax12GetRegister(1,AX_PRESENT_VOLTAGE,1))/10.0;     // read the voltage at the first servo

      sensors_event_t event;     // read the orientation with the IMU
      bno.getEvent(&event);
      
      
      valsr[0] = (unsigned char)(xr[LEFT_FRONT]-endpoints[LEFT_FRONT].x+128);
      valsr[1] = (unsigned char)(yr[LEFT_FRONT]-endpoints[LEFT_FRONT].y+128);
      valsr[2] = (unsigned char)(zr[LEFT_FRONT]-endpoints[LEFT_FRONT].z+128);
      valsr[3] = (unsigned char)(xr[RIGHT_FRONT]-endpoints[RIGHT_FRONT].x+128);
      valsr[4] = (unsigned char)(yr[RIGHT_FRONT]-endpoints[RIGHT_FRONT].y+128);
      valsr[5] = (unsigned char)(zr[RIGHT_FRONT]-endpoints[RIGHT_FRONT].z+128);
      valsr[6] = (unsigned char)(xr[LEFT_MIDDLE]-endpoints[LEFT_MIDDLE].x+128);
      valsr[7] = (unsigned char)(yr[LEFT_MIDDLE]-endpoints[LEFT_MIDDLE].y+128);
      valsr[8] = (unsigned char)(zr[LEFT_MIDDLE]-endpoints[LEFT_MIDDLE].z+128);
      valsr[9] = (unsigned char)(xr[RIGHT_MIDDLE]-endpoints[RIGHT_MIDDLE].x+128);
      valsr[10] = (unsigned char)(yr[RIGHT_MIDDLE]-endpoints[RIGHT_MIDDLE].y+128);
      valsr[11] = (unsigned char)(zr[RIGHT_MIDDLE]-endpoints[RIGHT_MIDDLE].z+128);
      valsr[12] = (unsigned char)(xr[LEFT_REAR]-endpoints[LEFT_REAR].x+128);
      valsr[13] = (unsigned char)(yr[LEFT_REAR]-endpoints[LEFT_REAR].y+128);
      valsr[14] = (unsigned char)(zr[LEFT_REAR]-endpoints[LEFT_REAR].z+128);
      valsr[15] = (unsigned char)(xr[RIGHT_REAR]-endpoints[RIGHT_REAR].x+128);
      valsr[16] = (unsigned char)(yr[RIGHT_REAR]-endpoints[RIGHT_REAR].y+128);
      valsr[17] = (unsigned char)(zr[RIGHT_REAR]-endpoints[RIGHT_REAR].z+128);
      valsr[18] = (unsigned char)(voltage*10);
      valsr[19] = (unsigned char)floor((360-event.orientation.x+Bias)/10);
      valsr[20] = (unsigned char)round(((360-event.orientation.x+Bias)/10-floor((360-event.orientation.x+Bias)/10))*100);
      valsr[21] = (unsigned char)floor((event.orientation.y+180)/10);
      valsr[22] = (unsigned char)round(((event.orientation.y+180)/10-floor((event.orientation.y+180)/10))*100);
      valsr[23] = (unsigned char)floor((event.orientation.z+180)/10);
      valsr[24] = (unsigned char)round(((event.orientation.z+180)/10-floor((event.orientation.z+180)/10))*100);
      valsr[25] = (unsigned char)((1023 - analogRead(0))/4);   //qua c'era un -30 dopo (0)
      valsr[26] = (unsigned char)((1023 - analogRead(1))/4);
      valsr[27] = (unsigned char)((1023 - analogRead(2))/4);
      valsr[28] = (unsigned char)((1023 - analogRead(3))/4);
      valsr[29] = (unsigned char)((1023 - analogRead(4))/4);
      valsr[30] = (unsigned char)((1023 - analogRead(5))/4);  //qua c'era un -30 dopo (5)
      sum = 0;
      for(m = 0; m <= numout-3; m++){
        sum += valsr[m];
      }
      valsr[numout-2] = (unsigned char)(255-(sum)%256);     // this is for the checksum
      Serial.write((unsigned char)255);     // the first char needs to be 255 (0xff)
      for(m = 0; m <= numout-2; m++){
        Serial.write(valsr[m]);     // send back all the remaining values
      }
    }
  }
      
}
