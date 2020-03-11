function [antialiasedRefocus, dis, disX, disY] = antialiasing(shiftedLightField, lightField, deltaMat, arrayLength,arrayDepth)
% remove the aliasing to obtain the antialiased refocused image

% lightField -- 4D matrix of containing all sub-aperture images 
% shiftedLightField -- shifted 4D matrix of containing all sub-aperture images 
% deltaMat -- total shifting amount (-1*d(z)*shiftMat)
% arrayLength -- length of the camera array
% arrayDepth -- depth of the camera array

    antialiasedRefocus = zeros(1088,2048,3); %The empty canvas for accumulating calculated pixel views from all views
    count = zeros(1088,2048); % number of additions at each pixel
    disparityRange = [0,128];
    % diaparity between camera (i,j) and camera (i+1, j+1)
    for i=1: arrayLength  %Why arraylength - 1
        for j=1: arrayDepth%Why arraydepth - 1
            index = indexconvertor(i,j,arrayLength); %Mapping view's position in array to its view number
            indexNext = indexconvertor(i+1,j+1,arrayLength);
            indexNextHoriz = indexconvertor(i,j+1,arrayLength);
            indexNextVert = indexconvertor(i+1,j,arrayLength);
            disparityMap = zeros(1088,2048,2);
             % calculate the diaparity map for original light field images
             % the returned disparity values are rounded to 1/16th pixel
             % elements that were not computed reliably are marked -> ?realmax('single')
             
            % dis = RGBdisparity(lightField(:,:,:,index)), lightField(:,:,:,indexNext));
            curView = lightField(:,:,:,index);
            nextView = imrotate(lightField(:,:,:,indexNext),-90,'bilinear','loose');
            nextView_r = lightField(:,:,:,indexNext);
            nextViewHoriz = lightField(:,:,:,indexNextHoriz);
            curView_r = imrotate(curView,-90,'bilinear','loose');
            nextViewVert = imrotate(lightField(:,:,:,indexNextVert),-90,'bilinear','loose');
            %{
            subplot(2,2,1)
            imshow(curView)
            subplot(2,2,2)
            imshow(nextViewHoriz)
            subplot(2,2,3)
            imshow(nextViewVert)
            subplot(2,2,4)
            imshow(nextView)
            %}
            %dis_x 
            disparityMap(:,:,1)= disparityBM(rgb2gray(curView), rgb2gray(nextView), 'DisparityRange',disparityRange);
            %dis_y 
            disparityMap(:,:,2) = transpose(disparityBM(rgb2gray(curView_r), rgb2gray(nextView_r), 'DisparityRange',disparityRange));
            %dis = disparity(rgb2gray(curView), rgb2gray(nextView), 'DisparityRange',disparityRange); 
            % dis(dis == -1 * realmax('single')) = 0;
            
            % shift the disparty map + difference of shifting amounts 
            disX_hat = imtranslate(disparityMap(:,:,1),[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,1) - deltaMat(i,j,1);
            disY_hat = imtranslate(disparityMap(:,:,2),[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,2) - deltaMat(i,j,2);
       
            [n,m] = size(disX);
            for x = 1:n
                for y = 1:m
                    % choose dx and dy of the rgb channel with maximum disparity
                    % dx = max(disX(x,y,:)); 
                    % dy = max(disY(x,y,:));
                    
                    dx = disX(x,y);
                    dy = disY(x,y);
                    
                    for a = x : min(x+dy,n)
                        for b = y : min(y+dy,m)

                            % use original values if aliasing free
                            rf = double(shiftedLightField(x,y,:,index));

                            % use interpolated values if in aliasing region 
                            if dx > 1 || dy > 1
                                % rf = interpolate(x,y,i,j,dx,dy); 
                            end 
                            
                            % sum up
                            antialiasedRefocus(a,b,:) = antialiasedRefocus(a,b,:) + rf;
                            count(a,b) = count(a,b) + 1;
                        end
                    end
                end
            end
        end
    end
    
    % normalize
    antialiasedRefocus = antialiasedRefocus ./ count;
end
