%% reProject Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 06-March-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% -----
% -- 
%% Implementation
function [projectedLightField] = reProject(lightField,K,R,shiftMat,n)
% REPROJECT Returns Reprojected Light Field Array
%   Function takes in as Input the Input LightField, Intrinsic Matrix (K),
%   Rotation Matrix (R), shiftMatrix, normalVector (for new plane).
%
%   lightField --> Input Light Field (1088x2048x3x16)
%   K          --> Camera Intrinsic Matrix
%   R          --> Camera Rotation Matrix
%   shiftMat   --> Camera Disparity Shift Matrix
%   n          --> Normal to New Refocus Plane

% Calculate The Projection Matric
% P = K H K^(-1)

% Init Result
projectedLightField = zeros(1088,2048,3,16);

% Loop Through Images in the Light Field
index = 0;
for i=1:1:4
    for j=1:1:4
        index = index + 1;
        
        % Get Distance
        n = [0;0;1];
        p = [1604;754;1];
        tsrtr = [-1*shiftMat(i,j,1),-1*shiftMat(i,j,1),1];
        
        d = (n)'*(p-tsrtr);
        
        % Compute H
        H = R - 
        
        % Invert K
        Kinv = inv(K);
        
    end
end

end

