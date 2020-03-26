function [disparityMap] = lfdisparity(lightField, arrayLength, arrayDepth,deltaMat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    dim = size(lightField);
    disparityMap = zeros(dim(1),dim(2),arrayLength-1,arrayDepth-1,2);
    dim2 = size(disparityMap)
    disparityRange = [0,112];
    for i=1: arrayLength - 1  %Why arraylength - 1
        for j=1: arrayDepth - 1%Why arraydepth - 1
            index = indexconvertor(i,j,arrayLength); %Mapping view's position in array to its view number
            %indexNext = indexconvertor(i+1,j+1,arrayLength);
            indexNextHoriz = indexconvertor(i,j+1,arrayLength);
            indexNextVert = indexconvertor(i+1,j,arrayLength);
            
            %current image
            curView = lightField(:,:,:,index);
            %diagonal neighbour
            %nextView = lightField(:,:,:,indexNext);
            %horizontal neighbour
            nextViewHoriz = lightField(:,:,:,indexNextHoriz);
            %rotated current image
            curView_r = imrotate(curView,90,'bilinear','loose');
            %rotated vertical neighbour
            nextViewVert = imrotate(lightField(:,:,:,indexNextVert),90,'bilinear','loose');
            
            %current image with horizontal neighbour
            disX = disparityBM(rgb2gray(curView), rgb2gray(nextViewHoriz), 'DisparityRange',disparityRange,'ContrastThreshold',0.7);
            %{
            figure 
            imshow(disX,disparityRange);
            title('Disparity Map X');
            colormap jet 
            colorbar
            %}
            %rotated current image with rotated vertical neighbour
            temp_dis_y = disparityBM(rgb2gray(curView_r), rgb2gray(nextViewVert),'DisparityRange',disparityRange,'ContrastThreshold',0.7);
            disY = imrotate(temp_dis_y,-90,'bilinear','loose');          
            %{
            figure 
            imshow(disY,disparityRange);
            title('Disparity Map Y');
            colormap jet 
            colorbar
            %}
            disX(isnan(disX)) = 0;
            disY(isnan(disY)) = 0;

            % shift the disparty map + difference of shifting amounts
            disX_hat = imtranslate(disX,[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,1) - deltaMat(i,j,1);
            disY_hat = imtranslate(disY,[deltaMat(i,j,1),deltaMat(i,j,2)]) + deltaMat(i+1,j+1,2) - deltaMat(i,j,2);
            
            disparityMap(:,:,i,j,1) = disX_hat;
            disparityMap(:,:,i,j,2) = disY_hat;
        end
    end
end

