%% Light Field Refocus
% Trial Script
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-Feb-2020
%% Init
clc;
close all;
clear variables;
%% Load Images

% Set Filename Parameters
canonicalName = "Painter_pr_00";
frame = 0;
view = 0;
format = ".png";

% Define Matrix to Store Views from One Frame
lightField = uint8(zeros(1088,2048,3,16));

% Read all Views from One Frame
for i=1:16
    sFrame = "";
    % Format Frame Number in Filename
    switch strlength(string(frame))
        case 1
            sFrame = "00"+string(frame);
        case 2
            sFrame = "0"+string(frame);
        case 3
            sFrame = string(frame);
    end
    
    % Set 'view' in Every Iteration
    view = i-1;
    
    % Format View Number in Filename
    sView = "";
    if view < 10
        sView = "_0"+string(view);
    else
        sView = "_"+string(view);
    end
    
    % Set File Path
    path = "Images-Frame1\"+canonicalName+sFrame+sView+format;
    
    % Read Images
    lightField(:,:,:,i) = imread(path);
end
%% Display All Views of Given Frame
figure
subplot(4,4,1), imshow(lightField(:,:,:,1)), title("1");
subplot(4,4,2), imshow(lightField(:,:,:,2)), title("2");
subplot(4,4,3), imshow(lightField(:,:,:,3)), title("3");
subplot(4,4,4), imshow(lightField(:,:,:,4)), title("4");
subplot(4,4,5), imshow(lightField(:,:,:,5)), title("5");
subplot(4,4,6), imshow(lightField(:,:,:,6)), title("6");
subplot(4,4,7), imshow(lightField(:,:,:,7)), title("7");
subplot(4,4,8), imshow(lightField(:,:,:,8)), title("8");
subplot(4,4,9), imshow(lightField(:,:,:,9)), title("9");
subplot(4,4,10), imshow(lightField(:,:,:,10)), title("10");
subplot(4,4,11), imshow(lightField(:,:,:,11)), title("11");
subplot(4,4,12), imshow(lightField(:,:,:,12)), title("12");
subplot(4,4,13), imshow(lightField(:,:,:,13)), title("13");
subplot(4,4,14), imshow(lightField(:,:,:,14)), title("14");
subplot(4,4,15), imshow(lightField(:,:,:,15)), title("15");
subplot(4,4,16), imshow(lightField(:,:,:,16)), title("16");
sgtitle("All Views from Frame-"+sFrame);
%% Compute Refocused Image

%% Output