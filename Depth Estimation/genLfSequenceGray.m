function [lfSequence] = genLfSequenceGray(path,canonicalName,views,frame,format)
%GENLFSEQUENCEGRAY Reads Images from Path and Returns Gray Image Sequence
%   The function loads all views of a specific frame. The combined image
%   sequence is the light-field (of sub-aperture images) for that frame.
%
%   ------------------
%   Function Inputs
%   ------------------
%   path            -- (String) Full File System Path to Folder Containing
%                      Images.
%   canonicalName   -- (String) Common Part of Frame Name
%   views           -- Total Number of Views to Read
%   frame           -- Frame of Interest from Light Field Dataset
%   format          -- (String) Image File Format eg: "png" , "jpg"
%
%   Note: The file naming is suitable for the technicolor light-field
%   dataset.
%
%   Example filename      = Painter_pr_00000_00.png
%   Example canonicalName = "Painter_pr_00";
%   ------------------
%   Function Output
%   ------------------   
%   lfSequence      -- (3D matrix)the matrix of grayscale image sequence
%                       of all views
%% Implementation    
% Format Frame Number in Filename, extend frame number to three digits
sFrame = "";
switch strlength(string(frame))
    case 1
        sFrame = "00"+string(frame);
    case 2
        sFrame = "0"+string(frame);
    case 3
        sFrame = string(frame);
end

% Define Matrix to Store grayscale ImSequence, resolution 1088*2048** views
lfSequence = uint8(zeros(1088,2048,views));

% Read Images
for i=1:views
    
    % Format View Number in Filename
    view = i-1;
    sView = "";% The string of view number
    % Extend the view number to two digits
    % And add _ in from of the view string
    if view < 10
        sView = "_0"+string(view);
    else
        sView = "_"+string(view);
    end
    
    % Set File Path
    fullURI = path+canonicalName+sFrame+sView+"."+format;   
    % Read Images, and convert it grayscale
    lfSequence(:,:,i) = rgb2gray(imread(char(fullURI)));
end

end

