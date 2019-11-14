function BW1 = human_skin2(image_path)
    %Detection of Face on the basis of skin color
    close all;
    %clc
    I=imread(image_path);
    %R > 95 and G > 40 and B > 20 
    %and  (Max{R, G, B} - min{R, G, B}) > 15
    %and |R-G| > 15 and R > G and R > B
    figure;
    imshow(I)
    for i = 1:size(I,1)
        for j = 1:size(I,2)
        
            r = I(i,j,1);
            g = I(i,j,2);
            b = I(i,j,3);
        
            rgb = [r,g,b];
            
            if r > 90 && g > 90 && b > 90 && max(rgb) - min(rgb) > 4 && abs(r-g) > 5 && r > g && r > b
                I(i,j, 1) = 255;
                I(i,j, 2) = 255;
                I(i,j, 3) = 255;
            else
                I(i,j, 1) = 0;
                I(i,j, 2) = 0;
                I(i,j, 3) = 0;
            end
        
        end
    end
    figure;
    imshow(I)
end