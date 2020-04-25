%% Antialiasing Main
%  Demo Script for Shift and Sum with Disparity-based Local Interpolation

%  This script takes light field sub-aperture images in the folder 
%  'Sample Data/Light Field' as inputs to generate a refocused image.
%  And the corresponding depth maps generated using the Depth Estimation 
%  in this package have been provided in 'Sample Data/Depthmap'. Based on 
%  these depth maps, this script can generate an antialiased refocused image 
%  for a given depth. The outputs including the refocused image and
%  antialiased image are saved in 'SampleData/Output'.
%
%  @Citation: The algorithm implemented here is from the following paper: 
%  Depth-based refocusing for reducing directional aliasing artifacts
%  Lee,S. et al.,Optics express, vol.24, no.24, pp.28 065?28 079, 2016.
% 
%  Note: this script might take around 15 mins that depends on your
%  computer configuretion.

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
               
%% Load 4D light field from sample data

views = 16; % number of views
frameOfInterest = 59; 
lightField = genLfSequence("./Sample Data/Light Field/", "Painter_pr_00",views,frameOfInterest,'png');

%% Compute the antialiased refocus image and compare with original refocus image

depth = 4; 
center = 6; % index of the central view in the camera array
%  [ 1, 2, 3, 4;
%    5, 6, 7, 8;
%    9,10,11,12;
%   13,14,15,16]
                                         
% focal length in pixels of each camera
focalLength = [2354.048,2339.371,2346.855,2347.432;
               2343.521,2340.136,2345.382,2353.755;
               2344.436,2342.490,2351.322,2355.210;
               2341.483,2347.073,2344.877,2342.375]; 
cameraDis = 0.07; % distance of adjacent cameras in metres

% get shifted light field views, shifts, and refocused image
[shiftedLightField, deltaMat,refocus] = lfShiftSum(lightField,shiftMat,depth); 

% load depth maps of all views
folder = "./Sample Data/Depthmap/depthMaps59_";
lfSize = size(lightField);
disparityMat = zeros(lfSize(1),lfSize(2),lfSize(4));

index = 1;
for i=0:3
    for j=0:3
        path = folder+i+j+".mat";
        load(char(path),'depthMapMat');
%       compute the disparity map based on each depth map
        disparityMat(:,:,index) = cameraDis*focalLength(i+1,j+1)./depthMapMat;
        index = index + 1;
    end
end

% compute the aliasing free refocused image
antiRefo = antialiasing(shiftedLightField,deltaMat,disparityMat);

%% Show and save images

subplot(2,1,1), imshow(uint8(refocus)), title("Refocus");
subplot(2,1,2), imshow(uint8(antiRefo)), title("AntiRefo-multiple depthmaps");

imwrite(uint8(refocus),"./Sample Data/Output/refocus"+frameOfInterest+"_d"+depth+".png");
imwrite(uint8(antiRefo),"./Sample Data/Output/antiRefo"+frameOfInterest+"_d"+depth+".png");


