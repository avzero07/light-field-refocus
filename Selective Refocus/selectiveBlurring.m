%% selectiveBlurring Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v1.0
% @date     - 30-Mar-2020
%% Changelog
% Version 1.0
% -- GA Implementation
%
%% Implementation
function [blurredImage] = selectiveBlurring(img,imgDepth,numLevels,focusRange,upperFilt)
%SELECTIVEBLURRING Selectively blurs an input image.
%
% This function selectively blurs an input image. Pixels at depths within
% the 'focusRange' are not blurred and remain in focus. Other pixels are
% blurred using gaussian filters of different sizes.
%
%   ------------------
%   Function Inputs
%   ------------------
%   
%   img         ---> RGB Input Image (uint8 datatype) that is to be selectively blurred
%
%   imgDepth    ---> Grayscale Depthmap Image (uint8 datatype) image
%                    corresponding to the Input Image. The function expects a 
%                    grayscale image where depth levels closer to the viewer 
%                    have a low value (closer to 0) while depth levels further away from 
%                    the viewer have a high value (closer to 255)
%
%
%   numLevels   ---> Specify an integer greater than 1. Determines the number 
%                    of bins for grouping depth-levels
%
%   focusRange  ---> 1x2 array that specifies the range of depth levels that the
%                    user does not want blurred
%                    
%                    eg: [30 40] instructs the function to blur all pixels 
%                    whose depth lies in bins outside of the specified range
%
%   upperFilt   ---> Specifies the upper limit for the kernel size of the 
%                    Gaussian filter to be used for blurring
%   
%   ------------------
%   Function Output
%   ------------------
%  
%   blurredImage ---> Selectively blurred RGB image with datatype uint8.
%
%   ------------------
%   Function Usage Example
%   ------------------
%  
%   imshow(selectiveBlurring(imread('Sample-Depth\painter-02.png'),imread('Sample-Depth\painter-02-depth.png'),10,[0 15],25))
%
% NOTE: This function is written for images from the Technicolor dataset
% that was used for this project. To extend usage to images from another
% dataset minor modifications will need to be made.

%% Initialization
blurredImage = zeros(size(img));
sizeImg = size(img);

%% Levels and Dynamic Code
uLimit = mode(mode(imgDepth))+30;
% We noticed that in the output depthmap, despite spreading the 50 available depth
% levels between 0 and 255, there were rarely a few pixels at depth levels
% higher than 65 (deeper levels are closer to the background). Inspecting the 
% depthmaps across various frames we noticed that the effective upper limit 
% was close to the mode of the intensity value of the depthmap image. Good 
% outputs were obtained by setting the upper limit to 30 greater than the mode.
%
% For different scenes it may be necessary to tweak line 64 if the output
% is not satisfactory.

bins = linspace(0,double(uLimit),double(numLevels));
% Available depth levels are binned into groups. There will be as many bins
% as the value of 'numLevels' specified when calling the function.


% Lines 35 to 43 define variables used later for checking bounds and assigning
% filter levels to each bin.
numBinsBelow = length(bins(bins<focusRange(1)))-1;
if numBinsBelow==-1
    numBinsBelow = 0;
end
numBinsAbove = length(bins(bins>focusRange(2)));
if numBinsAbove==-1
    numBinsAbove = 0;
end

% Initialize 'chooseFilt'
chooseFilt = zeros(1,numLevels); % Initialize with all 0

% This section (line 109 to 126) constitute the logic for assigning filter-levels 
% to each bin. The mapping is stored in 'chooseFilt'. The idea is that all bins
% containing levels within the 'focusRange' are assigned a filter-level of 1. 
% Bins outside the focusRange are assigned a higher filter-level depending 
% on the bin's distance from the focus range.
%
% --------
% Example
% --------
% Let numLevels = 10, focusRange = [11 30]
% 
% bins                 = [00.00   10.11   20.22   30.33   40.44   50.55   60.66   70.77   80.88   91.00]
% 
% chooseFilt           = [  2       1       1       2       3       4       5       6       7       8  ]

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

%% Generate Images Filtered at Each Level

