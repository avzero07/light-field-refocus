function ZK_1 = upsample(IK_1,ZK,M,deltaZK,center,shiftMat)

    [wid_zk, len_zk] = size(ZK); %wid_zk for y, len_zk for x
    
    [Y_num,X_num,~,numView] = size(IK_1);
    
    ZK_1 = zeros(Y_num,X_num);
    
%   compute Ihat for all of views
    IhatMat = zeros(Y_num,X_num,3,3,numView);
    %Every view is translated to 9 views according to i and j
    for v = 1:numView
        Ihat = getIhat(rgb2gray(IK_1(:,:,:,v)));
        Ihat(isnan(Ihat)) = 0;
        Ihat(isinf(Ihat)) = realmax(class(Ihat));
        %Ihat is width x length x 3 x 3
        IhatMat(:,:,:,:,v) = Ihat;
    end

    
    
    for x = 1:X_num
        for y = 1:Y_num
            
%           minimize Eq.19 to obtain local depth among all different i, j, m
            localZNCC = realmax("double");
            zmin = 1;

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
                    zk = ZK(y_,x_);
                    
%                   local depth range = [zk - deltaZK/2,zk + deltaZK/2] for each i,j,x,y
                    for m = 0:M
                       z = zk - deltaZK/2 + m*deltaZK/M;
                       curZNCC = getLocalZNCC(IhatMat,z,x,y,center,shiftMat);
                       if curZNCC < localZNCC
                           localZNCC = curZNCC;
                           zmin = z;
                       end
                    end                    
                end
            end

            ZK_1(y,x) = zmin;
        end
    end
end