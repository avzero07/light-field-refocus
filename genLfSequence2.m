%% genLfSequence Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-March-2020
%% Changelog
% Version 0.1
% -- Initial Implementation
% -- Works on Technicolor Light Field Dataset
%
% To Do
% -----
% -- Set Defaults
%% Implementation
function [lfSequence] = genLfSequence2(path,canonicalName,s,t,frame,format)
%GENLFSEQUENCE2 Reads Images from Path and Returns the entire light-field
%   for the scene. Note that the output is of shape (t,s,x,y,c) where (t,s)
%   represent the angular dimension and (x,y) represents the spatial
%   dimensions. c is the number of color channels.
%
%   path            -- (String) Full File System Path to Folder Containing
%                      Images.
%   canonicalName   -- (String) Common Part of Frame Name
%   u,v             -- Angular Dimensions (Specify 4,4 for our Dataset)
%   frame           -- Frame of Interest from Light Field Dataset
%   format          -- (String) Image File Format eg: "png" , "jpg"
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

% Define Matrix to Store ImSequence
lfSequence = uint8(zeros(t,s,1088,2048,3));

% Read Images
index = 0;
for i=1:s
    for j=1:t
        index = index + 1;
        % Format View Number in Filename
        view = index - 1;
        sView = "";
        if view < 10
            sView = "_0"+string(view);
        else
            sView = "_"+string(view);
        end

        % Set File Path
        fullURI = path+canonicalName+sFrame+sView+"."+format;

        % Read Images
        lfSequence(i,j,:,:,:) = imread(fullURI); 
    end
end

end

