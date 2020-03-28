function ZNCC = getZNCC(lightField,center,z, shiftMat)
    
%   given current depth z, compute the delta matrix
    z0 = 100;    
    z1 = 1.63;   
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    deltaMat = -1 * d.*shiftMat; 
    
    [arrayLength, ~] = size(deltaMat);
    
    centralView = rgb2gray(lightField(:,:,:,center));
    [~,~,~,numViews] = size(lightField);
    
    Ihat0 = getIhat(centralView);
%   remove the invalid values, otherwise an error occurs in imtranslate()
    Ihat0(isnan(Ihat0)) = realmax(class(Ihat0));
    
%   size : length * width * 3 * 3
    ZNCC = zeros(size(Ihat0));
    
    for v = 1 : numViews
        if v ~= center
            Ihat = getIhat(rgb2gray(lightField(:,:,:,v)));
            Ihat(isnan(Ihat)) = realmax(class(Ihat));  
            
%           index of camera pisition
            vx = floor((v-1)/arrayLength) + 1; 
            vy = mod(v-1,arrayLength) + 1;

            ZNCC = ZNCC + imtranslate(Ihat,[deltaMat(vx,vy,1),deltaMat(vx,vy,2)]) .* Ihat0;
        end
    end
%   sum up along i and j
    ZNCC = sum(sum(ZNCC,4),3)/(15*3^2);
    
end