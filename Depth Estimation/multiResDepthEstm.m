function depthmap = multiResDepthEstm(lightFieldGray,refIndex,shiftMat,zmin,zmax,depthRes,K,M,z0,z1,arr_wid)
%MULTIRESDEPTHESTM takes in an matrix of grayscale light fields and generates depthmap
%   of the chosen reference view.
%
%   ------------------
%   Function Inputs
%   ------------------
%   lightFieldGray  -- (3D matrix) array of grayscale of light fields
%   refIndex        -- (int) the index of the reference 
%   shiftMat        -- (double) matrix of relativeshift disparity between 
%                       views
%   zmin            -- (float) minimum depth
%   zmax            -- (float) maximum depth
%   depthRes        -- (int)depth map resolution
%   K               -- (int)number of multiresolution
%   M               -- (int)subresolution of depth at higher resolution
%                       scales
%   z0              -- (float)the reference depth of light field
%   z1              -- (float)the chosen depth of light field
%   arr_wid         -- (int)the width of the camera array, 
%                       controls the looping through views 
%   ------------------
%   Function Output
%   ------------------
%   depthmap        -- (2D matrix)a matrix that contains depth value for
%                   each pixels in the referecen view
%

%%  Generate the depth esitimation for the coarset resoultuion
%   Shrink the image by a factor of 2^K -- get the coarsest depthmap
    IK = imresize(lightFieldGray, 1/2^K,'method','bilinear');
%   Generate the depthmap at the coarest scale    
    ZK = getCoarseDepthmap(IK, refIndex, shiftMat/(2^K), zmin, zmax, depthRes, z0, z1, arr_wid);
%   delta z at the coarsest scale 
    deltaZK = (zmax - zmin)/depthRes;

%%  Generate depth estimations for other higher resolutions
%   Reversely tranverse each resolution scale from coarse to fine
    for k = (K-1):-1:0 
%   Commented code is used to plot depthmap at different resolutions        
        %{
        figure 
        imshow(mat2gray(ZK));
        colormap jet;
        title(sprintf('multi resolution with k=%d',k+1));
        %}
%   Shrink the image by a factor of 2^k -- get the higher resolution images
        IK_1 = imresize(lightFieldGray, 1/2^k,'method','bilinear');
%   Upsample the depthmap generated from previous scale      
        ZK_1 = getRefinedDepthMap(IK_1,ZK,deltaZK,refIndex,shiftMat/(2^k),zmin,M,z0,z1,arr_wid);
        ZK = ZK_1;
%   delta z for the other scales -- M = 2
        deltaZK = deltaZK/M;
    end    
    depthmap = ZK;
end

