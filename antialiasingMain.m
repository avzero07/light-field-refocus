%% Antialiasing Main

clc;
close all;
clear variables;
%% Initialize shifting matrix

shiftMat = zeros(4,4,2);
% left-right
shiftMat(:,:,1) = [100,-0.36,-97.19,-195.55;
                   98.67,0,-96.18,-197.85;
                   99.17,0.21,-98.33,-197;
                   99.08,-1.22,-99.26,-198.36];
               
% up-down
shiftMat(:,:,2) = [98.28,98.14,98.07,97.35;
                   -1.73,0,0.74,0.11;
                   -99.93,-99.11,-101.12,-99.07;
                   -197.68,-198.14,-198.89,-199.37];
               
%% Load 4D light field 

views = 16; % number of views
frameOfInterest = 59; 
lightField = genLfSequence("./data/LightFieldRefocusingProject/TestSequence/", "Painter_pr_00",views,frameOfInterest,'png');

%% Compute the antialiased refocus image and compare with original refocus image
% Before antialiasing 
depth = 4;
center = 6;

focalLength = [2354.048,2339.371,2346.855,2347.432;
               2343.521,2340.136,2345.382,2353.755;
               2344.436,2342.490,2351.322,2355.210;
               2341.483,2347.073,2344.877,2342.375]; % pixels
cameraDis = 0.07; % meter

lfSize = size(lightField);
xRange = 1:lfSize(1); % 600:700; 
yRange = 1:lfSize(2); % 420:520;

% get shifted lf matrix, deltaX and daltaY, and refocused image
[refocus,shiftedLightField, deltaMat] = lfShiftSum(lightField,shiftMat,depth); 


%% Based on the central depthmap

load ./depthmap/depthMaps59_11.mat
disparity = cameraDis*focalLength(2,2)./depthMapMat;

% shift and sum + local interpolation
antiRefo2 = antialiasing2(shiftedLightField,lightField,center,deltaMat,disparity,xRange,yRange);

%% Based on multiple depthmaps

% load depth maps of all views
folder = "./depthmap/depthMaps59_";
disparityMat = zeros(lfSize(1),lfSize(2),lfSize(4));

index = 1;
for i=0:3
    for j=0:3
        path = folder+i+j+".mat";
        load(char(path),'depthMapMat');
        disparityMat(:,:,index) = cameraDis*focalLength(i+1,j+1)./depthMapMat;
        index = index + 1;
    end
end

antiRefo3 = antialiasing3(shiftedLightField,deltaMat,disparityMat,xRange,yRange);

%% Show images

subplot(3,1,1), imshow(uint8(refocus(xRange,yRange,:))), title("Refocus");
subplot(3,1,2), imshow(uint8(antiRefo2(xRange,yRange,:))), title("AntiRefo-central depthmap");
subplot(3,1,3), imshow(uint8(antiRefo3(xRange,yRange,:))), title("AntiRefo-multiple depthmaps");

imwrite(uint8(refocus),"./antiRefo/refocus_"+frameOfInterest+"_d"+depth+".png");
imwrite(uint8(antiRefo2),"./antiRefo/antiRefo2_"+frameOfInterest+"_d"+depth+".png");
imwrite(uint8(antiRefo3),"./antiRefo/antiRefo3_"+frameOfInterest+"_d"+depth+".png");


