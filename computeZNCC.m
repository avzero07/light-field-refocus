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
function [znccForZ] = computeZNCC(lightFieldGray,shiftMat,refIndex,z,scale)
%COMPUTEZNCC Finds the ZNCC at Depth z
%   Detailed explanation goes here

%% Init
znccForZ = zeros(size(lightFieldGray,1),size(lightFieldGray,2)); %Generate a matrix to save ZNCC
refImg = double(lightFieldGray(:,:,:,refIndex));
refImgPad = padarray(refImg,[1 1],0,'both');%Pad zero first difference 1

% For Refocus
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

d = ((1/z)-(1/z0))/((1/z1)-(1/z0));

if(scale~=1)
    shiftMat = shiftMat*scale;
    refImg = imresize(refImg,scale); % Consider Changing Interpolation
    znccForZ = zeros(size(refImg,1),size(refImg,2));
end

%% Loop Through Light Field
index = 0;
for i=1:4
    for j=1:4
        index = index+1;
        % Skip when At RefIndex
        if(index==refIndex)
            continue;
        end
    
        % Pad Image to Be Compared
        img = double(imtranslate(lightFieldGray(:,:,index),[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)]));
        if(scale~=1)
            img = imresize(img,scale); % Consider Changing Interpolation
        end
        imgPad = padarray(img,[1 1],0,'both');
        
        % Loop Through Image for Neighborhood Operation
        for x=2:1:size(img,1)+1
            for y=2:size(img,2)+1
                
                % Neighborhood Matrices
                refImgNeigh = refImgPad(x-1:x+1,y-1:y+1);
                ImgNeigh = imgPad(x-1:x+1,y-1:y+1);
                
                % Normalize
                refImgIbar = refImgNeigh - mean(mean(refImgNeigh));
                ImgIbar = ImgNeigh - mean(mean(ImgNeigh));
                
                refImgIhat = refImgIbar/std(refImgIbar,1,'all');
                ImgIhat = ImgIbar/std(ImgIbar,1,'all');
                
                % Cross Correlation
                cc = refImgIhat.*ImgIhat;
                znccXY = sum(sum(cc));
                znccForZ(x-1,y-1) = znccForZ(x-1,y-1) + znccXY;
            end
        end
    end
end

% Divide by 15(28n+1)^2
znccForZ = znccForZ/(15*(3^2));

end

