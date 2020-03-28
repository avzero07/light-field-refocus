function [antialiasedRefocus,disX_hat, disY_hat] = antialiasing(shiftedLightField, lightField, deltaMat, disparityMap, arrayLength, arrayDepth)
% remove the aliasing to obtain the antialiased refocused image

% lightField -- 4D matrix of containing all sub-aperture images
% shiftedLightField -- shifted 4D matrix of containing all sub-aperture images
% deltaMat -- total shifting amount (-1*d(z)*shiftMat)
% disparityMap -- the local disparity map of each translated view
% arrayLength -- length of the camera array
% arrayDepth -- depth of the camera array

    antialiasedRefocus = zeros(1088,2048,3); %The empty canvas for accumulating calculated pixel views from all views
    count = zeros(1088,2048); % number of additions at each pixel
    disparityRange = [0,112];

    f = waitbar(0,'Start');

    % diaparity between camera (i,j) and camera (i+1, j+1)
    for i=1: arrayLength - 1
        for j=1: arrayDepth - 1


            index = indexconvertor(i,j,arrayLength); %Mapping view's position in array to its view number
            indexNext = indexconvertor(i+1,j+1,arrayLength);

             % calculate the diaparity map for original light field images
             % the returned disparity values are rounded to 1/16th pixel
             % elements that were not computed reliably are marked -> ?realmax('single')
            disX_hat = disparityMap(:,:,i,j,1);
            disY_hat = disparityMap(:,:,i,j,2);
            intensDiff = lfintensity(shiftedLightField(:,:,:,index),shiftedLightField(:,:,:,indexNext),disX_hat,disY_hat);
            %Y = prctile(IntensMat,97,'all'); %Percentile 97->100
            dispDiff = lfdispdiff(disparityMap,i,j);
            [n,m] = size(disX_hat);
            T1 = 100;
            T2 = 58;
            T3 = 1; 
            for x = 1:n
                for y = 1:m
                    O = 0;
                    dx = disX_hat(x,y);
                    dy = disY_hat(x,y);

                    rightX = min(round(x+dx),n);
                    rightY = min(round(y+dy),m);
                    intens_d = intensdiff(x,y);
                    if i < arrrayLenth-1 && j < arrayDepth-1
                        disp_d = dispDiff(x,y);
                        if intens_d >= T1 || disp_d >= T2
                            O = 1;
                        else
                            O = 0;
                        end
                    else
                        if intens_d >= T1
                            O = 1;
                        else
                            O = 0;
                        end
                    end
                    for a = x : rightX
                        for b = y : rightY

                            waitbar(x*y*i*j/n/m/arrayLength/arrayDepth,f,sprintf('i=%d, j=%d, x =%d, y=%d, a=%d, b=%d',i,j,x,y,a,b));
                            
                            % use original values if aliasing free
                            rf = double(shiftedLightField(x,y,:,index));
                            if O ~= 1
                                % use interpolated values if in aliasing region
                                if dx > T3 || dy > T3
                                    value1 = shiftedLightField(x,y,:,index);
                                    value2 = shiftedLightField(rightX,rightY,:,indexNext);
                                    rf = interpolate(a,b,x,y,rightX,rightY,value1,value2);
                                end
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