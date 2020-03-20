%% depthMap Function
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.5
% @date     - 13-March-2020
%% Changelog
% Version 0.5
% -- Initial Implementation
%
% To Do
% --
% -- 
%% Implementation
function [ptCloud] = depthMap(lightField,sb,tb)
%DEPTHMAP Returns the point cloud of the scene, relative to base view (sb,tb)
%   The function takes in the lightField and base view location as input
%   and returns the point cloud of the scene.
%
%   lightField ---> Matrix Containing sub-aperture images of a scene.
%   sb ---> [Base View](Camera Array Row Number) Runs from 0 - 3 like in the paper
%   tb ---> [Base View](Camera Array Column Number) Runs from 0 - 3 like in the paper
%

% Depth Range
depths = 2:0.5:4.5;

% Real World Co-ordinates
xyz = zeros(size(lightField,1)*size(lightField,2)*size(depths,2),3);

% Intrinsic Matrix
K = getIntrinsic(1,1); % TODO : Modify for different base views
Kinv = inv(K);

% Identify Base Image in LightField
baseInd = 0;
% Loop Through LightField Until Base Image
index = 0;
for i=1:1:4
    for j=1:1:4
        index = index + 1;
        if((i-1)==sb && (j-1)==tb)
            baseInd = index;
            break
        end
    end
end

% Loop Through Depths
for i=1:size(depths,2)
    ptCloud = depths(i)*Kinv*()
end

