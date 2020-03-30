%% Selective Refocus based on Depth
% Main Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 30-March-2020
%% Start
clc;
clear variables;
close all;
%% Load Images
img = imread('Sample-Depth\painter.png');
imgDepth = imread('Sample-Depth\painterDepth.png');
numLevels = 20;

sizeImg = size(img);
upperFilt = 20;
focusRange = [160 180];


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
result = zeros(960,1280,3);

% For 'n' Levels
filt = uint8(zeros(sizeImg(1),sizeImg(2),sizeImg(3),numLevels));
filtSize = 0.5:(upperFilt-0.5)/(numLevels-1):upperFilt;

filt(:,:,:,1) = img;
for i=2:numLevels
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
        result(i,j,:) = filt(i,j,:,location);
    end
end

%% Plot
figure,
subplot(1,2,1), imshow(img,[])
subplot(1,2,2), imshow(uint8(result),[])