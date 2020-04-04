%% Compare Shift Sum and Selective Blur

clc;
clear variables;
close all;

%% Selective Refocus
img = imread('Sample-Depth\painter.png');
imgDepth = imread('Sample-Depth\painter-depth.png');

result = selectiveBlurring(img,imgDepth,20,[1 10],35);

figure, imshow(result), title('Selective Blur Range')
%% Shift Sum
depth = 4;
% Define Shift Matrix for Painter Scene
sBase = 1;
tBase = 1;
shiftMat = changeBaseView(sBase,tBase);

frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;
lightField = genLfSequence("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\","Painter_pr_00",views,frameOfInterest,"png");

temp = lfRefocus(lightField,4,4,shiftMat,depth);
%% Plot Output
figure
subplot(1,2,1), imshow(result,[]), title('Selective Refocus')
subplot(1,2,2), imshow(uint8(temp),[]), title('Shift Sum')