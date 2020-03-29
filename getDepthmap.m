function depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes)
    [Y_NUM,X_NUM,~,~] = size(lightField);

    %depthSeq = linspace(zmin, zmax, depthRes);
    depthSeq = linspace(zmin, zmax, depthRes+1);
   
    %ZNCCs = zeros(length,width,depthRes);
    ZNCCs = zeros(Y_NUM,X_NUM,depthRes+1);
    
%   depth z in [zmin, zmax]
    for i =1:depthRes+1
        z = depthSeq(i);
%       compute ZNCC for each sampled depth z
        temp = getZNCC(lightField, center, z, shiftMat);
        ZNCCs(:,:,i) = temp;%getZNCC(lightField, center, z, shiftMat);
    end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = min(ZNCCs,[],3);%min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

