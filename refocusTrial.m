%% Light Field Refocus
% Main Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-Feb-2020
%% Init
clc;
close all;
clear variables;
%% Parameters
frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;
%% Load Images
lightField = genLfSequence("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\","Painter_pr_00",views,frameOfInterest,"png");
%% Display All Views of Given Frame
figure
subplot(4,4,1), imshow(lightField(:,:,:,1)), title("1");
subplot(4,4,2), imshow(lightField(:,:,:,2)), title("2");
subplot(4,4,3), imshow(lightField(:,:,:,3)), title("3");
subplot(4,4,4), imshow(lightField(:,:,:,4)), title("4");
subplot(4,4,5), imshow(lightField(:,:,:,5)), title("5");
subplot(4,4,6), imshow(lightField(:,:,:,6)), title("6");
subplot(4,4,7), imshow(lightField(:,:,:,7)), title("7");
subplot(4,4,8), imshow(lightField(:,:,:,8)), title("8");
subplot(4,4,9), imshow(lightField(:,:,:,9)), title("9");
subplot(4,4,10), imshow(lightField(:,:,:,10)), title("10");
subplot(4,4,11), imshow(lightField(:,:,:,11)), title("11");
subplot(4,4,12), imshow(lightField(:,:,:,12)), title("12");
subplot(4,4,13), imshow(lightField(:,:,:,13)), title("13");
subplot(4,4,14), imshow(lightField(:,:,:,14)), title("14");
subplot(4,4,15), imshow(lightField(:,:,:,15)), title("15");
subplot(4,4,16), imshow(lightField(:,:,:,16)), title("16");
sgtitle("All Views from Frame-"+string(frameOfInterest));
%% Compute Refocused Image

% Define Shift Matrix for Painter Scene
shiftMat = zeros(4,4,2);
shiftMat(:,:,1) = [100,-0.36,-97.19,-195.55;
                   98.67,0,-96.18,-197.85;
                   99.17,0.21,-98.33,-197;
                   99.08,-1.22,-99.26,-198.36];
shiftMat(:,:,2) = [98.28,98.14,98.07,97.35;
                   -1.73,0,0.74,0.11;
                   -99.93,-99.11,-101.12,-99.07;
                   -197.68,-198.14,-198.89,-199.37];
% Note: Multiply shiftMat(:,:,2) by -1 when Using
%       Conventions are reversed for Imtranslate.

% Run Loop To Generate Views at Different Depths
depth = 2;
figure
for i=1:6
    temp = lfRefocus(lightField,4,4,shiftMat,depth);
    subplot(2,3,i), imshow(uint8(temp)), title("Z = "+string(depth)+" meters");
    depth = depth+0.5;
end
sgtitle("Refocused at Different Depths");
%% Output