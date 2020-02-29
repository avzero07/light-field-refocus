%% Light Field Refocus
%
% Script to Refocus all Frames at a Specific Depth and generate Video.
%
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-Feb-2020
%% Init
clc;
close all;
clear variables;
%% Parameters

% Refocus Depth
depth = 4;

% Light Field DataSet Parameters
frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;

% File System Parameters
ipFolder = "D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\";
ipCanonical = "Painter_pr_00";
opCanonical = "Refoc_ptr_00";
opFolder = "Output\";

% OP Video Parameters
fps = 30;

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
%% Loop Through Each Frame
for i=1:146
    % Extract lfSequence
    lightField = genLfSequence(ipFolder,ipCanonical,views,i,"png");
    % Refocus
    temp = uint8(lfRefocus(lightField,4,4,shiftMat,depth));
    % Write Output
    imwrite(temp,opFolder+opCanonical+"_"+string(i)+".png","png");
    
end
%% Generate Image Sequence for Video
imSequence = genImSequence(opFolder,opCanonical,frames,0,"png");