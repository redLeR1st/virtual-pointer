function count_disparity_from_folder( left, right, stereoParams,ut, bs, range, lower, upper)
    files_left = {};
    files = dir(strcat(left , '*.png'));
    for file = files'
        file.folder = strcat(file.folder, '\');
        full_name = strcat(file.folder, file.name);
        files_left = [files_left, full_name];
    end
    files_right = {};
    files = dir(strcat(right , '*.png'));
    for file = files'
        file.folder = strcat(file.folder, '\');
        full_name = strcat(file.folder, file.name);
        files_right = [files_right, full_name];
    end
    
    files_left;
    files_right;
    [sallang, s] = size(files_right);
    for i=1:s
        temp_1 = files_left{i};
        temp_2 = files_right{i};
        
        %[Z, A, disparityMap, I1_r] = count_disparity(temp_1, temp_2, stereoParams, 0 , 5, 128, 3000, 4000);
        [Z, A, disparityMap, I1_r] = count_disparity(temp_1, temp_2, stereoParams, ut, bs, range, lower, upper);
        
        name = strcat('disparities\', int2str(i), '_stereoAnaglyph.png');
        imwrite(A, name);
        
        name = strcat('disparities\', int2str(i), '_disMap.png');
        %imwrite(disparityMap, name);
        figure;
        imshow(disparityMap, [0, range]);
        saveas(gcf, name);
        
        name = strcat('disparities\', int2str(i), '_mask.png');
        imwrite(I1_r,  name);
    end
    
    
    
end

