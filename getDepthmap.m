function depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes)

    [length,width,~,~] = size(lightField);

    depthSeq = linspace(zmin, zmax, depthRes);
   
    ZNCCs = zeros(length,width,depthRes);
    
%   depth z in [zmin, zmax]
    for i = 1 : depthRes
        z = depthSeq(i);
%       compute ZNCC for each sampled depth z
        ZNCCs(:,:,i) = getZNCC(lightField,center,z, shiftMat);
    end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

