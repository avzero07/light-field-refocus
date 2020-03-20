%% Light Field Refocus
% Tilt Shift Refocus Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-March-2020
%% Init
clc;
close all;
clear variables;
%% Camera Parameters
R = quat2rotm([ 0.9870    0.1520    0.0070   -0.0280]); % Rotation Matrix
n = [0;0;1]; % Normal From Focal Plane
t = [0.1075;0.5194;1.7274]; % Translation Vector
z = 4; % Depth of Interest
u = 1280; % Pixel of Choice from Base Image (U)
v = 239;  % Pixel of Choice from Base Image (V)
shiftMat = changeBaseView(1,1); % ShiftMat Based on Base View (1,1)

% Sample Transform
T = [1  0  0.002; 
     1  1  0.0002;
     0  0  1   ];
%% Load LightField
frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;
lightField = genLfSequence("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\","Painter_pr_00",views,frameOfInterest,"png");

%% Loop Through LightField
index = 0;

refocusedImage = zeros(1088,2048,3);

for i=1:1:4
    for j=1:1:4
        index = index + 1;
        % STEP 1 : Find 'd'

        % Find p from (u,v) and z
        Ksrtr = getIntrinsic(1,1);  % Depends on Base View
        invKsrtr = inv(Ksrtr);
        p = z*invKsrtr*[u-shiftMat(i,j,1);v-shiftMat(i,j,2);1];

        % d = n'(p-tbase)
        d = n'*(p-t);
        
        % STEP 2 : Compute Hst
        
        % Compute tst
        tst = t;
        tst(1,1) = shiftMat(i,j,1);
        tst(2,1) = shiftMat(i,j,2);
        tst(3,1) = 0;
        
        % Hst = Rst - (tst * n')/d
        %Hst = R - (tst*n')/d;
        Hst = eye(3) - (tst*n')/d;
        
        % STEP 3 : Compute Pst
        Kst = getIntrinsic(i-1,j-1);
        Pst = (Hst);
        
        % STEP 4 : Transform Image
        tform = affine2d(Pst);
        tempImg = mat2gray(lightField(:,:,:,index));
        temp = imwarp(tempImg,tform);
        refocusedImage = refocusedImage + temp;
    end
end

refocusedImage = refocusedImage/views;