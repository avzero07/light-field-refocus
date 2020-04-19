% function value = interpolate(a,b,x,y,nextX,nextY,value1,value2)
%     dx = nextX - x;
%     dy = nextY - y;
%     
%     weight = ((a - x)^2 + (b - y)^2)/(dx^2 + dy^2);
%     weight = sqrt(weight);
%     
%     value = value1*(1-weight) + value2*weight;
%     
% end

function value = interpolate(x,y,leftX, rightX, leftY, rightY,nextX,nextY,value1,value2)
    
%   ly ly+1 ly+2...ry
%   ly ly+1 ly+2...ry
%   ...
    indexY = repmat(leftY:rightY,[rightX-leftX+1,1]);
%   lx   lx   lx...
%   lx+1 lx+1 lx+1...
%   ...
%   rx   rx    rx...
    indexX = transpose(repmat(leftX:rightX,[rightY-leftY+1,1]));

    distance = (nextX - x).^2 + (nextY -y)^2;
    cur = ((indexX - x).^2 + (indexY - y).^2);
   
    weight = sqrt(cur./distance);
   
    value = value1.*(1-weight) + value2.*weight;
    
end



