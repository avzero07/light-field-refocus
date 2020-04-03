function Ihat = getIhat2(grayView,average,stad)

    [width,length] = size(grayView);
    
%   compute Ihat of a pixel for all i and j
    Ihat = zeros(width,length,3,3);

    for i = -1:1
        for j = -1:1            
            Ihat_i_j = zeros(width,length);
            Ihat_temp = (imtranslate(grayView,[-i,-j]) - average)./stad;
            % Calculate the window size to cut out correct Ihat values
            % after translation, fix boundary values 
            length_s = 1-i;
            length_e = length-i;
            width_s = 1-j;
            width_e = width-j;
            if length_s < 1
                length_s = 1;
            end
            if length_e > length
                length_e = length;
            end
            if width_s < 1
                width_s = 1;
            end
            if width_e > width
                width_e = width;
            end
            %Copy values from Ihat_temp to Ihat_i_j according to the window
            Ihat_i_j(width_s:width_e,length_s:length_e) = Ihat_temp(width_s:width_e,length_s:length_e);
            Ihat(:,:,i+2,j+2) = Ihat_i_j;            
        end
    end

end