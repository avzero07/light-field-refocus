function depthmap = getDepthmap2(lightFieldGray,center,shiftMat,zmin,zmax,depthRes)
    [width,length,~] = size(lightFieldGray);

    %depthSeq = linspace(zmin, zmax, depthRes);
    depthSeq = linspace(zmin, zmax, depthRes+1);
    %f = waitbar(0,'Start');
    ZNCCs = zeros(width,length,depthRes+1);
%   depth z in [zmin, zmax]
    for i =1:depthRes+1
        z = depthSeq(i);%depthSeq(i);
%       compute ZNCC for each sampled depth z
        temp = computeZNCC2(lightFieldGray, shiftMat, center,z);        
        ZNCCs(:,:,i) = temp;%getZNCC(lightField, center, z, shiftMat);
    end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = max(ZNCCs,[],3);%min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

