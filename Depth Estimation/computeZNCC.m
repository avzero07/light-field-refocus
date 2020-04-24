
%% Implementation
function [znccForZ] = computeZNCC(IhatMat,shiftMat,refIndex,z)
%COMPUTEZNCC Finds the ZNCC of the whole image at Depth z
%
%
%   ------------------
%   Function Inputs
%   ------------------
%   lightFieldGray  -- (3D matrix) a matrix of grayscale of light fields
%   IhatMat         -- (5D matrix) a matrix of Ihatvalues for every
%                       neighborhood of every pixel
%   refIndex        -- (int) the index of the reference 
%   shiftMat        -- (double) a matrix of relative shift disparity between 
%                       views, downscaled with image resolution reduction
%   z               -- (double)depth under estimation
%   ------------------
%   Function Output
%   ------------------
%   znccForZ        -- (2D matrix) a matrix of ZNCC value for all pixels in
%                       the reference view at depth z
%% Initialize
[width,length,~,~,~] = size(IhatMat);
%Generate a matrix to save ZNCC
znccForZ = zeros(width,length); 


% For Refocus
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));

%Get Ihat values for the reference view
refIhat = IhatMat(:,:,:,:,refIndex); % ImageRow,ImageColomn,neighbor_i,neighbor_j,viewNum
%Change the order of dimensions
refIhat2 = permute(refIhat,[3,4,1,2]); %neighbor_i,neighbor_j,imageRow,imageColomn

%% Loop Through Light Field
index = 0;
for i=1:4
    for j=1:4
        index = index+1;
        % Skip when At RefIndex
        if(index==refIndex)
            continue;
        end
        %Get Ihat values for current view       
        imgIhat = IhatMat(:,:,:,:,index); % ImageRow,ImageColomn,neighbor_i,neighbor_j

        %Translate the Ihat matrix according to the shifting amount, due to
        %the convention of imtranslate, make the shifting value have
        %opposite sign
        imgIhat = double(imtranslate(imgIhat,[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)])); 
        imgIhat2 = permute(imgIhat,[3,4,1,2]);%neighbor_i,neighbor_j,imageRow,imageColomn
        
        % Loop Through Pixels for Neighborhood Operation
        for x=1:width
            for y=1:length               
                
                refImgIhat = refIhat2(:,:,x,y);
                corImgIhat = imgIhat2(:,:,x,y);
                
                % Compute the cross correlation
                cc = refImgIhat.*corImgIhat;
                % Sum up all the values in the neighborhood
                znccXY = sum(sum(cc));
                znccForZ(x,y) = znccForZ(x,y) + znccXY;
            end
        end
    end
end

% Divide by 15(2n+1)^2 to get average
znccForZ = znccForZ/(15*(3^2));

end

