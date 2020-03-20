%% Light Field Refocus
% Script To Test lfRefocusTiltShift
% @author   - Akshay Viswakumar
% @email    - akshay.viswakumar@gmail.com
% @version  - v0.1
% @date     - 19-March-2020
%% Init
clc;
close all;
clear variables;
%% Loop Through Various Depths
depth = 2.5;
figure
for i=1:12
    
    % Generate Random co-ordinate
    uUp = 1088;
    uDown = 1;
    
    %u = round((uUp-uDown).*rand(1));
    u = 1480;
    
    vUp = 2048;
    vDown = 1;
    
    %v = round((vUp-vDown).*rand(1));
    v = 625;
    
    depth = depth + 0.25;
    opImg = lfRefocusTiltShift(depth,u,v);
    subplot(4,3,i)
    imshow(opImg,[]), title("Depth = "+string(depth)+" u = "+string(u)+" v = "+string(v))
end