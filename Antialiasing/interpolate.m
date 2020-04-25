function value = interpolate(x,y,leftX, rightX, leftY, rightY,nextX,nextY,value1,value2)
% INTERPOLATION Obtains interpolated value from value1 and value2
% 
%   The function uses a linear weighted interpolation to compute the values 
%   in the range of x_ in [leftX, rightX], y_ in [leftY, rightY]
% 
%   ------------------
%   Function Inputs
%   ------------------
%
%   (x,y)          ---> Index of the first pixel
% 
%   (nextX,nextY)  ---> Index of the second pixel
% 
%   value1         ---> RGB value of the first pixel
% 
%   value2         ---> RGB value of the second pixel
%
%   [leftX,rightX] ---> X range of a local region 
% 
%   [leftY,rightY] ---> Y range of a local region 
% 
% 
%   ------------------
%   Function Output
%   ------------------
%  
%   value ---> (3D matrix) Containing interpolated values in this region.




%   y : left-right

%   ly ly+1 ly+2...ry
%   ly ly+1 ly+2...ry
%   ...

%   y index matrix
    indexY = repmat(leftY:rightY,[rightX-leftX+1,1]);
    
%   x : up-down

%   lx   lx   lx...
%   lx+1 lx+1 lx+1...
%   ...
%   rx   rx    rx...

%   x index matrix
    indexX = transpose(repmat(leftX:rightX,[rightY-leftY+1,1]));

%   squared distance between two pixels
    distance = (nextX - x).^2 + (nextY -y)^2;
%   squared distances of all positions in this region
    cur = ((indexX - x).^2 + (indexY - y).^2);
   
%   weighting factor
    weight = sqrt(cur./distance);
    
%   linear interpolation
    value = value1.*(1-weight) + value2.*weight;
    
end



