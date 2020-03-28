function Ihat = getIhat(I)

    [length,width] = size(I);
    
    I = double(I);

%   local average of view in a 3 by 3 squared neighborhood
    I2 = padarray(I,[1 1],'symmetric','both');
    ave_temp = conv2(I2, ones(3,3)/9,'same'); %For zero padding area average will be wrong
    ave = ave_temp(2:length+1,2:width+1);
%   compute Ibar
    Ibar = I - ave;   
%   compute the local standard deviation of Ibar
    std = stdfilt(Ibar); % stdfilt default : 3 by 3, n =1
    
%   compute Ihat
    Ihat = zeros(length,width,3,3);

    for i = -1:1
        for j = -1:1
            Ihat(:,:,i+2,j+2) = (imtranslate(I,[i,j]) - ave)./ std;%(imtranslate(I,[-i,-j]) - ave)./ std;
        end
    end

end