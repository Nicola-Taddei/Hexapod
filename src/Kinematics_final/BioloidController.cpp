/*
  BioloidController.cpp - ArbotiX Library for Bioloid Pose Engine
  Copyright (c) 2008-2012 Michael E. Ferguson.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "BioloidController.h"

/* initializes serial1 transmit at baud, 8-N-1 */
BioloidController::BioloidController(long baud){
    int i;
    // setup storage
    id_ = (unsigned char *) malloc(AX12_MAX_SERVOS * sizeof(unsigned char));
    pose_ = (unsigned int *) malloc(AX12_MAX_SERVOS * sizeof(unsigned int));
    nextpose_ = (unsigned int *) malloc(AX12_MAX_SERVOS * sizeof(unsigned int));
    speed_ = (int *) malloc(AX12_MAX_SERVOS * sizeof(int));
    // initialize
    for (i = 0; i < AX12_MAX_SERVOS; i++){
        id_[i] = i+1;
        pose_[i] = 512;
        nextpose_[i] = 512;
    }
    interpolating = 0;
    playing = 0;
    lastframe_ = millis();
    ax12Init(baud);  
}

/* new-style setup */
void BioloidController::setup(int servo_cnt){
    int i;
    // setup storage
    id_ = (unsigned char *) malloc(servo_cnt * sizeof(unsigned char));
    pose_ = (unsigned int *) malloc(servo_cnt * sizeof(unsigned int));
    nextpose_ = (unsigned int *) malloc(servo_cnt * sizeof(unsigned int));
    speed_ = (int *) malloc(servo_cnt * sizeof(int));
    // initialize
    poseSize = servo_cnt;
    for(i = 0; i < poseSize; i++){
        id_[i] = i+1;
        pose_[i] = 512;
        nextpose_[i] = 512;
    }
    interpolating = 0;
    playing = 0;
    lastframe_ = millis();
}
void BioloidController::setId(int index, int id){
    id_[index] = id;
}
int BioloidController::getId(int index){
    return id_[index];
}

/* load a named pose from FLASH into nextpose. */
void BioloidController::loadPose( const unsigned int * addr ){
    int i;
    poseSize = pgm_read_word_near(addr); // number of servos in this pose
    for(i = 0; i < poseSize; i++)
        nextpose_[i] = pgm_read_word_near(addr+1+i) << BIOLOID_SHIFT;
}
/* read in current servo positions to the pose. */
void BioloidController::readPose(){
    int i;
    for(i = 0; i < poseSize; i++){
        delay(25);   //25
        pose_[i] = ax12GetRegister(id_[i],AX_PRESENT_POSITION_L,2)<<BIOLOID_SHIFT;
    }
}
/* write pose out to servos using sync write. */
void BioloidController::writePose(){
    int temp;
    int length = 4 + (poseSize * 3);   // 3 = id + pos(2byte)
    int checksum = 254 + length + AX_SYNC_WRITE + 2 + AX_GOAL_POSITION_L;
    setTXall();
    ax12write(0xFF);
    ax12write(0xFF);
    ax12write(0xFE);
    ax12write(length);
    ax12write(AX_SYNC_WRITE);
    ax12write(AX_GOAL_POSITION_L);
    ax12write(2);
    int i;
    for(i = 0; i < poseSize; i++)
    {
        temp = pose_[i] >> BIOLOID_SHIFT;
        checksum += (temp&0xff) + (temp>>8) + id_[i];
        ax12write(id_[i]);
        ax12write(temp&0xff);
        ax12write(temp>>8);
    } 
    ax12write(0xff - (checksum % 256));
    setRX(0);
}

/* set up for an interpolation from pose to nextpose over TIME 
    milliseconds by setting servo speeds. */
void BioloidController::interpolateSetup(int time, int *lowering){
    int i;
    for (i = 0; i < poseSize; i++) {
        lowering_[i] = lowering[i];
    }
    int frames = (time/BIOLOID_FRAME_LENGTH) + 1;
    lastframe_ = millis();
    // set speed each servo...
    for(i = 0; i < poseSize; i++){
        if(nextpose_[i] > pose_[i]){
            speed_[i] = (nextpose_[i] - pose_[i])/frames + 1;
        }
        else{
            speed_[i] = (pose_[i]-nextpose_[i])/frames + 1;
        }
        if (lowering_[i] == 1) {
            speed_[i] = speed_[i]/2;
        }
    }
    interpolating = 1;
}
/* interpolate our pose, this should be called at about 30Hz. */
void BioloidController::interpolateStep(){
    if(interpolating == 0) return;
    int i;
    int FSR;
    int complete = poseSize;
    while(millis() - lastframe_ < BIOLOID_FRAME_LENGTH);
    lastframe_ = millis();
    // update each servo
    for(i = 0; i < poseSize; i++){
        int diff = nextpose_[i] - pose_[i];
        if(diff == 0){
            complete--;
        }
        else{
            if (lowering_[i] == 1) {
                if(i == 0 || i == 2 || i == 4)
                    FSR = 1023 - analogRead(0)-30;     //these corrections are used to calibrate all the legs with equal sensibility
                else if (i == 1 || i == 3 || i == 5)
                    FSR = 1023 - analogRead(1);
                else if (i == 12 || i == 14 || i == 16)
                    FSR = 1023 - analogRead(2);
                else if (i == 13 || i == 15 || i == 17)
                    FSR = 1023 - analogRead(3)-30;
                else if (i == 6 || i == 8 || i == 10)
                    FSR = 1023 - analogRead(4);
                else
                    FSR = 1023 - analogRead(5)-30;
            }
            else{
                FSR = 0;
            }
            if (lowering_[i] == 1 && FSR > 100) {
                nextpose_[i] = pose_[i];//nel caso questo si pu� togliere
                complete--;
            }
            else{
                if (diff > 0) {
                    if (diff < speed_[i]) {
                        pose_[i] = nextpose_[i];
                        complete--;
                    }
                    else
                        pose_[i] += speed_[i];
                }
                else{
                    if ((-diff) < speed_[i]) {
                        pose_[i] = nextpose_[i];
                        complete--;
                    }
                    else
                        pose_[i] -= speed_[i];
                }
            }
        }
    }
    if(complete <= 0) interpolating = 0;
    writePose();      
}

/* get a servo value in the current pose */
int BioloidController::getCurPose(int id){
    int i;
    for(i = 0; i < poseSize; i++){
        if( id_[i] == id )
            return ((pose_[i]) >> BIOLOID_SHIFT);
    }
    return -1;
}
/* get a servo value in the next pose */
int BioloidController::getNextPose(int id){
    int i;
    for(i = 0; i < poseSize; i++){
        if( id_[i] == id )
            return ((nextpose_[i]) >> BIOLOID_SHIFT);
    }
    return -1;
}
/* set a servo value in the next pose */
void BioloidController::setNextPose(int id, int pos){
    int i;
    for(i = 0; i < poseSize; i++){
        if( id_[i] == id ){
            nextpose_[i] = (pos << BIOLOID_SHIFT);
            return;
        }
    }
}


