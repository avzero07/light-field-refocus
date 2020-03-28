function Ihat = getIhat(I)

    [length,width] = size(I);
    
    I = double(I);

%   local average of view in a 3 by 3 squared neighborhood
    ave = conv2(I, ones(3,3)/9,'same');
%   compute Ibar
    Ibar = I - ave;
%   compute the local standard deviation of Ibar
    std = stdfilt(Ibar); % stdfilt default : 3 by 3
    
%   compute Ihat
    Ihat = zeros(length,width,3,3);

    for i = -1:1
        for j = -1:1
            Ihat(:,:,i+2,j+2) = (imtranslate(I,[i,j]) - ave)./ std;
        end
    end

end