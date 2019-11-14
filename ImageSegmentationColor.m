%% RESET_WORKING_SPACE

% Clear command window.
clc;

% Erase all existing variables.
clear all;

% Close all figures.
close all;

%% IMAGE_ACQUISITION

% Acquire an image from the workspace.
img_orig = imread('cam_1 (10).png');

% Preview it.
set(gcf,'position',get(0,'screensize')) % Max figure 1 size
figure(1);
subplot(3,3,1);
imshow(img_orig);
title('Original Image');

% Clear out the noise.
img_orig(:,:,1) = medfilt2(img_orig(:,:,1), [3 3]);
img_orig(:,:,2) = medfilt2(img_orig(:,:,2), [3 3]);
img_orig(:,:,3) = medfilt2(img_orig(:,:,3), [3 3]);

% Preview it.
figure(1);
subplot(3,3,2);
imshow(img_orig);
title('Noise Filtered');


% Copy of the original image for later transformations.
img = img_orig;

%% MAKE_IMAGE_CONTINUOUS

% Transforming to HSV
hsv = rgb2hsv(img);

% Seperating its channels
h = hsv(:, :, 1);
s = hsv(:, :, 2);
v = hsv(:, :, 3);

% Blur h and s channels.
% Don't blur v channel so the image doesn't look blurred.
s = conv2(s, ones(3)/9, 'same');
h = conv2(h, ones(3)/9, 'same');

% Recombine.
hsv = cat(3, h, s, v);
rgbImage = hsv2rgb(hsv);

% Preview it
figure(1);
subplot(3,3,3);
imshow(rgbImage);
title('Modified');

%% HSV_COLORSPACE

% Transform to HSV.
img_hsv = rgbImage;
hsv = rgb2hsv(img_hsv);

% Preview it.
figure(1);
subplot(3,3,4);
imshow(hsv);
title('HSV');

%% YCBCR_COLORSPACE

% Transform to YCbCr.
img_ycbcr = rgbImage;
ycbcr = rgb2ycbcr(img_ycbcr);

% Preview it.
figure(1);
subplot(3,3,5);
imshow(ycbcr);
title('YCbCr');

%% RGB_COLORSPACE

% making copy of image
rgb = rgbImage;

% preview it.
figure(1);
subplot(3,3,6);
imshow(rgb);
title('RGB');

%% SEGMENTATION

final_image = zeros(size(img_orig,1), size(img_orig,2));
% for loop to loop on rows and
% columns in order to binarize image
for i = 1:size(img_orig,1)
    for j = 1:size(img_orig,2)
        
        r = rgb(i,j,1);
        g = rgb(i,j,2);
        b = rgb(i,j,3);
        
        f = [r,g,b];
        
        h = hsv(i,j,1);
        s = hsv(i,j,2);
        %         v = hsv(i,j,3);
        
        %         y = ycbcr(i,j,1);
        cb = ycbcr(i,j,2);
        cr = ycbcr(i,j,3);
        
        %Using RGB-HS-CbCr color space
        if((r > 50 && g > 40 && b > 20) &...
                (max(f) - min(f) >= 15) &...
                (r > g) && (r > b)) |... % Cond 1 OR Cond 2
                ((r > 220 && g > 210 && b > 170) &&...
                (abs(r-g) <= 15) && (r > b) && (g > b))
            if(cb >= 60 && cb <= 130 && cr >= 130 && cr <= 165)
                if(h >= 0 && h <= 50 && s >= 0.1 && s <= 0.9)
                    % SKIN_PIXELS
                    final_image(i,j,:) = 1;
                else
                    % NON_SKIN_PIXELS
                end
            end
        end
    end
end
figure(1);
subplot(3,3,7);
imshow(final_image);
title('Raw Hand');

%% MORPHOLOGICAL_FILTERING


%% LABELING
