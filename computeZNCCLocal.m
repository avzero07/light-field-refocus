%% computeZNCCLocal Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 02-Apr-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
function [minZuv] = computeZNCCLocal(lightFieldRes,refImageRes,refIndex,u,v,prevZ,delz,shiftMat)
%COMPUTEZNCCLOCAL Computes the Minimum Z at location (u,v) of Image K-1
%   Detailed explanation goes here

% NOTE: Assuming u and v are padding aware (starts from (2,2))

%% Init

% For Refocus
z0 = 100;   % Pre-Defined
z1 = 1.63;  % Pre-Defined

% Pad RefImage
refImageResPad = double(padarray(refImageRes,[1 1],'both'));

minZuv = 0;

% Use prevZ to compute subPrevZ

% Pad prevZ
prevZ = padarray(prevZ,[1 1],'both');
subPrevZ = prevZ(round(u/2)-1+1:round(u/2)+1+1,round(v/2)-1+1:round(v/2)+1+1);

% Use subPrrevZ to compute Depth Cube
depthCube = zeros(3,3,3);
depthCube(:,:,2) = subPrevZ;
depthCube(:,:,1) = subPrevZ-(delz/2);
depthCube(:,:,3) = subPrevZ+(delz/2);

depthList = unique(depthCube); % Returns List of Depths to Traverse Through
depthList = depthList(depthList>1.63); % Since 1.63 is least Depth

% ZNCC List
znccList = zeros(1,length(depthList));

%% Start

% Loop Through Each Depth
for l=1:1:length(depthList)
    
    z = depthList(l);
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    
    % Loop Through LightField
    index = 0;
    for i=1:1:4
        for j=1:1:4
            index = index + 1;
            if(index==refIndex)
                continue;
            end
            
            img = double(imtranslate(lightFieldRes(:,:,index),[-1*d*shiftMat(i,j,1),-1*d*shiftMat(i,j,2)]));
            imgPad = padarray(img,[1 1],'both');
            
            % Neighborhood Matrices
            refImgNeigh = refImageResPad(u-1+1:u+1+1,v-1+1:v+1+1); % Come up with better indexing
            ImgNeigh = imgPad(u-1+1:u+1+1,v-1+1:v+1+1);

            % Normalize
            refImgIbar = refImgNeigh - mean(mean(refImgNeigh));
            ImgIbar = ImgNeigh - mean(mean(ImgNeigh));

            refImgIhat = refImgIbar/std(refImgIbar,1,'all');
            ImgIhat = ImgIbar/std(ImgIbar,1,'all');

            % Cross Correlation
            cc = refImgIhat.*ImgIhat;
            znccXY = sum(sum(cc));
            znccList(l) = znccList(l) + znccXY;
        end
    end
end

%% Find minZ
[m,ind] = min(znccList);
minZuv = depthList(ind);

end

