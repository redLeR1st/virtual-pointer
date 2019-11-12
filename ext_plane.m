%[Z, A, dismap, i] = count_disparity('testOut\left\img_0.png','testOut\right\img_0.png', stereoParams, 0 ,9, 128, 3700, 4500);
function [Z, A, disparityMap, I1_r] = ext_plane(i1, i2, stereoParams, ut, bs, range, lower, upper)
    close all;

    I1 = imread(i1);
    I2 = imread(i2);
    
    %------------------
    [I1_r,I2_r] = rectifyStereoImages(I1, I2, stereoParams, 'OutputView','full');
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
    %I1_r(mask) = 255;
    figure;
    imshow(I1_r,'InitialMagnification', 100);
    
    %x1 = 229;
    %y1 = 131;
    %x2 = 504;
    %y2 = 176;
    %x3 = 505;
    %y3 = 391;
    
    x1 = 400;
    y1 = 1;
    x2 = 1;
    y2 = 1;
    x3 = 1;
    y3 = 1;
    
    
    vall = 63
    %vall = disparityMap(240,288);
    ujj = disparityMap(274,267)
    
    z1 = disparityMap(x1,y1)
    z2 = disparityMap(x2,y2)
    z3 = disparityMap(x3,y3)
    
    
    Z = [x1, y1, 1;x2, y2, 1;x3, y3, 1];
    
    surfnorm(Z)
    
end