function [ depth,idx ] = Dept_vol_subpixel_2( LF,...%LF in LF(t,s,v,u,c) c=colour channels input 1
                                                                        dmin, dmax, ...% min and max "slopes" or diparities an integer value input 2, 3
                                                                        angularop,...% angular dimmention for the epipolar image input 4
                                                                        outer,...
                                                                        varest,...
                                                                        aggregation,...
                                                                        N,...
                                                                        M)
% DEPT_VOL [ depth ] = Dept_vol( LF, dmin, dmax ,angularop,outer,varest,aggregation,N,M)
% Francisco Carlos Calderón M.Sc april 2014 last version  October 21 2014
% Creative commons 2.5 share alike by non-commercial
%   INPUT 1
%       LF is a lightField of dimmention LF(t,s,v,u,c) c=colour channels
%   INPUT 2 & 3
%       dmin and dmax are the maximum and minimun disparities ONLY INTEGERS
%       EVEN IF SUBPIXEL AC... IS NEEDED
%   INPUT 4 
%       angularop the angular dimmention to operate the options are 's' and
%       't'. ( 's' by default). i.e. if a single line of views is provided
%       you can still choose the angular direction 's' for horizontal 
%       "and traditional" multi-view-stereo and 't' for vertical multi-view-stereo. 
%   INPUT
%   outer is the size of the window used to aggregate
%   varest The variance estimator used, can be 1 Median and SAD, 2 mean SAD
%   3 median SSD or 4 mean SSD
%   aggregation if aggregation(1)=1=gaussian sigma=(outer/2 - 1)*0.3 + 0.8
%   if aggregation(1)=2 guided filter with the regularization parameter eps in aggregation(2)
%   if aggregation(1)=3 modification in x of the  guided filter with the regularization parameter eps in aggregation(2)
%   N sub pixel interpolation
%   M post median filtering kernel size.
if (nargin==5)
    varest=1;
end

if dmin>=dmax
   error ('Are you sure that dmin is equeal or grater than dmax???. go to sleep')
end
tam=size(LF);
if size(tam)==4
    tam(5)=1;
    disp('The LF have only one channel')
end

if (angularop=='t')||((angularop=='T'))
    ang=tam(1);
else
    if (angularop=='s')||((angularop=='S'))
        ang=tam(2);
    else
        error('LOL :P Variable angularop incorrect. Please read the documentation help Dept_vol_subpixel_2 ')
    end
end

dmin=dmin*N;
dmax=dmax*N;
tam(3)=tam(3);
tam(4)=tam(4);
A=(abs(dmax-dmin)+1);%amount of levels calculated
W=zeros(tam(3),tam(4),A);
Is=zeros(tam(3),tam(4),ang);
di=0;% begin in zero to put this 3 lines together
for dp=dmin:dmax % the pixel equivalent of disparity
    di=di+1;% the index equivalent of disparity
    central=zeros(tam(3),tam(4)); %#ok<NASGU>
    variation=zeros(tam(3),tam(4)); %#ok<NASGU>
    for chan=1:tam(5)
        da=floor(-ang/2);%begin in one down to increase in the loop
        for a=1:ang
            da=da+1;%index of the shift per angular coordinate
            if (angularop=='t')||((angularop=='T'))
                s=ceil(tam(1)/2);
                I=imresize(squeeze( LF(a,s,:,:,chan)),N);
            else
                if (angularop=='s')||((angularop=='S'))
                    t=ceil(tam(1)/2);
                    I=imresize(squeeze( LF(t,a,:,:,chan)),N);
                end
            end
            Is(:,:,a)=Is(:,:,a)+imresize(shift_image(I,da*dp),1/N);
        end
    end
    Is=Is./tam(5);% normalise per colour channels
    
    
    
    if varest==1%1 Median and SAD
        central=median(Is,3);% Median
        variation=sum(abs(repmat(central,[1,1,ang])-Is),3);% L1
    else
        if varest==2%2 mean SAD
            central=sum(Is,3)./ang;% Mean
            variation=sum(abs(repmat(central,[1,1,ang])-Is),3);% L1
        else
            if varest ==3%   3 median SSD
                central=median(Is,3);% Median
                variation=sum((repmat(central,[1,1,ang])-Is).^2,3);% L2
            else%difenet to the others   mean SSD
                central=sum(Is,3)./ang;% Mean
                variation=sum((repmat(central,[1,1,ang])-Is).^2,3);% L2
                
            end
        end
    end
    
    
    %
    %
    W(:,:,di)=variation;
end


if(outer>1)
    if aggregation(1)==1
        for f=1:A
	    H=fspecial('gaussian',outer,(outer/2 - 1)*0.3 + 0.8);%H = fspecial('gaussian',[8,8],0.9);
            W(:,:,f)=imfilter(squeeze(W(:,:,f)),H);
        end
    else
        if aggregation(1)==2
            guidance=rgb2gray(squeeze(LF(round(tam(1)/2),round(tam(1)/2),:,:,:)));%central image as guidance image
            for f=1:A
                %   - guidance image: I (should be a gray-scale/single channel image)// guidance
                %   - filtering input image: p (should be a gray-scale/single channel image)
                %   - local window radius: r
                %   - regularization parameter: eps
                W(:,:,f)=guidedfilter(guidance, squeeze(W(:,:,f)), outer, aggregation(2));
            end
        else
            if aggregation(1)==3
                guidance=rgb2gray(squeeze(LF(round(tam(1)/2),round(tam(1)/2),:,:,:)));%central image as guidance image
                for f=1:A
                    %   - guidance image: I (should be a gray-scale/single channel image)// guidance
                    %   - filtering input image: p (should be a gray-scale/single channel image)
                    %   - local window radius: r
                    %   - regularization parameter: eps
                    W(:,:,f)=guidedfilterx(guidance, squeeze(W(:,:,f)), outer, aggregation(2));
                end
            end
        end
    end
end

% optimization by WTA
[~,idx]=min(W,[],3);


% post processing
% if M>0
%     depth=medfilt2(((idx-2+dmin))./N,[M,M]);
% else
%     depth=((idx-2+dmin))./N;
% end
if M>0
    depth=medfilt2(((idx-1+dmin))./N,[M,M]);
else
    depth=((idx-1+dmin))./N;
end
end

