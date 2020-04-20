function antialiasedRefocus = antialiasing3(shiftedLightField,lightField,center,deltaMat,disparityMat,xRange,yRange)
% shift and sum + local interpolation to obtain the antialiased refocused image

    [length,width,~,numViews] = size(lightField);
     m = sqrt(numViews);
     
%    interpolation threshold, > T1 do interpolation
     T1 = 1; 
%    occlusion threshold, > T2 don't do interpolation
     T2 = 100;
    
    
    antialiasedRefocus = zeros(length,width,3);
%   number of additions at each pixel
    count = zeros(length,width); 

%   compute diaparity between view(i,j) and diagonally adacent view(i+1,j+1)
    for i=1:m-1
        for j=1:m-1           
            
            index = indexconvertor(i,j,m);
            next = indexconvertor(i+1,j+1,m);
            
%           current disparity to next view
%                   *  (i,j) --- disX = d-?x
%                      * (i+1,j+1) 
%           left--right
            disX = disparityMat(:,:,index) - (deltaMat(i+1,j+1,1) - deltaMat(i,j,1));% minus shifting

%           up--down
            disY = disparityMat(:,:,index) - (deltaMat(i+1,j+1,2) - deltaMat(i,j,2));
 
            
            for x = xRange
                for y = yRange

                    dx = disX(x,y);
                    dy = disY(x,y);
                    
%                   negative -> right
%                   positive -> left
                    if (dx < 0) 
                        rightX = min(round(x-dx),length);
                        leftX = x;
                        nextX = rightX;
                    else
                        leftX = max(round(x-dx),1);
                        rightX = x;
                        nextX = leftX;
                    end
                        
                    if (dy < 0) 
                        rightY = min(round(y-dy),width);
                        leftY = y;
                        nextY = rightY;
                    else
                        leftY = max(round(y-dy),1);
                        rightY = y;
                        nextY = leftY;
                    end
                    
                     % interpolate if in aliasing region
                    if (abs(dx) > T1 && abs(dx) < T2) || (abs(dy) > T1 && abs(dy) < T2)
                        value1 = shiftedLightField(x,y,:,index);
                        value2 = shiftedLightField(nextX,nextY,:,next);

                        value = interpolate(x,y,leftX, rightX, leftY, rightY,nextX,nextY,value1,value2);
                          
                        antialiasedRefocus(leftX:rightX,leftY:rightY,:) = antialiasedRefocus(leftX:rightX,leftY:rightY,:) + value;
                        count(leftX:rightX,leftY:rightY) = count(leftX:rightX,leftY:rightY)+1;
                        
                    elseif abs(dx) <= T1 && abs(dy) <= T1
                        % use original values if aliasing free
                        rf = double(shiftedLightField(x,y,:,index));
                        antialiasedRefocus(x,y,:) = antialiasedRefocus(x,y,:) + rf;
                        count(x,y) = count(x,y) + 1; 
                    
                    % else occlusion region, no addition
                    end
                end
           end
        end
    end
    
%   normalize
    antialiasedRefocus = antialiasedRefocus ./ count;


end