function depthmap = getDepthmap3(lightFieldGray,center,shiftMat,zmin,zmax,depthRes)
    [width,length,numViews] = size(lightFieldGray);

    %depthSeq = linspace(zmin, zmax, depthRes);
    depthSeq = linspace(zmin, zmax, depthRes+1);
    %f = waitbar(0,'Start');
    ZNCCs = zeros(width,length,depthRes+1);
    IhatMat = zeros(3,3,size(lightFieldGray,1),size(lightFieldGray,2),numViews);
    %% Loop Through Light Field
    index = 0;
    %f = waitbar(0,'Start'); 
    for i=1:4
        for j=1:4
            %waitbar(((i-1)*4+j)/16,f,sprintf('i=%d,j=%d',i,j));
            index = index+1;

            img = double(lightFieldGray(:,:,index)); 
            imgPad = padarray(img,[1 1],0,'both');

            % Loop Through Image for Neighborhood Operation
            for x=2:1:size(img,1)+1
                for y=2:size(img,2)+1

                    ImgNeigh = imgPad(x-1:x+1,y-1:y+1);

                    % Normalize
                    ImgIbar = ImgNeigh - mean(mean(ImgNeigh));                
                    ImgIhat = ImgIbar/std(ImgIbar,1,'all');
                    IhatMat(:,:,x-1,y-1,index) = ImgIhat; 
                end
            end
        end
    end
    IhatMat(isnan(IhatMat)) = 0;
    %IhatMat(isinf(IhatMat)) = realmax(class(IhatMat));
    IhatMat2 = permute(IhatMat,[3,4,1,2,5]); % ImageRow,ImageColomn,neighbor_i,neighbor_j,viewnumber
%   depth z in [zmin, zmax]
    for i =1:depthRes+1
        z = depthSeq(i);%depthSeq(i);
%       compute ZNCC for each sampled depth z
        temp = computeZNCC3(lightFieldGray, shiftMat, center,z,IhatMat2);        
        ZNCCs(:,:,i) = temp;%getZNCC(lightField, center, z, shiftMat);
    end
%   for each pixel, find the argument of the mininum in ZNCCs
    [~,index] = max(ZNCCs,[],3);%min(ZNCCs,[],3);
    depthmap = depthSeq(index);
    
end

