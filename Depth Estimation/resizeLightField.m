function [lightFieldRes] = resizeLightField(lightField,scale)
%resizeLightField takes an array of grayscale light field images and resize
%them according to the scale number. It provides an
%alternative to imresize when doing the image resolution downscaling, since
%it is using Gaussian pyramid reduction which is different.
%
%   ------------------
%   Function Inputs
%   ------------------
%   lightField      -- (3D matrix)A matrix that contains grayscale images for
%                   all views
%   scale           -- (int)The value controls the level of downscaling
%   ------------------
%   Function Output
%   ------------------
%   lightFieldRes   -- (2D matrix)A matrix that contains the downscaled
%                   image

%% Initialize
% Create a contained to save the downscaled images
lightFieldRes = uint8(zeros(size(lightField,1)/(2^scale),size(lightField,2)/(2^scale),size(lightField,3)));

%% Loop through all views
index=0;
for i=0:1:3
    for j=0:1:3
        index = index + 1;
        temp = lightField(:,:,index);
        % Downscale the original image for the times defined by scale
        for s = 1:scale
            temp = impyramid(temp,'reduce');
        end
        lightFieldRes(:,:,index) = temp;
    end
end

end

