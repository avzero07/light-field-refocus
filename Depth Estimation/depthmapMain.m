%% Multi-resolution Correspondence Matching Depth Estimator
% @Purpose: This script takes in light field images and generate
% a depth map for the chosen reference view
%
% @Citation: The algorithm implemented here is from the following paper: 
% Dataset and Pipeline for Multi-View Light-Field Video. 
% N. Sabater et al. CVPR Workshops, 2017.




clc;
close all;
clear variables;

              

%% Get depthmap of the reference view -- multiresolution stratege
%%% Parameter Setting
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
prefix = "..\Output\depthMap_";
suffix = ".png";

%Set how many view there exists for a single frame
views = 16;

%%%%%%%%%Depth estimation algorithm start Here%%%%%%%%%
frame_num = e_frame-s_frame+1;
frameSeq = linspace(s_frame, e_frame, frame_num);%Generate frame index sequence
frameLen = length(frameSeq);

depthMapMat = zeros(1088,2048,frameLen);%Matrix for saving depthmaps

for f = 1:frameLen
    frameOfInterest = frameSeq(f)-1;%Offset by 1 to meet dataset's naming convention
    refIdx = 4*s+t+1;%Calculate the index of reference view
    %Get all the grayscale version of views for current frame
    lightFieldGray = genLfSequenceGray("..\Sample Data\Depth Estimation Input\", "Painter_pr_00",views,frameOfInterest,'png');
    %Generate the shiftmatrix according to current reference view setting
    newshiftMat = changeBaseView(s,t);
    tic
    %Run multiRes function to generate depthmap
    depthMap = multiResDepthEstm(lightFieldGray,refIdx,newshiftMat,zmin,zmax,depthRes,K,M);
    toc
    %The commented code is used to plot the generated depthmap
    %{
    figure 
    imshow(mat2gray(depthMap));
    colormap jet;
    title(sprintf('depthMap for frame %d',frameOfInterest));
    %}
    depthMapMat(:,:,f) = depthMap;
    %Conver depthmap matrix into a grayscale Image and save it
    depthMapConv = uint8(255*mat2gray(depthMap));
    filename = prefix + string(frameOfInterest)+suffix;
    imwrite(depthMapConv,filename,'png');
    frameOfInterest
end
%Save the depthmap matrix for all selected frames
save("..\Output\depthMaps59.mat",'depthMapMat','-v7.3');