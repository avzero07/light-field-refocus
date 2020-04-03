%% Script to Test Disparity Generation
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 25-Mar-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- Add Defaults
%% Initialization
clc;
close all;
clear variables;
%% Parameters
frames = 146;
views = 16;

frameOfInterest = 0;
viewOfInterest = 6;
%% Load Images
% Load LF Using genLfSequence2
lightField = genLfSequence2("D:\EECE541 - Project - LF2\LightFieldRefocusingProject\TestSequence\","Painter_pr_00",4,4,frameOfInterest,"png");

%% Commence Script
[depth,idx] = Dept_vol_subpixel_2(double(lightField),1,10,'t',100,1,1,3,3);

