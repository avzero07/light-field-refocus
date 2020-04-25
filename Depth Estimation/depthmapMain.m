%% Multi-resolution Correspondence Matching Depth Estimator
% @Purpose: This script takes in light field images and generate
% a depth map for the chosen reference view
%
% @Citation: The algorithm implemented here is from the following paper: 
% Dataset and Pipeline for Multi-View Light-Field Video. 
% N. Sabater et al. CVPR Workshops, 2017.
%
% @Note: The demo takes a long time to run depending on your hardware
% configuration. Please wait patiently till the run completes. It took
% approximately 15-30 minutes to run.

clc;
close all;
clear variables;

              

%% Get depthmap of the reference view -- multiresolution strategy
%%% Parameter Setting
%Define the reference depth z0 and the chosen depth z1, they are used for
%view shifting amount calculation.
z0 = 100;
z1 = 1.63;

%Define the initial depth range for your light field image sequence
zmin = 2; 
zmax = 10;

%Define the resolution of the depth map
%How many intervals is required between Zmin and Zmax
depthRes = 40;

%Define how many resolution scales at which you want to do depth esitmations
K = 4;

%Define the subdivisions for the other higher resolution scales
M = 2;

%Set the range of frames which depthmaps need generating, for a single
%frame, set s_frame equals to e_frame. Note: frame number starts from 1
s_frame = 60;%Start frame
e_frame = 60;%End Frame

%Set which view you want it to be the reference view
s = 1;%Vertical Index
t = 1;%Horizontal Index

%Define the path for saving output depth image and the image filetype
prefix = ".\Sample Data\Depth Estimation Output\depthMap_";
suffix = ".png";

%Set how many view there exists for a single frame
views = 16;
arr_width = int8(sqrt(views)); 

%%%%%%%%%Depth estimation algorithm start Here%%%%%%%%%
%Initialization
frame_num = e_frame-s_frame+1;
frameSeq = linspace(s_frame, e_frame, frame_num);%Generate frame index sequence
frameLen = length(frameSeq);

%Matrix for saving depthmaps, it should match the resolution of your image
depthMapMat = zeros(1088,2048,frameLen);

%Loop through selected frames to generate depth map for each frame, use
%parfor to enable parallel computing, in the case that multiple frames are
%involved, change the 'for' to 'parfor', change your parallel preference to
%determine how many workers you want use for paralleling
for f = 1:frameLen
    frameOfInterest = frameSeq(f)-1;%Offset by 1 to meet dataset's naming convention
    %Calculate the index of reference view 
    refIdx = arr_width*s+t+1;
    %Get all the grayscale version of views for current frame
    lightFieldGray = genLfSequenceGray(".\Sample Data\Depth Estimation Input\", "Painter_pr_00",views,frameOfInterest,'png');
    %Generate the shiftmatrix according to current reference view setting
    newshiftMat = changeBaseView(s,t);
    tic
    %Run multiRes function to generate depthmap
    depthMap = multiResDepthEstm(lightFieldGray, refIdx, newshiftMat, zmin, zmax, depthRes, K, M, z0, z1, arr_width);
    toc
    %Plot depth map to a grayscale image.
    figure 
    imshow(mat2gray(depthMap));
    title(sprintf('depthMap for frame %d',frameOfInterest));
    %Comment out the above codes if you don't want depth maps to be ploted.
    depthMapMat(:,:,f) = depthMap;
    %Conver depthmap matrix into a grayscale Image and save it
    depthMapConv = uint8(255*mat2gray(depthMap));
    filename = prefix + string(frameOfInterest)+suffix;
    imwrite(depthMapConv,filename,'png');
    frameOfInterest
end
%Save the depthmap matrix for all selected frames
save(".\Sample Data\Depth Estimation Output\depthMaps59.mat",'depthMapMat','-v7.3');
