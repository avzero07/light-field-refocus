function [average, std] = getAveAndStd(image)
%GETAVERAGE Summary of this function goes here
%   Detailed explanation goes here
%   local average of view in a 3 by 3 squared neighborhood
    [width,length] = size(image);
    image_pad = padarray(image,[1 1],0,'both');
    %image_pad = padarray(image,[1 1],'symmetric','both');
    ave_temp = conv2(image_pad, ones(3,3)/9,'same');
    average = ave_temp(2:width+1,2:length+1);
    Ibar_pad = image_pad - ave_temp;
    std_temp = stdfilt(Ibar_pad);
    std = std_temp(2:width+1,2:length+1);    
end

