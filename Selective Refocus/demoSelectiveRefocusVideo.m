%% Demo Script to Selectively Refocus/Blur an Image and Generate Video
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v1.0
% @date     - 07-Apr-2020
%% Changelog
% Version 1.0
% -- GA Implementation

%% Description

% This script serves as a demo to illustrate how the functions in this
% package can be used to selectively blur input image frames (from a video) 
% of a lightField dataset and generate an output video.
%
% < Required Inputs >
% 1. Image Frames from the technicolor lightField Dataset
% 2. Corresponding Depthmaps (can be generated using the depthmap generation code from this pckage)
% 3. [Optional: Read line 64] CSV File containing refocusRange for different frames. ('refocusPlan.csv' is used here)
%
%
% Sample images (base view 5 [central view (s,t)=(1,1)]) and corresponding 
% depth-maps have been included in the 'Sample-Data/Sample-RefocVideo' folder. 
% The output video will be stored in the 'Sample-Data/Sample-RefocVideo/Output' 
% path. The output video is in the .avi format and can be played back using 
% VLC media player.
%
% NOTE: Only 6 frames and corresponding depthmaps are included in the
% package due to file size restrictions.
%
% This script is capable of running as is and without any modification. All
% paths are relative and should function identically in Windows/Mac/Linux
% environments. The script has been tested in Windows 10 and works as
% expected.
%
% This script can be extended for a larger number of images from the
% technicolor lightField dataset. If so, please make sure to add more input
% images and corresponding depthmaps to the appropriate input folders. Also
% modify the following lines
%
% 1. line 54 to indicate the number of frames that need to be processed.
% 2. line 53 to indicate the appropriate base view.

%% Initialize Workspace
clc;
clear variables;
close all;

%% Set Paths and Parameters Specific to Data

ipFolder = "Sample-Data/Sample-RefocVideo/Images/"; % Specifies the path to Input Images
ipCanonical = "Painter_pr_00";                      % Specifies file naming convention for Depthmap
view = 5;                                           % View (or camera) of Interest. Used to specify base view
frames = 6;                                         % Number of Frames to Read

pathToDepth = "Sample-Data/Sample-RefocVideo/Depthmaps/"; % Specifies the path to Depthmaps
depthFile = "depthMap_"; % eg: depthMapt_0 to depthMap_5  % Specifies file naming convention for Depthmap

opFolder = "Sample-Data/Sample-RefocVideo/Output/"; % Output Video is written to this Folder

% Read refocusPlan CSV
refocusPlan = readmatrix('refocusPlan.csv');        % CSV File specifies 'focusRange' for each frame

% NOTE: The CSV file is necessary only if the user intends for different
% frames to be refocused differently. If the intention is to have the same
% range of depths in focus across all frames then please comment line 87,
% uncomment line 88 and specify the refocusRange of choice in line 88 ([0 20] 
% is inserted as a placeholder).

%% Read Image Sequence
imSequence = genImSequence(ipFolder,ipCanonical,frames,view,"png");
% Refer to 'genImSequence.m' Function File for more information about this
% function.

%% Read Depth Maps
depthSequence = genDepthSequence(pathToDepth,'depthMap_',frames,'png');
% Refer to 'genDepthSequence.m' Function File for more information about this
% function.

%% Loop Over Frames and Refocus Based on Plan

opSequence = uint8(zeros(size(imSequence,1),size(imSequence,2),size(imSequence,3),frames)); % Initialize Output Image Sequence

% Loop Over Images in Input Sequence and Perform Selective Blurring
tic
for i=1:frames
    opSequence(:,:,:,i) = selectiveBlurring(imSequence(:,:,:,i),depthSequence(:,:,i),20,[refocusPlan(i,2) refocusPlan(i,3)],20);
    %opSequence(:,:,:,i) = selectiveBlurring(imSequence(:,:,:,i),depthSequence(:,:,i),20,[0 20],20);
    'Frame '+string(i)
end
toc
%% Write Video
tstamp = clock; % Get timestamp to uniquely name output file
% Generate timestampString
tstampString = string(tstamp(1))+string(tstamp(2))+string(tstamp(3))+string(tstamp(4))+string(tstamp(4))+string(tstamp(5))+string(tstamp(6));

% Create Video Writer Object
outputVideo = VideoWriter(fullfile(opFolder,'Scene-1-uncomp-'+tstampString+'.avi'),'Uncompressed AVI');
%outputVideo = VideoWriter(fullfile(opFolder,'Scene-1-comp-'+tstampString+'.avi'));

% NOTE: Leave one of line 57 or line 58 uncommented. 
%       Line 57: Force MATLAB to generate an Uncompressed Output
%       Line 58: Generate compressed Output

outputVideo.FrameRate = 30; % Specfies FrameRate for OutputVideo

% Open Video Writer Object, Loop Through Output Sequence and Generate Video
open(outputVideo)

for ii = 1:frames
   writeVideo(outputVideo,opSequence(:,:,:,ii))
end

close(outputVideo) % Closes the Video Writer object and Writes Output to Folder