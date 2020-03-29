%%
clc;
close all;
clear variables;

%% Initialize shifting matrix
shiftMat = zeros(4,4,2);
shiftMat(:,:,1) = [100,-0.36,-97.19,-195.55;
                   98.67,0,-96.18,-197.85;
                   99.17,0.21,-98.33,-197;
                   99.08,-1.22,-99.26,-198.36];%% X Direction
shiftMat(:,:,2) = [98.28,98.14,98.07,97.35;
                   -1.73,0,0.74,0.11;
                   -99.93,-99.11,-101.12,-99.07;
                   -197.68,-198.14,-198.89,-199.37];%% Y Direction
               
%% Load 4D light field 
views = 16;
frameOfInterest = 0;
lightField = genLfSequence("F:\Project Space\EECE541\light-field-refocus\Images-Frame1\", "Painter_pr_00",views,frameOfInterest,'png');
%genLfSequence("/Users/vera/Downloads/EECE541/project/Code/Repo/light-field-refocus/Images-Frame1/", "Painter_pr_00",views,frameOfInterest,'png');

%% Get depthmap of central view -- correspondence matching
zmin = 10;
zmax = 150;
depthRes = 50;
center = 6;
%depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes,K);

%figure 
%imagesc(depthmap);
%title("correspondence matching");
%% Get depthmap of central view -- multiresolution stratege
K = 4;
M = 2;
depthmap = multiRes(lightField,center,shiftMat,zmin,zmax,depthRes,K,M);

figure 
imagesc(depthmap);
title(sprintf('final multi resolution with k=%d',0));
