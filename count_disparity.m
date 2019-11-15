
%[Z, A, dismap, I1_r, I2_r, t, r] = count_disparity('testOut\left\img_0.png','testOut\right\img_0.png', stereoParams, 0 ,9, 128, 3700, 4500);
%[Z, A, dismap, i] = count_disparity('testOut\left\img_0.png','testOut\right\img_0.png', stereoParams, 0 ,9, 128, 3700, 4500);
function [Z, A, disparityMap, I1_r, I2_r, t, r, line_two_points] = count_disparity(i1, i2, stereoParams, ut, bs, range, lower, upper)
    close all;
    I1_skin = human_skin(i1);
    I2_skin = human_skin(i2);
    I1 = imread(i1);
    I2 = imread(i2);
    
    mask1 = cat(3, I1_skin, I1_skin, I1_skin);
    mask2 = cat(3, I2_skin, I2_skin, I2_skin);
    
    I1(~mask1) = 0;
    I2(~mask2) = 0;
    figure
    imshow(I1)
    figure
    imshow(I2)
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
    title("JAJJDEJOOO");
    
    se = strel('disk', 3);
    afteropen = imopen(I1_r, se);
    
    figure;
    imshow(afteropen);
    title("OPEEN");
    
    test_skel = bwmorph(afteropen(:,:,3), 'skel', Inf);
    
        
    figure;
    imshow(test_skel);
    title("CSONTOS");
    k = .5;
    b = 10;
    ptNum = 200;
    outlrRatio = .4;
    inlrStd = 5;
    pts = genRansacTestPoints(100,0.5,inlrStd,[k b]);
    
    [x_size,y_size] = size(test_skel);
    
    k = 1;
    for x = 1:x_size
        for y = 1:y_size
            if test_skel(x,y) > 0
                pts_image(1,k) = y;
                pts_image(2,k) = x;
                k = k + 1;
            end
        end
    end
    
    figure,plot(pts_image(1,:),pts_image(2,:),'.'),hold on
    
    
    
   % RANSAC
    iterNum = 300;
    thDist = 2;
    thInlrRatio = .1;
    [t,r] = ransac(pts_image,iterNum,thDist,thInlrRatio);
    k1 = -tan(t);
    b1 = r/cos(t);
    X = 0:600;
    imshow(I1_r);hold on;
    plot(X, k1*X+b1,'r')
    
    rad = r;
    theta = t;
    
    line_x1 = 1;
    line_x2 = 1;
    line_y1 = 1;
    line_y2 = 1;
    
    point_1_found = false;
    
    [~, loop_end] = size(afteropen(1,:,1));
    for temp_x = 1:loop_end
        if  ~point_1_found
            line_y1 = round((rad-temp_x*cos(theta))/(sin(theta)));
        else
            line_y2 = round((rad-temp_x*cos(theta))/(sin(theta)));
        end
        
        if  ~point_1_found && afteropen(temp_x,line_y1, 1) > 20 && afteropen(temp_x,line_y1, 2) > 20 && afteropen(temp_x,line_y1, 3) > 20
            line_x1 = temp_x;
            point_1_found = true;
        elseif point_1_found && afteropen(temp_x,line_y2, 1) < 20 && afteropen(temp_x,line_y2, 2) < 20 && afteropen(temp_x,line_y2, 3) < 20
            line_x2 = temp_x;
            break;
        end
    end
    
%     afteropen(line_x1,round(line_y1), 1) = 255;
%     afteropen(line_x1,round(line_y1), 2) = 0;
%     afteropen(line_x1,round(line_y1), 3) = 0;
%     
%     afteropen(line_x2,round(line_y2), 1) = 255;
%     afteropen(line_x2,round(line_y2), 2) = 0;
%     afteropen(line_x2,round(line_y2), 3) = 0;
    
    
    afteropen = draw_pointer(afteropen,line_x1,line_y1);
    
    afteropen = draw_pointer(afteropen,line_x2,line_y2);
    
    figure;
    title('POINTS')
    imshow(afteropen);
    
    line_z1 = Z(line_y1, line_x1);
    line_z2 = Z(line_y2, line_x2);
    
    line_two_points = [line_x1 line_y1 line_z1; line_x2 line_y2 line_z2]
    
    
    
    %vall
    %x: 229
    %y: 290
    %z: 49.6875
    
    %ujj
    %x: 274
    %x: 267
    %z: 63.9375
    
    %disparityMap(221, 295) %vall
    %disparityMap(274, 267) %ujj
    
    
    %err1 = sqrError(k1,b1,pts(:,1:ptNum*(1-outlrRatio)))

    
    
end
