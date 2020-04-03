function [znccForZ] = computeZNCCLocal2(IhatMat,shiftMat,refIndex,d,x,y)
%COMPUTERZNCCLOCAL2 Summary of this function goes here
%   Detailed explanation goes here
znccForZ = 0;
%refIhat = IhatMat(:,:,:,:,refIndex); %neighbor_i,neighbor_j,imageRow,imageColomn
%refIhat2 = permute(refIhat,[3,4,1,2]); %neighbor_i,neighbor_j,imageRow,imageColomn
refImgIhat = IhatMat(:,:,x,y,refIndex);
[~,~,w,l,~] = size(IhatMat);
index = 0;
ZNCC = zeros(3,3);
for i=1:1:4
    for j=1:1:4
        index = index + 1;
        if(index==refIndex)
            continue;
        end
        x_cor = round(x + d*shiftMat(i,j,2));%Row number vertical
        y_cor = round(y + d*shiftMat(i,j,1));%Colom number horizonal
        %imgIhat = IhatMat(:,:,:,:,index); %neighbor_i,neighbor_j,imageRow,imageColomn         
        %imgIhat = double(imtranslate(imgIhat,[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)])); % ImageRow,ImageColomn,neighbor_i,neighbor_j
        %imgIhat2 = permute(imgIhat,[3,4,1,2]);%neighbor_i,neighbor_j,imageRow,imageColomn      

        if  x_cor > 0 && y_cor > 0 && x_cor < w+1 && y_cor < l+1 
            corImgIhat = IhatMat(:,:,x_cor,y_cor,index);
        else
            corImgIhat = zeros(3,3);
        end
        % Cross Correlation
        ZNCC = ZNCC + refImgIhat.*corImgIhat;
    end
end
ZNCC = sum(sum(ZNCC));
znccForZ = ZNCC/(15*(3^2));
end

