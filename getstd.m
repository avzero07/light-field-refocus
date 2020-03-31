function std = getstd(image,average)
%GETSTD Summary of this function goes here
%   Detailed explanation goes here
    Ibar = image-average;
    std = stdfilt(Ibar);
end

