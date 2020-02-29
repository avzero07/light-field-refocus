function disparityMap = RGBdisparity(I1,I2)
    [n,m,~] = size(I1);
    disparityMap = zeros(n,m,3);
    for i=1:3
        disparityMap(:,:,i) = disparity(I1(:,:,i), I2(:,:,i));
    end 
end 