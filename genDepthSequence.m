%% genDepthSequence Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 20-Feb-2020
%% Changelog
% Version 0.1
% -- Initial Implementation
% -- Works on Technicolor Light Field Dataset
%
% To Do
% -----
% -- Correct File Name Inconsistency
% -- Set Defaults
%% Implementation
function [imSequence] = genDepthSequence(path,canonicalName,frames,format)
%GENIMSEQUENCE Reads Images from Path and Returns Image Sequence for Video
%   The function loads all frames of a specific view. The combined image
%   sequence can be played as a video.
%
%   path            -- (String) Full File System Path to Folder Containing
%                      Images.
%   canonicalName   -- (String) Common Part of Frame Name
%   frames          -- Total Number of Frames to Read
%   view            -- View of Interest from Light Field Dataset
%   format          -- (String) Image File Format eg: "png" , "jpg"
%
%   Note: The file naming is suitable for the technicolor light-field
%   dataset.
%
%   Filename      = depthMap_0.png
%   canonicalName = "depthMap_";
%   

% Define Matrix to Store ImSequence
imSequence = uint8(zeros(1088,2048,frames));

% Read Images
for i=1:frames
    sFrame = string(i);
    
    % Set File Path
    fullURI = path+canonicalName+sFrame+"."+format
    
    % Read Images
    imSequence(:,:,i) = imread(fullURI);
end

end

