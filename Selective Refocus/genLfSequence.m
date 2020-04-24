%% genLfSequence Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v1.0
% @date     - 20-Feb-2020
%% Changelog
% Version 1.0
% -- GA Implementation
%
%% Implementation
function [lfSequence] = genLfSequence(path,canonicalName,views,frame,format)
%GENIMSEQUENCE Reads Images from Path and returns the light field.
%
%   ------------------
%   Function Inputs
%   ------------------
%
%   The function loads all views of a specific frame. The combined image
%   sequence is the light-field (of sub-aperture images) for that frame.
%
%   path            ---> (String) Full File System Path to Folder Containing
%                        Images.
%   canonicalName   ---> (String) Common Part of Frame Name
%   views           ---> Total Number of Views to Read (1-16)
%   frame           ---> Frame of Interest from Light Field Dataset
%   format          ---> (String) Image File Format eg: "png" , "jpg"
%
%   Note: The file naming is specfiic to the technicolor light-field
%   dataset.
%
%   File Nameing Example
%   --------
%   Filename      = "Painter_pr_00013_05.png"
%   canonicalName = "Painter_pr_00";
%   frame         = 13
%   view          = 5
%
%   ------------------
%   Function Output
%   ------------------
%  
%   lfSequence      --->  A 4D matrix of images (Width x Height x Color Channels x Number of Views).
%
% NOTE: This function is hard-coded for RGB images of size
% 1088x2048. This is sufficient for images from the Technicolor dataset
% that was used for this project. To extend usage to images from another
% dataset please make sure to update the dimensions (line 61) appropriately.                      
    
% Format Frame Number in Filename
sFrame = "";
switch strlength(string(frame))
    case 1
        sFrame = "00"+string(frame);
    case 2
        sFrame = "0"+string(frame);
    case 3
        sFrame = string(frame);
end

% Define Matrix to Store ImSequence
lfSequence = uint8(zeros(1088,2048,3,views));

% Read Images
for i=1:views
    
    % Format View Number in Filename
    view = i-1;
    sView = "";
    if view < 10
        sView = "_0"+string(view);
    else
        sView = "_"+string(view);
    end
    
    % Set File Path
    fullURI = path+canonicalName+sFrame+sView+"."+format;
    
    % Read Images
    lfSequence(:,:,:,i) = imread(fullURI);
end

end

