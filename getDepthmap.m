function depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes,K)
    f = waitbar(0,'Start');
    [length,width,~,~] = size(lightField);

    depthSeq = linspace(zmin, zmax, depthRes+1);
    deltaDepth = round(abs(zmax-zmin)/depthRes);
   
    ZNCCs = zeros(length,width,depthRes+1);
    depthNum = depthRes+1;
%   depth z in [zmin, zmax]
   % for k = K+1 :-1:1
    %ZNCC = zeros(length,width,depthRes+1);
    for d =1:depthNum
        waitbar(d/depthNum,f,sprintf('depth=%d',d));
        z = depthSeq(d);
%       compute ZNCC for each sampled depth z
        ZNCCs(:,:,d) = getZNCC(lightField,center,z, shiftMat);
    end
    %end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

