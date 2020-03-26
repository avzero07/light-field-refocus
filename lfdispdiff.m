function dispDiffMat = lfdispdiff(dispmap,index_u,index_v)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dhatx_curr = dispmap(:,:,index_u,index_v,1);
dhaty_curr = dispmap(:,:,index_u,index_v,2);
dhatx_next = dispmap(:,:,index_u+1,index_v+1,1);
%dhaty_next = dispmap(:,:,index_u+1,index_v+1,2);
[m,n] = size(dhatx_curr);
dispDiffMat = zeros(m,n);
for x = 1:m
    for y = 1:n
        x2 = min(round(x+dhatx_curr(x,y)),m);
        y2 = min(round(y+dhaty_curr(x,y)),n);
        dispdiff_temp = abs(dhatx_curr(x,y)-dhatx_next(x2,y2));
        dispDiffMat(x,y) = dispdiff_temp;
    end
end
end

