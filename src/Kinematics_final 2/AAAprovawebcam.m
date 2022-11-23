%Webcam connection test
clear all
close all
clc

% x = videoinput('winvideo',1);
% imaqhwinfo(x);
% preview(x);
% cam = ipcam('http://10.5.5.9:8080/live/amba.m3u8','HERO5 Black Luca','surf1791');
% cam = ipcam('http://192.168.137.70:8080/video/mjpg.cgi','admin1','admin1');
cam = ipcam('http://192.168.137.70:8080/','admin1','admin1');
preview(cam);
% img = snapshot(cam);
% imshow(img);
% http://192.168.1.7:8081/367f4a9f-aac3-4247-ac4c-a178928459d2
% blob:http://192.168.1.7:8081/cd5126cb-94e1-476c-9da2-22d2b0ac997f