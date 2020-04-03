%% computeZNCC Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 01-Apr-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Clear
clc;
clear variables;
close all;
%% Init
% Load 4D light field 
views = 16;
frameOfInterest = 0;
lightField = genLfSequenceGray("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\Sample\", "Painter_pr_00",views,frameOfInterest,'png');

shiftMat = changeBaseView(1,1);
%% MAIN

K = 4;  % Scales for Resolution | 4 = Coarse, 0 = Fine
L = 50; % Depth Levels (Initial)
M = 2;  % Subdivisions for Later Scales

zmin = 2;
zmax = 10;
delz = (zmax-zmin)/L;

%% Lowest Resolution (K=4)
scale = 1/(2^K);
znccVector = zeros(68,128,1,L+1);

% Loop Through Depth
tic
for l=0:1:50
    l
    znccVector(:,:,:,l+1) = computeZNCC(lightField,shiftMat,6,zmin+(l*delz),scale);
end
toc

%% Minimization
[m,ind] = min(znccVector,[],4); % Note: Depth is "ind"
ZCourse = zmin+((ind-1)*delz);
%% Next Resolution (K=3)
scale = 1/(2^(K-1));

% Define RefImage
refImage = lightField(:,:,:,6);
refImageRes = imresize(refImage,scale);

% Resize LightField by New K
lightFieldRes = resizeLightField(lightField,scale);
%% Loop Through Pixels of refImageRes
scoreBoard3 = zeros(size(refImage,1),size(refImage,2));
tic
for x=1:size(refImageRes,1)
    x
    parfor y=1:size(refImageRes,2)
        % Call znccLocal at Every Pixel
        scoreBoard3(x,y) = computeZNCCLocal(lightFieldRes,refImageRes,6,x,y,ZCourse,delz,shiftMat*scale);
        y
    end
end
toc