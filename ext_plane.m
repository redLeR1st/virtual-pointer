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
    
    x1 = 229;y1 = 131;
    x2 = 504;y2 = 131;
    x3 = 505;y3 = 391;
    
    %x1 = 400;
    %y1 = 32;
    %x2 = 23;
    %y2 = 42;
    %x3 = 42;
    %y3 = 12;
    
    
    vall = 63
    %vall = disparityMap(240,288);
    %ujj = disparityMap(274,267)
    ujj = 78
    
    z1 = disparityMap(x1,y1)
    z2 = disparityMap(x2,y2)
    z3 = disparityMap(x3,y3)
    z2 = 48
    P1 = [x1,y1,z1];
    P2 = [x2,y2,z2];
    P3 = [x3,y3,z3];
    
    normal = cross(P1-P2, P1-P3)
    
    syms x y z
    P = [x,y,z]
    planefunction = dot(normal, P-P1)
    
    dot(P-P1, normal)
    
    realdot = @(u, v) u*transpose(v);
    
    realdot(P-P1,normal)
    
    % LINE
    P4 = [240,288,vall];
    P5 = [274,267,ujj];
    
    syms t
    line = P4 + t*(P5-P4)
    
    newfunction = subs(planefunction, P, line)
    t0 = solve(newfunction)
    point = subs(line, t, t0)
    subs(planefunction, P, point)
    
    zplane = solve(planefunction, z)
    
    szilva = 200
    korte = 800
    cseresznye = 600 
    megy = 0
    
    
    ezplot3(line(1), line(2), line(3), [-1,3]), hold on
    ezmesh(zplane, [szilva, korte, szilva, korte]), hold off
    axis([szilva, korte, szilva, korte, megy, cseresznye]), title 'C�m'
   
    on_projector_X = round(point(1))
    on_projector_Y = round(point(2))
    
    I2_r(on_projector_X,on_projector_Y, 1) = 255;
    I2_r(on_projector_X,on_projector_Y, 2) = 0;
    I2_r(on_projector_X,on_projector_Y, 3) = 0;
    figure;
    imshow(I2_r);
    
    
end