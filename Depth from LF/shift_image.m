function I = shift_image(I,shift)
%SHIFT_IMAGE The function shifts the 2D image I by the disparity shift
%   I= the 2D image
%   shift= the shift that must be shifted "or the disparity"
%   Fills with zeros the blank shifted spaces.
%   Returns I the shisted image: I = shift_image(I,shift)
% Francisco Carlos Calderón M.Sc april 2014
% Creative commons 2.5 share alike by non-commercial
%   calderonfatgmaildotcom
%Some assert of the input
shift=-shift;
dimx = size(I,2);
if shift>dimx
error('shift bigger than matrix size')
end
if shift>dimx/2
warning('shift bigger than half matrix size')
end
I=circshift(I,[0,shift]);
if(shift > 0)
    I(:,1:shift)=0;
end
if(shift < 0)
    I(:,end+shift+1:end)=0;
end

% OLD IMPLEMENTATION NOT WORKING 
%   if(shift > 0)
%     shift=shift+1;% BIG BUG FIXED
%     I(:,shift:dimx,:) = I(:,1:dimx-shift+1,:);
%     I(:,1:shift-1,:) = 0;
%   else 
%     if(shift<0)
%       I(:,1:dimx+shift+1,:) = I(:,-shift:dimx,:);
%       I(:,dimx+shift+1:dimx,:) = 0;
%     end  
%   end
% end