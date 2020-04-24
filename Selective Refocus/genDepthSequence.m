%% genDepthSequence Function
% @version  - v1.0
% @date     - 07-Apr-2020
%% Changelog
% Version 1.0
% -- GA Implementation
%
%% Implementation
function [imSequence] = genDepthSequence(path,canonicalName,frames,format)
%GENIMSEQUENCE Reads depth-map images from specified path and returns an Image Sequence.
%   The function reads depth-map of images from a directory. The combined
%   sequence is useful when processing images to generate a refocused video
%   (see script 'demoSelectiveRefocusVideo.m')
%
%   ------------------
%   Function Inputs
%   ------------------
%
%   path            ---> (String) Full File System Path to Folder Containing
%                        depthmap images
%   canonicalName   ---> (String) Common part of file name
%   frames          ---> Total Number of Frames to be Read
%   format          ---> (String) Image File Format eg: "png" , "jpg"
%
%   Note: The file naming is aligned with the depthmap generated by the
%   depthmap generation function in this package.
%
%   File Naming Example
%   --------
%   Filename      = depthMap_0.png
%   canonicalName = "depthMap_";
%   
%   ------------------
%   Function Output
%   ------------------
%   
%   imSequence ---> A 4D matrix of depthmap images (Width x Height x Color Channels x Number of Frames).
%

% Define Matrix to Store ImSequence
imSequence = uint8(zeros(1088,2048,frames));

% Read Images
for i=1:frames
    sFrame = string(i-1);
    
    % Set File Path
    fullURI = path+canonicalName+sFrame+"."+format
    
    % Read Images
    imSequence(:,:,i) = imread(fullURI);
end

end

