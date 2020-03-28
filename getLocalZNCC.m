function ZNCC = getLocalZNCC(IhatMat,z,x,y,center,shiftMat)
    
%   given current depth z, compute the d(z)
    z0 = 100;    
    z1 = 1.63;   
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    
    [arrayLength, ~] = size(shiftMat);
    [length,width,~,~,numViews] = size(IhatMat);
    

    Ihat0 = IhatMat(x,y,:,:,center);
%    size 3 * 3 for different i, j
    Ihat0 = reshape(Ihat0,[3,3]);
  
    
%   size : 3 * 3
    ZNCC = zeros(3,3);
    
    for v = 1 : numViews
        if v ~= center

%           index of camera pisition
            vx = floor((v-1)/arrayLength) + 1; 
            vy = mod(v-1,arrayLength) + 1;
            
            x_ = round(x+d*shiftMat(vx,vy,1));
            y_ = round(y+d*shiftMat(vx,vy,2));
           
            if x_ < 1 || x_ > length || y_ < 1 || y_ > width
                Ihat = zeros(3,3);
            else
                Ihat = IhatMat(x_,y_,:,:,v);
                Ihat = reshape(Ihat,[3,3]);
            end
           
            ZNCC = ZNCC + Ihat.*Ihat0;

        end
    end
%   sum up along i and j
    ZNCC = sum(sum(ZNCC))/(15*3^2);
    
end


