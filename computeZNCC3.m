%% computeZNCC Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 01-Apr-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
function [znccForZ] = computeZNCC3(lightFieldGray,shiftMat,refIndex,z,IhatMat)
%COMPUTEZNCC Finds the ZNCC at Depth z
%   Detailed explanation goes here

%% Init
[width,length,~,~,~] = size(IhatMat);
znccForZ = zeros(width,length); %Generate a matrix to save ZNCC


% For Refocus
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
%{
IhatMat = zeros(3,3,size(lightFieldGray,1),size(lightFieldGray,2),16);
%% Loop Through Light Field
index = 0;
%f = waitbar(0,'Start'); 
for i=1:4
    for j=1:4
        %waitbar(((i-1)*4+j)/16,f,sprintf('i=%d,j=%d',i,j));
        index = index+1;

        img = double(lightFieldGray(:,:,index)); 
        imgPad = padarray(img,[1 1],0,'both');
        
        % Loop Through Image for Neighborhood Operation
        for x=2:1:size(img,1)+1
            for y=2:size(img,2)+1
                
                ImgNeigh = imgPad(x-1:x+1,y-1:y+1);
                
                % Normalize
                ImgIbar = ImgNeigh - mean(mean(ImgNeigh));                
                ImgIhat = ImgIbar/std(ImgIbar,1,'all');
                IhatMat(:,:,x-1,y-1,index) = ImgIhat; 
            end
        end
    end
end
%IhatMat(isnan(IhatMat)) = 0;
%IhatMat(isinf(IhatMat)) = realmax(class(IhatMat));
IhatMat2 = permute(IhatMat,[3,4,1,2,5]); % ImageRow,ImageColomn,neighbor_i,neighbor_j,viewnumber
%}
refIhat = IhatMat(:,:,:,:,refIndex); % ImageRow,ImageColomn,neighbor_i,neighbor_j
refIhat2 = permute(refIhat,[3,4,1,2]); %neighbor_i,neighbor_j,imageRow,imageColomn

%% Loop Through Light Field
index = 0;
for i=1:4
    for j=1:4
        index = index+1;
        % Skip when At RefIndex
        if(index==refIndex)
            continue;
        end
        imgIhat = IhatMat(:,:,:,:,index); % ImageRow,ImageColomn,neighbor_i,neighbor_j
        % Pad Image to Be Compared
        imgIhat = double(imtranslate(imgIhat,[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)])); % ImageRow,ImageColomn,neighbor_i,neighbor_j
        imgIhat2 = permute(imgIhat,[3,4,1,2]);%neighbor_i,neighbor_j,imageRow,imageColomn
        
        % Loop Through Image for Neighborhood Operation
        for x=1:width
            for y=1:length               
                
                refImgIhat = refIhat2(:,:,x,y);
                corImgIhat = imgIhat2(:,:,x,y);
                
                % Cross Correlation
                cc = refImgIhat.*corImgIhat;
                znccXY = sum(sum(cc));
                znccForZ(x,y) = znccForZ(x,y) + znccXY;
            end
        end
    end
end

% Divide by 15(28n+1)^2
znccForZ = znccForZ/(15*(3^2));

end

