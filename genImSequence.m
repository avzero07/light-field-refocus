%% genImSequence Function
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
function [imSequence] = genImSequence(path,canonicalName,frames,view,format)
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
%   Filename      = Painter_pr_00000_00.png
%   canonicalName = "Painter_pr_00";
%   

% Format View Number in Filename
    sView = "";
    if view < 10
        sView = "_0"+string(view);
    elseif view >= 10
        sView = "_"+string(view);
    else
        sView = "";
    end

% Define Matrix to Store ImSequence
imSequence = uint8(zeros(1088,2048,3,frames));

% Read Images
for i=1:frames
    sFrame = string(i);
    % Format Frame Number in Filename
    frame = i-1;
%     switch strlength(string(frame))
%         case 1
%             sFrame = "00"+string(frame);
%         case 2
%             sFrame = "0"+string(frame);
%         case 3
%             sFrame = string(frame);
%     end
    
    % Set File Path
    fullURI = path+canonicalName+"_"+sFrame+"."+format;
    
    % Read Images
    imSequence(:,:,:,i) = imread(fullURI);
end

end

