%% Matching Features
% Main Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 27-March-2020
%% Trial Script

%% Init
clc;
%close all;
clear variables;
%% Parameters
frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;
%% Load Images
lightField = genLfSequence("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\","Painter_pr_00",views,frameOfInterest,"png");

%% Finding Tracks Between Views
path = "D:\EECE541 - Project - LF2\LightFieldRefocusingProject\Sample\";
images = imageDatastore(path);
I = rgb2gray(readimage(images,1));
pointsPrev = detectSURFFeatures(I);
[featuresPrev,pointsPrev] = extractFeatures(I,pointsPrev);

vSet = imageviewset();
vSet = addView(vSet,1,'Features',featuresPrev,'Points',pointsPrev);

for i = 2:numel(images.Files)
  I = rgb2gray(readimage(images, i));
  points = detectSURFFeatures(I);
  [features, points] = extractFeatures(I,points);
  vSet = addView(vSet,i,'Features',features,'Points',points);
  pairsIdx = matchFeatures(featuresPrev,features);
  vSet = addConnection(vSet,i-1,i,'Matches',pairsIdx);
  featuresPrev = features;
end

tracks = findTracks(vSet);
%%
cameraPoses = poses(vSet);
intrinsics = cameraIntrinsics(2354.05,[1020.15,486.68],[1088,2048]);
%%
[xyzPoints,errors] = triangulateMultiview(tracks,cameraPoses,intrinsics);
z = xyzPoints(:,3);
idx = errors < 5 & z > 0 & z < 20;
pcshow(xyzPoints(idx, :),'VerticalAxis','y','VerticalAxisDir','down','MarkerSize',30);
hold on
plotCamera(cameraPoses, 'Size', 0.2);
hold off