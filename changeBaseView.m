%% changeBaseView Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 19-Feb-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
function [newShiftMat] = changeBaseView(s,t)
%CHANGEBASEVIEW Returns the Shift Matrix Relative to new Base View
%   The Shift Matrix is relative to view (1,1). This function takes in as
%   as input a new (s,t) and returns a Shift Matrix Relative to the new
%   view.
%
%   s ---> (Camera Array Row Number) Runs from 0 - 3 like in the paper
%   t ---> (Camera Array Column Number) Runs from 0 - 3 like in the paper
%
%   NOTE: Original Base View is relative to (s=1,t=1)

% Define Base Shift Matrix for Painter Scene
shiftMat = zeros(4,4,2);
shiftMat(:,:,1) = [100,-0.36,-97.19,-195.55;
                   98.67,0,-96.18,-197.85;
                   99.17,0.21,-98.33,-197;
                   99.08,-1.22,-99.26,-198.36];
shiftMat(:,:,2) = [98.28,98.14,98.07,97.35;
                   -1.73,0,0.74,0.11;
                   -99.93,-99.11,-101.12,-99.07;
                   -197.68,-198.14,-198.89,-199.37];              
% Initialize New Shift Matrix
newShiftMat = zeros(4,4,2);
% Shift Relative to new (s,t)
newShiftMat(:,:,1) = shiftMat(:,:,1) - shiftMat(s+1,t+1,1);
newShiftMat(:,:,2) = shiftMat(:,:,2) - shiftMat(s+1,t+1,2);
end

