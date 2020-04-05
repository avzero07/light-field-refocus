function [depthMapMat] = computeDepthmaps(s,t,zmin,zmax,dRes,K,M,fSeq)
%COMPUTEDEPTHMAPS Summary of this function goes here
%   Detailed explanation goes here
frameLen = length(fSeq);
views = 16;
depthMapMat = zeros(1088,2048,frameLen);
prefix = "depthMap_";
suffix = ".png";
parfor f = 1:frameLen
    frameOfInterest = fSeq(f)-1;
    refIdx = 4*s+t+1;
    lightFieldGray = genLfSequenceGray("D:\EECE541\light-field_refocus2\light-field-refocus\Images-Frames\", "Painter_pr_00",views,frameOfInterest,'png');
    newshiftMat = changeBaseView(s,t);
    tic
    depthMap = multiRes(lightFieldGray,refIdx,newshiftMat,zmin,zmax,dRes,K,M,frameOfInterest);
    toc
    figure 
    imshow(mat2gray(depthMap));
    colormap jet;
    title(sprintf('depthMap for frame %d',frameOfInterest));
    depthMapMat(:,:,f) = depthMap;
    depthMapConv = uint8(255*mat2gray(depthMap));
    filename = prefix + string(frameOfInterest)+suffix;    
    imwrite(depthMapConv,filename,'png');

end
end

