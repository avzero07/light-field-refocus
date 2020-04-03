function ZNCC = getZNCC3(grayViews,ref,z, shiftMat)
    
%   given current depth z, compute the delta matrix
    z0 = 100;    
    z1 = 1.63;   
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    deltaMat = -1 * d.*shiftMat; 
    %Shifting the image by d*delta equals to imtranslate the negtive of the
    %value
    
    [~,arrayLength,~] = size(deltaMat);
    
    refView = double(grayViews(:,:,ref));
    [~,~,numViews] = size(grayViews);
    
    %For reference view, each pixel has a 3x3 Ihat matrix for differen i
    %and j
    Ihat0 = getIhat3(refView);
    %temp = Ihat0(:,:,1,1);
    
%   size : length * width * 3 * 3
    ZNCC = zeros(size(Ihat0));
    
    for v = 1 : numViews
        if v ~= ref
%           index to camera position conversion
            vx = floor((v-1)/arrayLength) + 1; 
            vy = mod(v-1,arrayLength) + 1;
            corView = double(grayViews(:,:,v));
            corView = imtranslate(corView,[deltaMat(vy,vx,1),deltaMat(vy,vx,2)]);
            Ihat_cor = getIhat3(corView);            
            
            ZNCC = ZNCC + Ihat_cor .* Ihat0;
        end
    end
%   sum up along i and j
    ZNCC_SUM = sum(sum(ZNCC,4),3); % Can be improved
    ZNCC = ZNCC_SUM/(15*(3^2));
end
