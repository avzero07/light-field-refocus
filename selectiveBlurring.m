%% selectiveBlurring Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 30-Mar-2020
%% Changelog
% Version 0.1
% -- Initial Implementation
%
% To Do
% -----
% -- Set Defaults
% -- Cleanup
%% Implementation
function [blurredImage] = selectiveBlurring(img,imgDepth,numLevels,focusRange,upperFilt)
%SELECTIVEBLURRING Summary of this function goes here
%   Detailed explanation goes here

% Init
blurredImage = zeros(size(img));
sizeImg = size(img);

%% Levels and Dynamic Code
bins = 0:round((256)/numLevels):255;

numBinsBelow = length(bins(bins<focusRange(1)))-1;
if numBinsBelow==-1
    numBinsBelow = 0;
end
numBinsAbove = length(bins(bins>focusRange(2)));
if numBinsAbove==-1
    numBinsAbove = 0;
end

% Create ChooseFilt and Populate
chooseFilt = zeros(1,numLevels);
chooseFilt(numBinsBelow+1) = 1;

index = 2;
if numBinsAbove>0
    for i=numBinsBelow+2:numLevels
        chooseFilt(i) = index;
        index = index+1;
    end
    
elseif numBinsAbove==0
    for i=numBinsBelow+2:numLevels
        if chooseFilt(i)==0
            chooseFilt(i)= chooseFilt(i-1);
        end
    end
end

index = 2;
if numBinsBelow>0
    for i=numBinsBelow:-1:1
        chooseFilt(i) = index;
        index = index + 1;
    end
elseif numBinsBelow==0
    for i=numBinsBelow:-1:1
        if chooseFilt(i)==0
            chooseFilt(i)= chooseFilt(i+1);
        end
    end
end

%% Loop Through Pixels (2 Level)

% For 'n' Levels
filt = uint8(zeros(sizeImg(1),sizeImg(2),sizeImg(3),numLevels));
filtSize = 0.5:(upperFilt-0.5)/(numLevels-1):upperFilt;
%filtSize = logspace(log10(0.5),log10(upperFilt),numLevels);

for i=1:numLevels
    filt(:,:,:,i) = imgaussfilt(img,filtSize(chooseFilt(i)));
end

%% Loop To Fill Pixels
for i=1:sizeImg(1)
    for j=1:sizeImg(2)
        numBinsBelow = length(bins(bins<imgDepth(i,j)))-1;
        if numBinsBelow==-1
            numBinsBelow = 0;
        end
        
        location = numBinsBelow+1;
        blurredImage(i,j,:) = filt(i,j,:,location);
    end
end

% Just so That Final Output is Returned as uint8
blurredImage = uint8(blurredImage);

end

