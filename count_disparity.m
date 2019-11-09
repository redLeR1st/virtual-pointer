
function [Z, A, disparityMap, I1_r] = count_disparity(i1, i2, stereoParams, ut, bs, range, lower, upper)
    close all;
    I1 = imread(i1);
    I2 = imread(i2);
    %------------------
    [I1_r,I2_r] = rectifyStereoImages(I1,I2,stereoParams, 'OutputView','full');
    %------------------
    A = stereoAnaglyph(I1_r,I2_r);
    figure
    imshow(A)
    title('Red-Cyan composite view of the rectified stereo pair image');
    %------------------
    J1 = rgb2gray(I1_r);
    J2 = rgb2gray(I2_r);
    %------------------
    disparityRange = [0 range];
    disparityMap = disparity(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold', ut, 'BlockSize', bs);
    %-----------------
    figure;
    imshow(disparityMap,disparityRange)
    title('Disparity Map');
    colormap jet;
    colorbar;
    %---------------
    xyzPoints = reconstructScene(disparityMap,stereoParams);
    %---------------
    Z = xyzPoints(:,:,3);
    mask = repmat(Z > lower & Z < upper,[1,1,3]);
    I1_r(~mask) = 0;
    figure;
    imshow(I1_r,'InitialMagnification', 100);
    
end
