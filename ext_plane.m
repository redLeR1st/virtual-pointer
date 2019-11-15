%[Z, A, dismap, i] = count_disparity('testOut\left\img_0.png','testOut\right\img_0.png', stereoParams, 0 ,9, 128, 3700, 4500);
function [Z, A, disparityMap, I1_r] = ext_plane(i1, i2, stereoParams, ut, bs, range, lower, upper)
    close all;

    [Z, A, disparityMap, I1_r, I2_r, theta, rad, line_two_points] = count_disparity('testOut\left\img_0.png','testOut\right\img_0.png', stereoParams, 0 ,9, 128, 3700, 4500);
    I1 = imread(i1);
    I2 = imread(i2);
    
    %------------------
    [I1_r,I2_r] = rectifyStereoImages(I1, I2, stereoParams, 'OutputView','full');
%     %------------------
%     A = stereoAnaglyph(I1_r,I2_r);
%     figure
%     imshow(A)
%     title('Red-Cyan composite view of the rectified stereo pair image');
%     %------------------
%     J1 = rgb2gray(I1_r);
%     J2 = rgb2gray(I2_r);
%     %------------------
%     disparityRange = [0 range];
%     disparityMap = disparity(J1,J2,'DisparityRange',disparityRange,'UniquenessThreshold', ut, 'BlockSize', bs);
%     %-----------------
%     figure;
%     imshow(disparityMap,disparityRange)
%     title('Disparity Map');
%     colormap jet;
%     colorbar;
%     %---------------
%     xyzPoints = reconstructScene(disparityMap,stereoParams);
%     %---------------
%     Z = xyzPoints(:,:,3);
%     mask = repmat(Z > lower & Z < upper,[1,1,3]);
%     I1_r(~mask) = 0;
%     %I1_r(mask) = 255;
%     figure;
%     imshow(I1_r,'InitialMagnification', 100);
    
%     x1 = 229;y1 = 131;
%     x2 = 504;y2 = 131;
%     x3 = 505;y3 = 391;
    
    x1 = 226;
    y1 = 172;
    x2 = 503;
    y2 = 141;
    x3 = 503;
    y3 = 311;
    
%     z1 = Z(y1,x1)
%     z2 = Z(y2,x2)
%     z3 = Z(y3,x3)
    z1 = 5.1378e+03
    z2 = 5.1707e+03
    z3 = 4.9487e+03

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
    
    %P4 = [240,288,vall];
    %P5 = [274,267,ujj];
    
    line_x1 = line_two_points(1,1);
    line_y1 = line_two_points(1,2);
    line_z1 = line_two_points(1,3);
    
    line_x2 = line_two_points(2,1);
    line_y2 = line_two_points(2,2);
    line_z2 = line_two_points(2,3);
    
    P4 = [line_x1, line_y1, line_z1];
    P5 = [line_x2, line_y2, line_z2];
    
    syms t
    line = P4 + t*(P5-P4)
    %line = rad-(sin(theta)*)
    
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
    axis([szilva, korte, szilva, korte, megy, cseresznye]), title 'Cím'
   
    on_projector_X = round(point(1))
    on_projector_Y = round(point(2))
    on_projector_Z = round(point(3))
    
    k1 = -tan(theta);
    b1 = rad/cos(theta);
    X = 0:600;
    hold off;
    figure;
    imshow(I1_r);hold on;
    plot(X, k1*X+b1,'r')
    
    I1_r = draw_pointer(I1_r,on_projector_X,on_projector_Y);
    
    I1_r(line_x1,round(line_y1), 1) = 255;
    I1_r(line_x1,round(line_y1), 2) = 0;
    I1_r(line_x1,round(line_y1), 3) = 255;
    
    I1_r(line_x2,round(line_y2), 1) = 255;
    I1_r(line_x2,round(line_y2), 2) = 0;
    I1_r(line_x2,round(line_y2), 3) = 255;
    
    figure;
    imshow(I1_r);
    
    
end