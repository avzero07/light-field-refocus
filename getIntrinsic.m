%% getIntrinsic Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 13-March-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
% -- Written for base view at (1,1)
%
% To Do
% -- Tweak to accept change in Base View
% -- 
%% Implementation
function [Kst] = getIntrinsic(s,t)
%GETINTRINSIC Returns the Intrinsic Matrix for Camera [s,t]
%   Given the intrinsic Matrix for (1,1) this function will return the
%   corresponding intrinsic matrix for the view at (s,t). The function
%   merely adjusts the principal points in the intrinsic matrix.
%
%   Structure of Intrinsic Matrix
%
%   K = [   f       0       Cu
%           0       f       Cv
%           0       0       1   ]
%
%   Where Cu and Cv is the principle point.
%
%   s ---> (Camera Array Row Number) Runs from 0 - 3 like in the paper
%   t ---> (Camera Array Column Number) Runs from 0 - 3 like in the paper
%

% Intrinsic Matrix for Camera at (1,1)
Kst = [2340.14,0,1043.09;
     0,2340.14,480.46;
     0,0,1];
 
% Kst = [2354.05,0,1020.15;
%      0,2354.05,486.68;
%      0,0,1];
 
% Shift Matrix for Base View
shiftMat = changeBaseView(1,1); % TODO: Tweak to accept change in Base View

% Tweak Principal Points
Kst(1,3) = Kst(1,3) - shiftMat(s+1,t+1,1);
Kst(2,3) = Kst(2,3) - shiftMat(s+1,t+1,2);
end

