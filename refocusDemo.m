%% New Refocus Demo
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 03-Apr-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
clc;
clear variables;
close all;
%% Init
img = imread('Sample-Depth\painter.png');               % Load Image
depthMap = imread('Sample-Depth\painter-depth.png');    % Load Depth Map

% Display Image
figure, imshow(img,[]),title('Reference Image');
% Display Depthmap
imtool(depthMap,[]);
%% Focusing Different Parts of the Image

%% Books
resultBooks = selectiveBlurring(img,depthMap,20,[1 6],35);
figure, imshow(resultBooks,[]),title('Stack of Books Focused');

%% Right Side Painting
resultRightPainting = selectiveBlurring(img,depthMap,20,[26 36],35);
figure, imshow(resultRightPainting,[]),title('Painting on Right Side Refocused');

%% Easel
resultEasel = selectiveBlurring(img,depthMap,20,[30 42],35);
figure, imshow(resultEasel,[]),title('Easel on Left Side Refocused');

%% Back Paintings and Statues
resultBackPaintings = selectiveBlurring(img,depthMap,20,[60 100],35);
figure, imshow(resultBackPaintings,[]),title('Paintings and Sculpture at the Back Refocused');

%% Everything in the Back Refocused
resultAllBack = selectiveBlurring(img,depthMap,20,[60 254],35);
figure, imshow(resultAllBack,[]),title('Everything in the Background Refocused');

%% Everything in the Foreground Focused
resultAllFore = selectiveBlurring(img,depthMap,20,[1 60],35);
figure, imshow(resultAllFore,[]),title('Back to Books');