% This section (lines 152 and 153) generates a list of gaussian filter-sizes ('filtSize')
% from 0.5 (no filtering) to upperFilt. There are as many filter levels as
% there are bins.
%
% Note that filter-size in this context is actually the standard deviation 
% of the gaussian distribution. MATLAB internally determines the filter size 
% based on the standard deviation when using 'imgaussFilt'
% 
%
% NOTE: Spacing between consecutive filter levels is currently linear. This
% can be tweaked/modified to vary the difference in blurring across levels.
% For instance, changing to a logarithmic or exponential spacing can have
% different results. To make modifications, replace line 153 with another
% line indicating the spacing of choice.
%
% --------
% Example
% --------
% Let numLevels = 10, and upperFilt = 25
%
% filtSize             = [ 0.50    3.22    5.94    8.66   11.38   14.11   16.83   19.55   22.27   25.00]

filt = uint8(zeros(sizeImg(1),sizeImg(2),sizeImg(3),numLevels));
filtSize = 0.5:(upperFilt-0.5)/(numLevels-1):upperFilt;

% After computing the filter sizes ('filtSize'), pre-filtered versions of the
% input image are created and stored ('filt') for reference. This is later used 
% as a look-up-table when generating the selectively blurred image. 
%
% filt is a 4D matrix with dimensions ImageWidth x ImageHeight x ColorChannels x numLevels.

for i=1:numLevels
    filt(:,:,:,i) = imgaussfilt(img,filtSize(chooseFilt(i)));
end

% By iterating through the 4th dimension of filt, one can view versions
% of the input image filtered by a different Gaussian filter chosen based 
% on the bin to filter-level mapping ('chooseFilt') defined above. Please refer 
% to the consolidated example below for an illustration.

% --------
%  Consolidated Example
% --------
% Let numLevels = 10, focusRange = [11 30] and upperFilt = 25
% 
% bins                 = [00.00   10.11   20.22   30.33   40.44   50.55   60.66   70.77   80.88   91.00]
% 
% chooseFilt           = [  2       1       1       2       3       4       5       6       7       8  ]
%
% filtSize             = [ 0.50    3.22    5.94    8.66   11.38   14.11   16.83   19.55   22.27   25.00]
%
% filtSize(chooseFilt) = [ 3.22    0.50    0.50    3.22    5.94    8.66   11.38   14.11   16.83   19.55]
%
% filt                 = 4D Matrix with dimensions ImageWidth x ImageHeight x ColorChannels x numLevels
%
% Descrption of Filtered Images in filt
%
% filt(:,:,:,1) --> Input image filtered using a Gaussian filter with Standard Deviation = 3.22 [filtSize(chooseFilt) (1)]
% filt(:,:,:,2) --> Input image filtered using a Gaussian filter with Standard Deviation = 0.50 [filtSize(chooseFilt) (2)]
% filt(:,:,:,3) --> Input image filtered using a Gaussian filter with Standard Deviation = 0.50 [filtSize(chooseFilt) (3)]
% filt(:,:,:,4) --> Input image filtered using a Gaussian filter with Standard Deviation = 3.22 [filtSize(chooseFilt) (4)]
% filt(:,:,:,5) --> Input image filtered using a Gaussian filter with Standard Deviation = 5.94 [filtSize(chooseFilt) (5)]
% 
% and so on...
% 

%% Generate Selectively Blurred Output Image
%
% In this section, we loop through the depthmap, pixel by pixel. At each
% pixel location we read the depth level from the depth map and identify the
% appropriate 'bin'. Based on the bin we know the level of blurring. We look
% up the pixel value from the appropriately filtered image in 'filt' and use 
% it to fill in the pixel value in the output 'blurredImage'.
%
% --------
% Example
% --------
%
% bins                 = [00.00   10.11   20.22   30.33   40.44   50.55   60.66   70.77   80.88   91.00]
% 
% chooseFilt           = [  2       1       1       2       3       4       5       6       7       8  ]
%
% filtSize(chooseFilt) = [ 3.22    0.50    0.50    3.22    5.94    8.66   11.38   14.11   16.83   19.55]
%
% filt                 = 4D Matrix with dimensions ImageWidth x ImageHeight x ColorChannels x numLevels
% 
% Given the parameters above. Suppose we are looping through 'imgDepth'
% 
% At i=100 and j=50 (location 100,50), let the depth level = 35 which falls
% in bin 4 which has a filter-level of 2 that corresponds to a gaussian
% filter with standard deviation of 3.22.
%
% filt(:,:,:,4) is a pre-filtered version of the input image filtered with
% the appropriate gaussian filter. We copy the pixel value at (100,50) in
% this image to the output image.
%
% That is, blurredImage(100,50,:) = filt(100,50,:,4)
%


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

% Return Final Output with uint8 Datatype
blurredImage = uint8(blurredImage);
end

