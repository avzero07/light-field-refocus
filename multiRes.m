function depthmap = multiRes(lightField,center,shiftMat,zmin,zmax,depthRes,K,M)
    
%   shrink the image by a factor of 2^K -- get the coarsest depthmap
    IK = imresize(lightField, 1/2^K);
    ZK = getDepthmap(IK,center,shiftMat,zmin,zmax,depthRes);
%   delta z at the coarsest scale -- L = depthRes = 50
    deltaZK = (zmax - zmin)/depthRes;

%   upsampling current image 
    for k = (K-1):-1:0
        
        figure 
        imagesc(ZK);
        title(sprintf('multi resolution with k=%d',k+1));
        
        IK_1 = imresize(lightField, 1/2^k);
        ZK_1 = upsample(IK_1,ZK,M,deltaZK,center,shiftMat);
        ZK = ZK_1;
%   delta z for the other scales -- M = 2
        deltaZK = deltaZK/M;
    end

    depthmap = ZK;
end

