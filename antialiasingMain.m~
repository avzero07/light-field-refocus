%%
clc;
close all;
clear variables;
%% Initialize shifting matrix
shiftMat = zeros(4,4,2);
shiftMat(:,:,1) = [100,-0.36,-97.19,-195.55;
                   98.67,0,-96.18,-197.85;
                   99.17,0.21,-98.33,-197;
                   99.08,-1.22,-99.26,-198.36];
shiftMat(:,:,2) = [98.28,98.14,98.07,97.35;
                   -1.73,0,0.74,0.11;
                   -99.93,-99.11,-101.12,-99.07;
                   -197.68,-198.14,-198.89,-199.37];
               
%% Load 4D light field 
views = 16;
frameOfInterest = 0;
lightField = genLfSequence("/Users/vera/Downloads/EECE541/project/Code/Repo/light-field-refocus/Images-Frame1/", "Painter_pr_00",views,frameOfInterest,'png');

%% Test disparty() function

image1 = imread('/Users/vera/Downloads/EECE541/project/Code/Repo/light-field-refocus/Images-Frame1/Painter_pr_00000_00.png');
image2 = imread('/Users/vera/Downloads/EECE541/project/Code/Repo/light-field-refocus/Images-Frame1/Painter_pr_00000_05.png');
disparityRange = [0,64];
dis = disparity(rgb2gray(image1), rgb2gray(image2), 'DisparityRange',disparityRange);
figure 
imshow(dis,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar

%% Compute the antialiased refocus image and compare with original refocus image
arrayLength = 4;
arrayDepth = 4;
depth = 5;

[shiftedLightField, deltaMat] = lfShifted(lightField,arrayLength,arrayDepth,shiftMat,depth);

[antialiasedRefocus, dis, disX, disY] = antialiasing(shiftedLightField,lightField,deltaMat,arrayLength,arrayDepth);

refocus = lfRefocus(lightField,arrayLength,arrayDepth,shiftMat,depth);

subplot(2,1,1), imshow(uint8(antialiasedRefocus)), title("Antialiased Refocus");
subplot(2,1,2), imshow(uint8(refocus)), title("Refocus");






