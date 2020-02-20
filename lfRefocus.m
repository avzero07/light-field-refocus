%% Light Field Refocus
% lfRefocus Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 19-Feb-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
% -- Works for Light-Field from NxN Setup
%
% To Do
% -----
% -- Solve Intensity Problem When Overlap is Minimum
% -- Add Defaults
%% Implementation
function [refocusedImage] = lfRefocus(lightField,arrayLength,arrayDepth,shiftMat,depth)
%LFREFOCUS Fronto-parallel Refocus on a Scene Using its Light-Field
%   The function takes as input, the sub-aperture images of a scene and
%   then uses the shift and sum technique to compute a refocused image of
%   the scene at specified depth.
%
%   lightField -- Matrix Containing sub-aperture images of a scene.
%   shiftMat   -- NxNx2 Matrix Containing U-V shift relative to reference
%                 camera. This parameter is unique to a camera rig. Will
%                 need to be modified when processing light-fields from a
%                 different rig.
%   depth      -- Depth (in Meters) at Which Refocus Plane is Placed.

% Define Expression for Depth Parameter, d(z)
z = depth;
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));

% Run Loop
refocusedImage = zeros(1088,2048,3);
index = 0;
for i=1:arrayLength
    for j=1:arrayDepth
        index = index + 1;
        refocusedImage = refocusedImage + double(imtranslate(lightField(:,:,:,index),[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)]));
    end
end

refocusedImage = refocusedImage/(arrayLength*arrayDepth);

end

