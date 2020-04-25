function [shiftedLightField, deltaMat,refocus] = lfShiftSum(lightField,shiftMat,depth)
%LFSHIFTED Returns the shifted light field, shifting amount and
% refocused image based on a depth.
% 
%   The function takes the light field sub-aperture images as inputs. All 
%   views will be shifted based on the depth and will be stacked together to 
%   generate a refocused image.
% 
%   ------------------
%   Function Inputs
%   ------------------
%
%   lightField ---> (4D Matrix) containing all light field sub-aperture images.
%                   Using the output from 'genLfSequence'.
%
%   shiftMat   ---> (NxNx2 Matrix) containing shift amount relative to reference
%                   camera. This parameter is unique to a camera rig and needs
%                   to be modified when processing light-fields from a different rig.
%
%   depth      ---> Depth in meters. Specifies the depth plane that will be
%                   in focus. Depth is measured along the axis that runs from the
%                   camera and into the scene.
%
%   ------------------
%   Function Output
%   ------------------
%  
%   shiftedLightField ---> 4D Matrix containing shifted light field images
% 
%   deltaMat          ---> NxNx2 Matrix containing shifting amount relative to 
%                          reference camera when refocusing on a specific depth
% 
%   refocus           ---> Refocused image of a scene.




% Define Expression for Depth Parameter, d(z)
z = depth;
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));

% shifting amounts of all views for a given depth 
deltaMat = -1 * d.*shiftMat;

[length,width,~,numViews] = size(lightField);
m = sqrt(numViews);

refocus = zeros(length,width,3);

shiftedLightField = zeros(length,width,3,numViews);
index = 0;
for i=1:m
    for j=1:m
        index = index + 1;
%       shift each view 
%       imtranslate(im, [+right-left,+down-up])
        shiftedLightField(:,:,:,index) = double(imtranslate(lightField(:,:,:,index),[deltaMat(i,j,1),deltaMat(i,j,2)]));
%       accumulate all views
        refocus = refocus + shiftedLightField(:,:,:,index);
    end
end
refocus = refocus/numViews;
end
