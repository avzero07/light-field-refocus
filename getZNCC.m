function ZNCC = getZNCC(grayViews,aveMat,stdMat,ref,z, shiftMat)
    
%   given current depth z, compute the delta matrix
    z0 = 100;    
    z1 = 1.63;   
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    deltaMat = -1 * d.*shiftMat; 
    %Shifting the image by d*delta equals to imtranslate the negtive of the
    %value
    
    [~,arrayLength,~] = size(deltaMat);
    
    refView = grayViews(:,:,ref);
    refAvg = aveMat(:,:,ref);
    refStd = stdMat(:,:,ref);
    [~,~,numViews] = size(grayViews);
    
    %For reference view, each pixel has a 3x3 Ihat matrix for differen i
    %and j
    Ihat0 = getIhat2(refView,refAvg,refStd);
    %temp = Ihat0(:,:,1,1);
%   remove the invalid values, otherwise an error occurs in imtranslate()
%    Ihat0(isinf(Ihat0)) = realmax(class(Ihat0));
%    Ihat0(isnan(Ihat0)) = 0;
    
%   size : length * width * 3 * 3
    ZNCC = zeros(size(Ihat0));
    
    for v = 1 : numViews
        if v ~= ref
            corView = grayViews(:,:,v);
            corAvg = aveMat(:,:,v);
            corStd = stdMat(:,:,v);
            Ihat = getIhat2(corView,corAvg,corStd);
            %temp = Ihat(:,:,3,3);
            %Ihat(isinf(Ihat)) = realmax(class(Ihat));
            %Ihat(isnan(Ihat)) = 0;
            
%           index to camera position conversion
            vx = floor((v-1)/arrayLength) + 1; 
            vy = mod(v-1,arrayLength) + 1;
            
            %Translate Ihat for all i and j, correponding pixel that out of image scope result in zero 
            Ihat_cor = imtranslate(Ihat,[deltaMat(vy,vx,1),deltaMat(vy,vx,2)]);
            ZNCC = ZNCC + Ihat_cor .* Ihat0;
            %ZNCC = ZNCC + imtranslate(Ihat,[deltaMat(vx,vy,1),deltaMat(vx,vy,2)]) .* Ihat0;
        end
    end
%   sum up along i and j
    ZNCC_SUM = sum(sum(ZNCC,4),3); % Can be improved
    ZNCC = ZNCC_SUM/(15*(3^2));
end
