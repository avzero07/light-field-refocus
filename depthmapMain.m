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
%s = 2;
%t = 2;
%newshiftMat = changeBaseView(s,t);

%% Load 4D light field 
%views = 16;
%frameOfInterest = 84;
%genLfSequence("/Users/vera/Downloads/EECE541/project/Code/Repo/light-field-refocus/Images-Frame1/", "Painter_pr_00",views,frameOfInterest,'png');

%% Get depthmap of central view -- correspondence matching
zmin = 2;
zmax = 10;
depthRes = 40;
%center = s*4+t+1;
%depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes,K);

%figure 
%imagesc(depthmap);
%title("correspondence matching");
%% Get depthmap of central view -- multiresolution stratege
K = 4;
M = 2;
z = 4;
%zncc = getZNCC3(lightFieldGrey, center, z, shiftMat);
%figure
%imshow(zncc);
%{
lightFieldGray = genLfSequenceGray("D:\EECE541\light-field_refocus2\light-field-refocus\Images-Frame85\", "Painter_pr_00",views,frameOfInterest,'png');
depthmap = multiRes(lightFieldGray,center,newshiftMat,zmin,zmax,depthRes,K,M);
figure 
imshow(mat2gray(depthmap));
colormap jet;
title(sprintf('final multi resolution with k=%d',0));
%}
s_frame = 85;
e_frame = 85;
s = 1;
t = 1;
frame_num = e_frame-s_frame+1;
frameSeq = linspace(s_frame, e_frame, frame_num);
%frameSeq = [1 85];
frameLen = length(frameSeq);
views = 16;
%depthMapMat = zeros(1088,2048,frameLen);
prefix = ".\Output\depthMap_";
suffix = ".png";
parfor f = 1:frameLen
    frameOfInterest = frameSeq(f)-1;
    refIdx = 4*s+t+1;
    lightFieldGray = genLfSequenceGray("D:\Painters\Painter\png\", "Painter_pr_00",views,frameOfInterest,'png');
    newshiftMat = changeBaseView(s,t);
    tic
    depthMap = multiRes(lightFieldGray,refIdx,newshiftMat,zmin,zmax,depthRes,K,M);
    toc
    %{
    figure 
    imshow(mat2gray(depthMap));
    colormap jet;
    title(sprintf('depthMap for frame %d',frameOfInterest));
    %}
    depthMapMat(:,:,f) = depthMap;
    depthMapConv = uint8(255*mat2gray(depthMap));
    filename = prefix + string(frameOfInterest)+suffix;
    imwrite(depthMapConv,filename,'png');
    frameOfInterest
end
save(".\Output\depthMaps19to18.mat",'depthMapMat','-v7.3');
%depthMapMat = computeDepthmaps(1,1,zmin,zmax,depthRes,K,M,frameSeq);