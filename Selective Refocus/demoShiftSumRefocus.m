%% Demo Script to Illustrate Shift Sum Refocus
% Main Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v1.0
% @date     - 19-Feb-2020
%% Changelog
% Version 1.0
% -- GA Implementation

%% Description

% This script serves as a demo to illustrate how the functions in this
% package can be used to perform shift-sum-refocus on sub-aperture images
% from the technicolor lightField dataset. The script will perform
% shift-sum refocus at 6 pre-determined depth levels and diplay the
% outputs. To modify this, please modify line 68.
%
% < Required Input >
% 1. Sub Aperture Image Frames from the technicolor lightField Dataset
%
% Sample images (frame 85 from the lightField dataset) have been included 
% in the 'Sample-Data/Sample-ShiftSum' folder. Refocused output will be
% displayed on screen.
%
% NOTE: All views from only frame 85 are included in the package due to file 
% size restrictions.
%
% This script is capable of running as is and without any modification. All
% paths are relative and should function identically in Windows/Mac/Linux
% environments. The script has been tested in Windows 10 and works as
% expected.
%

%% Initialize Workspace
clc;
close all;
clear variables;
%% Set Paths and Parameters Specific to Data
inputPath = "Sample-Data/Sample-ShiftSum/"; % Specifies path to input sub-aperture images
views = 16;                                 % Specifies number of sub-aperture images to process
frameOfInterest = 85;                       % Specifies frame of interest

%% Load Images into LightField
lightField = genLfSequence(inputPath,"Painter_pr_00",views,frameOfInterest,"png");
% Refer to 'genLfSequence.m' Function File for more information about this
% function.

%% Display All Sub-Aperture Views of Given Frame
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
shiftMat = changeBaseView(1,1);

% Run Loop To Generate Views at Different Depths (0.5 Increments)

depth = 2; % Starting Depth

figure
for i=1:6
    temp = shiftSumRefocus(lightField,4,4,shiftMat,depth); % Compute Shift Sum Refocus
    subplot(2,3,i), imshow(uint8(temp)), title("Z = "+string(depth)+" meters");
    depth = depth+0.5;
end
sgtitle("Refocused at Different Depths");