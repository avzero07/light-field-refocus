function [znccForZ] = computeZNCCLocal(IhatMat,shiftMat,refIndex,d,x,y,arr_wid)
%COMPUTEZNCCLocal Finds the local ZNCC of the a specific pixel at Depth z
%
%   ------------------
%   Function Inputs
%   ------------------
%   IhatMat         -- (5D matrix) matrix of Ihatvalues for every
%                       neighborhood of every pixel
%   refIndex        -- (int) the index of the reference 
%   shiftMat        -- (double) matrix of relativeshift disparity between 
%                       views, downscaled with image resolution reduction
%   d               -- (double)image shifting factor, controls the shifting
%                       amount, decided by depth z
%   x               -- (int) row index of the pixel under evaluation
%   y               -- (int) colomn index of the pixel under evaluation
%   arr_wid         -- (int)the width of the camera array, 
%                       controls the looping through views
%   ------------------
%   Function Output
%   ------------------
%   znccForZ        -- (float) the zncc value at a certain pixel in the
%                       reference view at the given depth

%% Initialization
znccForZ = 0;

%Get Ihat values for a specific pixel in the reference view
refImgIhat = IhatMat(:,:,x,y,refIndex);
[~,~,w,l,~] = size(IhatMat);
index = 0;
ZNCC = zeros(3,3);

%% Loop through light field views
for i=1:1:arr_wid
    for j=1:1:arr_wid
        index = index + 1;
        % Skip when At RefIndex
        if(index==refIndex)
            continue;
        end
        
        % Calculate corresponding pixel position in the other view
        % according to the shifting amount calculated
        x_cor = round(x + d*shiftMat(i,j,2));%Row number vertical
        y_cor = round(y + d*shiftMat(i,j,1));%Colom number horizonal  

        % Handle the out of boundary issue for calculated coordinates
        if  x_cor > 0 && y_cor > 0 && x_cor < w+1 && y_cor < l+1 
            corImgIhat = IhatMat(:,:,x_cor,y_cor,index);
        else
            corImgIhat = zeros(3,3);
        end
        % Compute the cross correlation
        ZNCC = ZNCC + refImgIhat.*corImgIhat;
    end
end
ZNCC = sum(sum(ZNCC));
% Divide by 15*(2n+1)^2 to get average of cross correlation
znccForZ = ZNCC/(double(arr_wid^2-1)*(3^2));
end

