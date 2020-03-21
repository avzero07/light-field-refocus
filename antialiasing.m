function [antialiasedRefocus, disparityMap, disX_hat, disY_hat] = antialiasing(shiftedLightField, lightField, deltaMat, arrayLength,arrayDepth)
% remove the aliasing to obtain the antialiased refocused image

% lightField -- 4D matrix of containing all sub-aperture images
% shiftedLightField -- shifted 4D matrix of containing all sub-aperture images
% deltaMat -- total shifting amount (-1*d(z)*shiftMat)
% arrayLength -- length of the camera array
% arrayDepth -- depth of the camera array

    antialiasedRefocus = zeros(129,129,3);%(1088,2048,3); %The empty canvas for accumulating calculated pixel views from all views
    count = zeros(129,129,3);%(1088,2048); % number of additions at each pixel
    disparityRange = [0,128];

    f = waitbar(0,'Start');

    % diaparity between camera (i,j) and camera (i+1, j+1)
    for i=1: arrayLength - 1  %Why arraylength - 1
        for j=1: arrayDepth - 1%Why arraydepth - 1


            index = indexconvertor(i,j,arrayLength); %Mapping view's position in array to its view number
            indexNext = indexconvertor(i+1,j+1,arrayLength);
            indexNextHoriz = indexconvertor(i,j+1,arrayLength);
            indexNextVert = indexconvertor(i+1,j,arrayLength);

            disparityMap = zeros(129,129,2);%(1088,2048,2);
             % calculate the diaparity map for original light field images
             % the returned disparity values are rounded to 1/16th pixel
             % elements that were not computed reliably are marked -> ?realmax('single')


            %current image
            curView = lightField(:,:,:,index);
            %diagonal neighbour
            nextView = lightField(:,:,:,indexNext);
            %rotated diagonal neighbour
            nextView_r = imrotate(lightField(:,:,:,indexNext),-90,'bilinear','loose');
            %horizontal neighbour
            nextViewHoriz = lightField(:,:,:,indexNextHoriz);
            %rotated current image
            curView_r = imrotate(curView,-90,'bilinear','loose');
            %rotated vertical neighbour
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

            %current image with diagonal neighbour
            %disparityMap(:,:,1)= disparityBM(rgb2gray(curView), rgb2gray(nextView), 'DisparityRange',disparityRange);

            %rotated current image with rotated diagonal neighbour
            %disparityMap(:,:,2) = transpose(disparityBM(rgb2gray(curView_r), rgb2gray(nextView_r), 'DisparityRange',disparityRange));


            %current image with horizontal neighbour
            disparityMap(:,:,1) = disparityBM(rgb2gray(curView(300:428,300:428,:)), rgb2gray(nextViewHoriz(300:428,300:428,:)), 'DisparityRange',disparityRange);

            %rotated current image with rotated vertical neighbour
            disparityMap(:,:,2) = transpose(disparityBM(rgb2gray(curView_r(300:428,300:428,:)), rgb2gray(nextViewVert(300:428,300:428,:)), 'DisparityRange',disparityRange));


            disX = disparityMap(:,:,1);
            disX(isnan(disX)) = 0;
            disY = disparityMap(:,:,2);
            disY(isnan(disY)) = 0;

            % shift the disparty map + difference of shifting amounts
            disX_hat = imtranslate(disX,[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,1) - deltaMat(i,j,1);
            disY_hat = imtranslate(disY,[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,2) - deltaMat(i,j,2);

            [n,m] = size(disX_hat);
            for x = 1:n
                for y = 1:m

                    dx = disX_hat(x,y);
                    dy = disY_hat(x,y);

                    rightX = min(round(x+dx),n);
                    rightY = min(round(y+dy),m);

                    for a = x : rightX
                        for b = y : rightY

                            waitbar(x*y*i*j/n/m/arrayLength/arrayDepth,f,sprintf('i=%d, j=%d, x =%d, y=%d, a=%d, b=%d',i,j,x,y,a,b));

                            % use original values if aliasing free
                            rf = double(shiftedLightField(x,y,:,index));

                            % use interpolated values if in aliasing region
                            if dx > 1 || dy > 1
                                value1 = shiftedLightField(x,y,:,index);
                                value2 = shiftedLightField(rightX,rightY,:,indexNext);
                                rf = interpolate(a,b,x,y,rightX,rightY,value1,value2);
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
    close(f);
end