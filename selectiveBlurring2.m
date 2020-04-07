%% selectiveBlurring2 Function
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
function [blurredImage] = selectiveBlurring2(img,imgDepth,numLevels,focusRange,upperFilt)
%SELECTIVEBLURRING Summary of this function goes here
%   Detailed explanation goes here

% Init
blurredImage = zeros(size(img));
sizeImg = size(img);

%% Levels and Dynamic Code
uLimit = 90;
bins = linspace(0,double(uLimit),double(numLevels));

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
for j=numBinsBelow+2:(numLevels-numBinsAbove)
    chooseFilt(j)=1;
end

if((numBinsAbove~=0)||(numBinsBelow~=0))
    if(numBinsAbove~=0)
        for j=(numLevels-numBinsAbove)+1:numLevels
            chooseFilt(j) = chooseFilt(j-1)+1;
        end
    end
    
    if(numBinsBelow~=0)
        for j=numBinsBelow:-1:1
            chooseFilt(j) = chooseFilt(j+1)+1;
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

[~,loc] = max(chooseFilt);

for i=1:sizeImg(1)
    for j=1:sizeImg(2)
        
        if(imgDepth(i,j)>=uLimit)
            blurredImage(i,j,:) = filt(i,j,:,loc);
            continue
        end
        
        choosePix = length(bins(bins<imgDepth(i,j)))-1;
        if choosePix==-1
            choosePix = 0;
        end
        
        location = choosePix+1;
        blurredImage(i,j,:) = filt(i,j,:,location);
    end
end

% Just so That Final Output is Returned as uint8
blurredImage = uint8(blurredImage);
end

