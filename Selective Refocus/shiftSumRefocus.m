%% shiftSumRefocus Function
% @version  - v1.0
% @date     - 19-Feb-2020
%% Changelog
% Version 1.0
% -- GA Implementation
%
%% Implementation
function [refocusedImage] = shiftSumRefocus(lightField,arrayLength,arrayDepth,shiftMat,depth)
%LFREFOCUS refocuses a scene using shift-sum refocus method.
%
%   The function takes the sub-aperture images of a scene as input and
%   then uses the shift and sum technique to compute a refocused image of
%   the scene at specified depth.
%
%   ------------------
%   Function Inputs
%   ------------------
%
%   lightField ---> 4D Matrix Containing sub-aperture images of a scene.
%                   Use output from 'genLfSequence'.
%
%   shiftMat   ---> NxNx2 Matrix Containing U-V shift relative to reference
%                   camera. This parameter is unique to a camera rig. Will
%                   need to be modified when processing light-fields from a
%                   different rig.
%
%   depth      ---> Depth (in Meters). Specifies the depth plane that will be
%                   in focus. Depth is measured along the axis that runs from the
%                   camera and into the scene.
%
%   ------------------
%   Function Output
%   ------------------
%  
%   refocusedImage ---> Refocused image of a scene.
%
% NOTE: This function is hard-coded for RGB images of size
% 1088x2048. This is sufficient for images from the Technicolor dataset
% that was used for this project. To extend usage to images from another
% dataset please make sure to update the dimensions appropriately.   

% Define Expression for Depth Parameter, d(z)
z = depth;
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));

% NOTE: The depth expression comes from the "Dataset and Pipeline for 
% Multi-view Light-Field Video" cited below.

% N. Sabater et al., "Dataset and Pipeline for Multi-view Light-Field Video", 
% 2017 IEEE Conference on Computer Vision and Pattern Recognition Workshops (CVPRW), 
% Honolulu, HI, 2017, pp. 1743-1753.

% Run Loop through Sub-Aperture Images
refocusedImage = zeros(1088,2048,3);
index = 0;
for i=1:arrayLength
    for j=1:arrayDepth
        index = index + 1;
        % Perform Shift and Sum
        refocusedImage = refocusedImage + double(imtranslate(lightField(:,:,:,index),[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)]));
    end
end

% Compute Average
refocusedImage = uint8(255*mat2gray(refocusedImage/(arrayLength*arrayDepth)));

end

