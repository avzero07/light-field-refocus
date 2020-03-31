function depthmap = getDepthmap(lightField,center,shiftMat,zmin,zmax,depthRes)
    [width,length,~,numViews] = size(lightField);

    %depthSeq = linspace(zmin, zmax, depthRes);
    depthSeq = linspace(zmin, zmax, depthRes+1);
    %f = waitbar(0,'Start');
    %ZNCCs = zeros(length,width,depthRes);
    ZNCCs = zeros(width,length,depthRes+1);
    
    aveMat = zeros(width,length,numViews);
    stdMat = zeros(width,length,numViews);
    grayViews = zeros(width,length,numViews);
    for v = 1:numViews
        curView = rgb2gray(lightField(:,:,:,v));
        curView = double(curView);
        grayViews(:,:,v) = curView; 
        aveMat(:,:,v) = getAverage(curView);
        stdMat(:,:,v) = getstd(curView,aveMat(:,:,v));
    end
%   depth z in [zmin, zmax]
    for i =1:depthRes+1
        z = depthSeq(i);
%       compute ZNCC for each sampled depth z
        temp = getZNCC(grayViews, aveMat, stdMat, center, z, shiftMat);
        ZNCCs(:,:,i) = temp;%getZNCC(lightField, center, z, shiftMat);
        %waitbar(i/(depthRes+1),f,sprintf('i=%d',i));
    end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = min(ZNCCs,[],3);%min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

