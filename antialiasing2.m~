function antialiasedRefocus = antialiasing2(shiftedLightField,lightField,center,deltaMat,disparity,xRange,yRange)
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

%   compute diaparity between view(i,j) and central view(2,2)
    for i=1:m
        for j=1:m           
            
            index = indexconvertor(i,j,m);
            
%           disparity to central view 

%                   *  -(d-?x) 
%                      c
%                         *   d-?x 
%                            *   2(d-?x)
%           left--right
            disX = (j-2) * disparity - deltaMat(i,j,1);% minus shifting
%           up--down
            disY = (i-2) * disparity - deltaMat(i,j,2);
              
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
                    if (abs(dx) > T1*(j-2) && abs(dx) < T2*(j-2)) || (abs(dy) > T1*(i-2) && abs(dy) < T2*(i-2))
                          value1 = shiftedLightField(x,y,:,center);
                          value2 = shiftedLightField(nextX,nextY,:,index);

                          value = interpolate(x,y,leftX, rightX, leftY, rightY,nextX,nextY,value1,value2);
                          
                          antialiasedRefocus(leftX:rightX,leftY:rightY,:) = antialiasedRefocus(leftX:rightX,leftY:rightY,:) + value;
                          count(leftX:rightX,leftY:rightY) = count(leftX:rightX,leftY:rightY)+1;
                        
                    elseif abs(dx) <= T1*(j-2) && abs(dy) <= T1*(i-2)
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