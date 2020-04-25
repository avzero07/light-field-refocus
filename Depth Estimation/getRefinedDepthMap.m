function ZK_1 = getRefinedDepthMap(lightFieldGray,prevZ,delz,refIndex,shiftMat,zmin,M,z0,z1,arr_wid)
%GETREFINEDDEPTHMAP takes in an array of grayscale light fields of certain
%resolution and generates depthmap for that resolution
%
%   This function is different from getCoarseDepthMap function for having
%   different depth range for ZNCC evaluation for each pixel. In 
%   getCoarseDepthMap function, all pixels share the same depth range. This
%   function refines the depth estimation generated from the previous
%   coarser scale.
%
%   ------------------
%   Function Inputs
%   ------------------
%   lightFieldGray  -- (3D matrix) array of grayscale of light fields
%   prevZ           -- (2D matrix) depthmap generated in previous scale
%   refIndex        -- (int) the index of the reference 
%   shiftMat        -- (double) matrix of relativeshift disparity between 
%                       views, downscaled with image resolution reduction
%   zmin            -- (float) minimum depth
%   M               -- (int)depth map subresolution
%   z0              -- (float)the reference depth of light field
%   z1              -- (float)the chosen depth of light field
%   arr_wid         -- (int)the width of the camera array, 
%                       controls the looping through views
%   ------------------
%   Function Output
%   ------------------
%   ZK_1            -- (2D matrix)the depthmap at current resolution

%% Initialize   
    [width,length,numViews] = size(lightFieldGray);
    
    ZK_1 = zeros(width,length);
    
    IhatMat = zeros(3,3,width,length,numViews);
    %% Loop Through Light Field
    index = 0;
    for i=1:arr_wid
        for j=1:arr_wid
            index = index+1;

            img = double(lightFieldGray(:,:,index));
            % Pad zero around the images to solve boundary issues
            imgPad = padarray(img,[1 1],0,'both');

            % Loop Through Image for Neighborhood Operation
            for x=2:1:size(img,1)+1
                for y=2:size(img,2)+1

                    ImgNeigh = imgPad(x-1:x+1,y-1:y+1);
                    
                    % Normalize the neighborhood
                    ImgIbar = ImgNeigh - mean(mean(ImgNeigh));  
                    %Standardize the neighborhood
                    ImgIhat = ImgIbar/std(ImgIbar,1,'all');
                    IhatMat(:,:,x-1,y-1,index) = ImgIhat; 
                end
            end
        end
    end
    % Handle the possible nan-valued pixels in IhatMat
    IhatMat(isnan(IhatMat)) = 0;
    
    % Pad zero around the depthmap to solve boundary issues when fetching
    % neighborhood
    prevZ = padarray(prevZ,[1 1],0,'both');
%% Loop through image pixels to find the one maximizes the ZNCC    
    for x = 1:width
        for y = 1:length

            % Use prevZ to compute subPrevZ

            % Fetch a neighborhood of depth from prevZ
            subPrevZ = prevZ(round(x/2):round(x/2)+2,round(y/2):round(y/2)+2);
            % Use subPrrevZ to compute Depth Cube
            depthCube = zeros(3,3,M+1); % neighbor i, neighbor j, three depth level
            % Generate a list of depth candidates for current pixel
            for m = 0:1:M
                depthCube(:,:,m+1) = subPrevZ -(delz/2) + m*(delz/M);
            end

            depthList = unique(depthCube); % Filter out duplicate values
            depthList = depthList(depthList>zmin); % Filter out negative depths
            [len,~] = size(depthList);
            % ZNCC List
            znccList = zeros(1,len);
            % Loop through depth candidates
            for l=1:1:len
                z = depthList(l);
                % Calculate the shifting coefficient from depth z
                d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
                % Compute the local ZNCC for current pixel
                znccList(l) = computeZNCCLocal(IhatMat,shiftMat,refIndex,d,x,y,arr_wid);
            end

            %% Find maxZ
            [~,ind] = max(znccList);
            maxZxy = depthList(ind);
            ZK_1(x,y) = maxZxy;
        end
    end
end