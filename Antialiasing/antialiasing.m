function antialiasedRefocus = antialiasing(shiftedLightField,deltaMat,disparityMat)
% ANTIALIASING Obtains antialiased refocused image based on the disparity maps
% 
%   The function uses the shift and sum with local interpolation algorithm
%   based on disparity
% 
%   ------------------
%   Function Inputs
%   ------------------
%
%   ShiftedLightField  ---> (4D Matrix)Containing shifted light field images
%
%   deltaMat           ---> (NxNx2 Matrix) Containing shifting amount relative to 
%                           reference camera when refocusing on a specific depth
%
%   disparityMat       ---> (3D Matrix) Containing disparity maps for all views
%
%   ------------------
%   Function Output
%   ------------------
%  
%   antialiasedRefocus ---> Refocused image without aliasing.
    


    [length,width,~,numViews] = size(shiftedLightField);
    m = sqrt(numViews);
     
%    aliasing determination threshold, > T1 aliasing region
     T1 = 1; 
%    occlusion threshold, > T2 occlusion region
%    determined by the 97% percentiles of 'intenMat' and 'dispMat'
     T2_inten = 58;
     T2_disp = 17;
    
    antialiasedRefocus = zeros(length,width,3);
%   number of additions at each pixel
    count = zeros(length,width); 

%   compute diaparity between view(i,j) and its diagonally adjacent view(i+1,j+1)
    for i=1:m-1
        for j=1:m-1
            
%           index in light filed sequence
            index = (i-1)*m+j;
            next = ((i+1)-1)*m+(j+1);
            
%           original disparity map of view (i,j)
            dis_ori = disparityMat(:,:,index);
%           shift original disparity map as view (i,j) does 
            dis_shift = imtranslate(dis_ori,[deltaMat(i,j,1),deltaMat(i,j,2)]);

%           Y : left--right   minus relative shifting in y direction
            disY = dis_shift - (deltaMat(i+1,j+1,1) - deltaMat(i,j,1)); 
%           X : up--down      minus relative shifting in x direction
            disX = dis_shift - (deltaMat(i+1,j+1,2) - deltaMat(i,j,2)); 
             
%           original disparity map of view (i+1,j+1)
            dis_ori_next = disparityMat(:,:,next);
%           shift as view (i+1,j+1) does 
            dis_shift_next = imtranslate(dis_ori_next,[deltaMat(i+1,j+1,1),deltaMat(i+1,j+1,2)]);
            
%             % for determining the occlusion threshold
%             % intensity difference matrix beween shifted view (i,j) and (i+1,j+1)
%             intenMat = ones(length,width); 
%             % disparity difference matrix beween disparity map 'dis_shift' and 'dis_shift_next'
%             dispMat = ones(length,width);

            for x = 1:length
                for y = 1:width
%                   pixel (x,y) in shifted view (i,j)
%                   corresponding to disparity value (x,y) in shifted disparity map

%                   disparities in x and y directions
                    dx = disX(x,y);
                    dy = disY(x,y);
                    
%                   pixel (nextX,nextY) in next view (i+1,j+1) correspons to (x,y)
                    
%                   negative dx,dy -> right to (x,y)
%                   positive dx,dy -> left to (x,y)
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
                           
%                   disparity difference between disparity at (x,y) in shifted disaprity map(i,j) 
%                   and that at (nextX,nextY) in (i+1,j+1)
                    dispDiff = abs(dis_shift(x,y)-dis_shift_next(nextX,nextY));
                    
%                   intensity difference between intensity at (x,y) in shifted light field view(i,j) 
%                   and that at (nextX,nextY) in (i+1,j+1)
                    intenDiff = abs(rgb2gray(uint8(shiftedLightField(x,y,:,index)))-rgb2gray(uint8(shiftedLightField(nextX,nextY,:,next))));
                    
%                     % store in 'intenMat' and 'dispMat' to estimate the thresholds
%                     intenMat(x,y) = intenDiff;
%                     dispMat(x,y) = dispDiff;
                    
                    occ = 0;
%                   occulsion region
                    if dispDiff > T2_disp || intenDiff > T2_inten
                      occ = 1;
                    end
                    
                    if occ == 0 
%                     interpolate if in aliasing region
                      if abs(dx) > T1 || abs(dy) > T1
                        value_cur = shiftedLightField(x,y,:,index);
                        value_next = shiftedLightField(nextX,nextY,:,next);

                        values = interpolate(x,y,leftX, rightX, leftY, rightY,nextX,nextY,value_cur,value_next);
%                       accumulate interpolated values onto the refocused image
                        antialiasedRefocus(leftX:rightX,leftY:rightY,:) = antialiasedRefocus(leftX:rightX,leftY:rightY,:) + values;
%                       augment the number of additions in this region by 1
                        count(leftX:rightX,leftY:rightY) = count(leftX:rightX,leftY:rightY)+1;
 
                      else 
%                       only add original value if aliasing free
                        value = double(shiftedLightField(x,y,:,index));
                        antialiasedRefocus(x,y,:) = antialiasedRefocus(x,y,:) + value;
                        count(x,y) = count(x,y) + 1; 
                          
                      end
                    else
%                     accumulate repetitive values of (x,y) in occlusion region
                      value = double(shiftedLightField(x,y,:,index));
                      values = repmat(value,[rightX-leftX+1,rightY-leftY+1]);
                      antialiasedRefocus(leftX:rightX,leftY:rightY,:) = antialiasedRefocus(leftX:rightX,leftY:rightY,:) + values;
                      count(leftX:rightX,leftY:rightY) = count(leftX:rightX,leftY:rightY)+1;  
                    end
                    
                end
            end
%            % to compute the 97% percentiles of intensity diff and disparity diff as the thresholds
%            disp(prctile(intenMat,97,'all'));
%            disp(prctile(dispMat,97,'all'));
        end
    end
    
    
%   accumulate the marginal views
    i = m;
    for j=1:m
        index = (i-1)*m+j;
        antialiasedRefocus = antialiasedRefocus + shiftedLightField(:,:,:,index);
        count = count + 1;
    end
    j = m;
    for i=1:m-1
        index = (i-1)*m+j;
        antialiasedRefocus = antialiasedRefocus + shiftedLightField(:,:,:,index);
        count = count + 1;
    end
    
%   normalize
    antialiasedRefocus = antialiasedRefocus ./ count;


end