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
lightField = genLfSequenceGray("D:\EECE541\depth estimation\Images-Frame1\", "Painter_pr_00",views,frameOfInterest,'png');

shiftMat = changeBaseView(1,1);
%% MAIN

K = 4;  % Scales for Resolution | 4 = Coarse, 0 = Fine
L = 50; % Depth Levels (Initial)
M = 2;  % Subdivisions for Later Scales

zmin = 1.63;
zmax = 100;
delz = (zmax-zmin)/L;
z= 4;
zncc = computeZNCC3(lightField,shiftMat,6,z);
figure 
imshow(zncc);
title(sprintf('highest resolution with depth = 4'));
%% Lowest Resolution (K=4)
scale = 1/(2^K);
znccVector = zeros(68,128,1,L+1);

% Loop Through Depth
tic
%for l=0:1:50
    l=3;
    znccVector(:,:,:,l+1) = computeZNCC(lightField,shiftMat,6,zmin+(l*delz),scale);
    figure 
    imshow(uint8(mat2gray(znccVector(:,:,:,l+1))));
    title(sprintf('highest resolution with depth level = %d',l));
%end
toc

%% Minimization
[m,ind] = min(znccVector,[],4);

%% Next Resolution (K=3)
scale = 1/(2^(K-1));
