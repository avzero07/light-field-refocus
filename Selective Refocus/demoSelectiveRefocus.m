%% Demo Script to Illustrate Selective Refocus
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v1.0
% @date     - 03-Apr-2020
%% Changelog
% Version 1.0
% -- GA Implementation

%% Description

% This script serves as a demo to illustrate how the functions in this
% package can be used to selectively blur an input image frame from a 
% lightField dataset.
%
% < Required Inputs >
% 1. Image Frame from the technicolor lightField Dataset
% 2. Corresponding Depthmap (can be generated using the depthmap generation code from this pckage)
%
% Three sample images and their depthmaps have been provided along with this 
% package in the 'Sample-Data/Sample-SelectiveBlurring' folder. The script
% is designed to perform selective refocus at certain depth ranges (refer 
% lines 64 onward in this script) to focus on certain objects in the scene.
% Outputs are generated in different figures and are titled appropriately.
%
% NOTE: Only 3 images and corresponding depthmaps are included in the
% package due to file size restrictions.
%
% This script is capable of running as is and without any modification. All
% paths are relative and should function identically in Windows/Mac/Linux
% environments. The script has been tested in Windows 10 and works as
% expected.
%

%% Iinitialize Workspace
clc;
clear variables;
close all;

%% Set Paths and Parameters Specific to the Data

inputPath = "Sample-Data/Sample-SelectiveBlurring/";

img = imread(inputPath+"painter.png");               % Load Image
depthMap = imread(inputPath+"painter-depth.png");    % Load Corresponding Depth Map

% NOTE: Two other image frames ('painter-02.png' and 'painter-03.png') and 
% their corresponding depth maps ('painter-02.png' and 'painter-03.png') are 
% also available as part of this package. Replace the filenames in line 44
% and line 45 to check refocused outputs using these other images. Please
% make sure that images and depthmaps are not mismatched.

% Display Image
figure, imshow(img,[]),title("Reference Image");

% Display Depthmap
imtool(depthMap,[]); 
% This is made interactive so that the user can inspect the depth levels 
% for different pixels of the scene. Depth levels are encoded as intensity
% of the grayscale image.

%% Focusing Different Parts of the Image

% In subsequent sections, different parts of the scene are kept in focus to
% illustrate selective refocusing.

%% Books
resultBooks = selectiveBlurring(img,depthMap,20,[1 6],15);
figure, imshow(resultBooks,[]),title('Stack of Books Focused');

%% Middle Plane (Easel and Frame on Left and Painting on Right Side)
resultEasel = selectiveBlurring(img,depthMap,20,[30 42],15);
figure, imshow(resultEasel,[]),title('Easel on Left Side Refocused');

%% Everything in the Background Focused
resultBackPaintings = selectiveBlurring(img,depthMap,20,[60 255],15);
figure, imshow(resultBackPaintings,[]),title('Paintings and Sculpture at the Back Refocused');

%% Everything in the Foreground Focused
resultAllFore = selectiveBlurring(img,depthMap,20,[1 40],15);
figure, imshow(resultAllFore,[]),title('Back to Books');
