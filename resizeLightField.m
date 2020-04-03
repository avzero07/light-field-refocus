function [lightFieldRes] = resizeLightField(lightField,scale)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

lightFieldRes = uint8(zeros(size(lightField,1)*scale,size(lightField,2)*scale,1,size(lightField,4)));

index=0;
for i=0:1:3
    for j=0:1:3
        index = index + 1;
        lightFieldRes(:,:,1,index) = imresize(lightField(:,:,:,index),scale);
    end
end

end

