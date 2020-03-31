function Ihat = getIhat(I)

    [Y_NUM,X_NUM] = size(I);
    
    I = double(I);

%   local average of view in a 3 by 3 squared neighborhood
    I2 = padarray(I,[1 1],'symmetric','both');
    ave_temp = conv2(I2, ones(3,3)/9,'same'); %For zero padding area average will be wrong
    ave = ave_temp(2:Y_NUM+1,2:X_NUM+1);
%   compute Ibar
    Ibar = I - ave;   
%   compute the local standard deviation of Ibar
    std = stdfilt(Ibar); % stdfilt default : 3 by 3, n =1
    %std2 = stdfilt(I);
%   compute Ihat
    Ihat = zeros(Y_NUM,X_NUM,3,3);

    for i = -1:1
        for j = -1:1            
        %Todo rewrite this part to solve the boundary issue
            Ihat(:,:,i+2,j+2) = (imtranslate(I,[i,j]) - ave)./ std;
            %Ihat(:,:,i+2,j+2) = (imtranslate(I,[-i,-j]) - ave)./ std2;
        end
    end

end