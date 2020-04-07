%% Refocus and Generate Video
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 07-Apr-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
clc;
clear variables;
close all;
%% Initialization
scene = "Scene - Ref 1\";
pathToDepth = "C:\Users\aksha\Documents\MATLAB\light-field-refocus\Final-DepthMaps\"+scene+"LF Depth Maps\";
depthFile = "depthMap_"; % eg: depthMapt_0 to depthMap_149

ipFolder = "D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\";
ipCanonical = "Painter_pr_00";

opFolder = "C:\Users\aksha\Documents\MATLAB\light-field-refocus\Final-Output\"+scene;

% Read refocusPlan CSV
refocusPlan = readmatrix('refocusPlan.csv');

view = 6;
%% Read Image Sequence
imSequence = genImSequence(ipFolder,ipCanonical,147,view-1,"png");

%% Read Depth Maps
depthSequence = genDepthSequence(pathToDepth,'depthMap_',147,'png');
%% Loop Over Frames and Refocus Based on Plan

frames = 147;
opSequence = uint8(zeros(size(imSequence,1),size(imSequence,2),size(imSequence,3),frames));
tic
parfor i=1:frames
    opSequence(:,:,:,i) = selectiveBlurring2(imSequence(:,:,:,i),depthSequence(:,:,i),20,[refocusPlan(i,2) refocusPlan(i,3)],20);
    'Frame '+string(i)
end
toc
%% Write Video

tstamp = clock;
tstampString = string(tstamp(1))+string(tstamp(2))+string(tstamp(3))+string(tstamp(4))+string(tstamp(4))+string(tstamp(5))+string(tstamp(6));
%outputVideo = VideoWriter(fullfile(opFolder,'Scene-1-uncomp-'+tstampString+'.avi'),'Uncompressed AVI');
outputVideo = VideoWriter(fullfile(opFolder,'Scene-1-comp-'+tstampString+'.avi'));

outputVideo.FrameRate = 30;
open(outputVideo)

for ii = 1:frames
   writeVideo(outputVideo,opSequence(:,:,:,ii))
   ii
end

close(outputVideo)
%%
