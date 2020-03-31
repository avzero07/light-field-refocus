function ZNCC = getLocalZNCC2(grayViews,aveMat,stdMat,z,x,y,ref,shiftMat)
    
%   given current depth z, compute the d(z)
    z0 = 100;    
    z1 = 1.63;   
    d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
    deltaMat = d.*shiftMat; 
    
    [arrayLength, ~] = size(deltaMat);
    [width,length,numViews] = size(grayViews);

    ref_ave = aveMat(:,:,ref);
    ref_std = stdMat(:,:,ref);
    ref_image = grayViews(:,:,ref);
    
    sum = 0;
    for v = 1:numViews
        if v ~= ref
            cor_ave = aveMat(:,:,v);
            cor_std = stdMat(:,:,v);
            cor_image = grayViews(:,:,v);
            vx = floor((v-1)/arrayLength) + 1; 
            vy = mod(v-1,arrayLength) + 1;
            delta_x = deltaMat(vy,vx,1);
            delta_y = deltaMat(vy,vx,2);

            x_cor = round(x + delta_x);
            y_cor = round(y + delta_y);
            % coordination vality check, skip the pixels whose corresponding pixel is out of scope 
            if x_cor > 0 && x_cor < (length+1) && y_cor > 0 && y_cor < (width+1)
                for i = -1:1
                    for j = -1:1
                        x_ref = x+i;
                        y_ref = y+j;
                        %  out of boundary check
                        if x_ref < 1 || x_ref > length || y_ref<1 || y_ref>width
                            Ihat_ref = 0;
                        else
                            Ihat_ref = (ref_image(y_ref,x_ref) - ref_ave(y,x))/ref_std(y,x);
                        end
                        x_cor_i = x_cor + i;
                        y_cor_j = y_cor + j;
                        if x_cor_i < 1 || x_cor_i > length || y_cor_j < 1 || y_cor_j > width
                            Ihat_cor = 0;
                        else
                            Ihat_cor = (cor_image(y_cor_j,x_cor_i) - cor_ave(y_cor,x_cor))/cor_std(y_cor,x_cor);
                        end
                        sum = sum + Ihat_ref * Ihat_cor;
                    end
                end
            end
        end   
    end
    ZNCC = sum/(15*9);   
    
end


