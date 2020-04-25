function depthmap = getCoarseDepthmap(lightFieldGray,refIndex,shiftMat,zmin,zmax,depthRes,z0,z1,arr_wid)
%GETCOARSEDEPTHMAP takes in an array of lowest resolution grayscale light 
%fields and generates depthmap for the coarstest scale
%
%   ------------------
%   Function Inputs
%   ------------------
%   lightFieldGray  -- (3D matrix) an array of grayscale images for all
%                       view at the same frame
%   refIndex        -- (int) the index of the reference 
%   shiftMat        -- (double) matrix of relativeshift disparity between 
%                       views, downscaled with image resolution reduction
%   zmin            -- (float) minimum depth
%   zmax            -- (float) maximum depth
%   depthRes        -- (int)depth map resolution
%   z0              -- (float)the reference depth of light field
%   z1              -- (float)the chosen depth of light field
%   arr_wid         -- (int)the width of the camera array, 
%                       controls the looping through views 
%   ------------------
%   Function Output
%   ------------------
%   depthmap        -- (2D matrix) the depthmap at the coarsest resolution

%%  Initialize
    [width,length,numViews] = size(lightFieldGray);
    depthSeq = linspace(zmin, zmax, depthRes+1); %Generate depth candidates
    ZNCCs = zeros(width,length,depthRes+1);
%   IhatMat is the matrix for saving calculated zero-mean normalized pixel
%   intensities
    IhatMat = zeros(3,3,width,length,numViews);
    
%%  Loop Through Light Field Views to Calculate Ihat Values for Each View
    index = 0;
    for i=1:arr_wid
        for j=1:arr_wid
            index = index+1;
            img = double(lightFieldGray(:,:,index));
            % Pad zero around the images to solve boundary issues
            imgPad = padarray(img,[1 1],0,'both');

            % Loop Through Image Pixels for Neighborhood Operation
            % x is for row dimension and y is for colomn dimension
            for x=2:1:size(img,1)+1
                for y=2:size(img,2)+1
                    %Get the neighborhood of current pixel
                    ImgNeigh = imgPad(x-1:x+1,y-1:y+1);

                    % Normalize the neighborhood
                    ImgIbar = ImgNeigh - mean(mean(ImgNeigh));
                    % Standardize the neighborhood
                    ImgIhat = ImgIbar/std(ImgIbar,1,'all');
                    IhatMat(:,:,x-1,y-1,index) = ImgIhat; 
                end
            end
        end
    end
    % Handle the possible nan-valued pixels in IhatMat
    IhatMat(isnan(IhatMat)) = 0;
    % Permute the dimension orders for imtranslate operations
    % Order after permutation: ImageRow,ImageColomn,neighbor_i,neighbor_j,viewnumber
    IhatMat = permute(IhatMat,[3,4,1,2,5]);
%% Loop through all depth candidates to find the one maxmizes the ZNCC
%   depth z in [zmin, zmax]
    for i =1:depthRes+1
        z = depthSeq(i);
%       compute ZNCC for each sampled depth z
        ZNCCs(:,:,i) = computeZNCC(IhatMat, shiftMat, refIndex, z, z0, z1, arr_wid);
    end
%   for each pixel, find the index of the maximum in ZNCCs
    [~,index] = max(ZNCCs,[],3);%min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

