function [lfSequence] = genLfSequence(path,canonicalName,views,frame,format)
% GENIMSEQUENCE Reads light field sub-aperture images from path 
%
%   The function loads all views of a specific frame. The combined image
%   sequence is the light field sub-aperture images for that frame.
%
%   ------------------
%   Function Inputs
%   ------------------
%
%   path            ---> (String) Full File System Path to Folder Containing
%                        Images.
%   canonicalName   ---> (String) Common Part of Frame Name
%   views           ---> Total Number of Sub Aperture Views to Read (1-16)
%   frame           ---> Frame of Interest from Light Field Dataset
%   format          ---> (String) Image File Format eg: "png" , "jpg"
% 
%   ------------------
%   Function Output
%   ------------------
%  
%   lfSequence      --->  A 4D matrix of images (Width x Height x Color Channels x Number of Sub-Aperture Views).
%
% 
%
%   Note: The file naming is suitable for the technicolor light-field
%   dataset.
%
%   Filename      = Painter_pr_00000_00.png
%   canonicalName = "Painter_pr_00";
%   
    
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

% Define Matrix to Store ImSequence, resolution 1088*2048*3 channel * views
lfSequence = uint8(zeros(1088,2048,3,views));

% Read Images
for i=1:views
    
    % Format View Number in Filename
    view = i-1;
    sView = "";% The string of view number
    if view < 10
        sView = "_0"+string(view);
    else
        sView = "_"+string(view);
    end
    
    % Set File Path
    fullURI = path+canonicalName+sFrame+sView+"."+format;   
    % Read Images
    lfSequence(:,:,:,i) = imread(char(fullURI));
end

end

