function ZK_1 = upsample2(lightFieldGray,prevZ,delz,ref,shiftMat,zmin)

   
    [width,length,numViews] = size(lightFieldGray);
    
    ZK_1 = zeros(width,length);
    
    % For Refocus
    z0 = 100;   % Pre-Defined
    z1 = 1.63;  % Pre-Defined
    IhatMat = zeros(3,3,size(lightFieldGray,1),size(lightFieldGray,2),numViews);
    %% Loop Through Light Field
    index = 0;
    f = waitbar(0,'Start'); 
    for i=1:4
        for j=1:4
            waitbar(((i-1)*4+j)/16,f,sprintf('i=%d,j=%d',i,j));
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
    IhatMat(isinf(IhatMat)) = realmax(class(IhatMat));
    %IhatMat2 = permute(IhatMat,[3,4,1,2,5]); % ImageRow,ImageColomn,neighbor_i,neighbor_j,viewnumber 
    prevZ = padarray(prevZ,[1 1],0,'both');   
    for x = 1:width
        waitbar(x/width,f,sprintf('row=%d',x));
        for y = 1:length
            %waitbar(((x-1)*length+y)/length/width,f,sprintf('row=%d,colomn=%d',x,y));

            % Use prevZ to compute subPrevZ

            % Pad prevZ

            subPrevZ = prevZ(round(x/2)-1+1:round(x/2)+1+1,round(y/2)-1+1:round(y/2)+1+1);

            % Use subPrrevZ to compute Depth Cube
            depthCube = zeros(3,3,3); % neighbor i, neighbor j, three depth level
            depthCube(:,:,2) = subPrevZ;
            depthCube(:,:,1) = subPrevZ-(delz/2);
            depthCube(:,:,3) = subPrevZ+(delz/2);

            depthList = unique(depthCube); % Returns List of Depths to Traverse Through
            depthList = depthList(depthList>zmin); % Since 1.63 is least Depth
            [len,~] = size(depthList);
            % ZNCC List
            znccList = zeros(1,len);
            for l=1:1:len
                z = depthList(l);
                d = ((1/z)-(1/z0))/((1/z1)-(1/z0));
                znccList(l) = computeZNCCLocal2(IhatMat,shiftMat,ref,d,x,y);
            end

            %% Find minZ
            [m,ind] = max(znccList);
            minZxy = depthList(ind);
            ZK_1(x,y) = minZxy;
        end
    end
end