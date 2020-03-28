function depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes)
    [length,width,~,~] = size(lightField);

    depthSeq = linspace(zmin, zmax, depthRes);
    %linspace(zmin, zmax, depthRes+1);
   
    ZNCCs = zeros(length,width,depthRes);%zeros(length,width,depthRes+1);
    %depthNum = depthRes+1;
    
%   depth z in [zmin, zmax]
    for d =1:depthRes
        z = depthSeq(d);
%       compute ZNCC for each sampled depth z
        ZNCCs(:,:,d) = getZNCC(lightField,center,z, shiftMat);
    end
    %end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

