function ZK_1 = upsample(IK_1,ZK,M,deltaZK,center,shiftMat)

    [len_zk, wid_zk] = size(ZK);
    
    [length,width,~,numView] = size(IK_1);
    
    ZK_1 = zeros(length,width);
    
%   compute Ihat for all of views
    IhatMat = zeros(length,width,3,3,numView);
    for v = 1:numView
        Ihat = getIhat(rgb2gray(IK_1(:,:,:,v)));
        Ihat(isnan(Ihat)) = 0;
        Ihat(isinf(Ihat)) = realmax(class(Ihat));
        IhatMat(:,:,:,:,v) = Ihat;
    end

    
    
    for x = 1:length
        for y = 1:width
            
%           minimize Eq.19 to obtain local depth among all different i, j, m
            localZNCC = realmax("double");
            argmin = 1;
          
            for i = -1:1
                for j = -1:1
                    
                    x_ = floor(x/2) + i; 
                    y_ = floor(y/2) + j; 
                    
%                   out of boundary
                    if x_ < 1, x_ = 1; end
                    if x_ > len_zk, x_ = len_zk; end
                    if y_ < 1, y_ = 1; end
                    if y_ > wid_zk, y_ = wid_zk; end
                    
%                   consider the depth estimated value in the previous scale in 3 by 3 neighborhood
                    zk = ZK(x_,y_);
                    
%                   local depth range = [zk - deltaZK/2,zk + deltaZK/2] for each i,j,x,y
                    for m = 0:M
                       z = zk - deltaZK/2 + m*deltaZK/M;
                       cur = getLocalZNCC(IhatMat,z,x,y,center,shiftMat);
                       if cur < localZNCC
                            localZNCC = cur;
                            argmin = z;
                       end
                    end
                    
                end
            end
            ZK_1(x,y) = argmin;
        end
    end
end