function BW1 = human_skin(image_path)
    %Detection of Face on the basis of skin color
    close all;
    clc
    I=imread(image_path);
    %imshow(I)
    cform = makecform('srgb2lab');
    J = applycform(I,cform);
    %figure;imshow(J);
    K=J(:,:,2);
    %figure;imshow(K);
    L=graythresh(J(:,:,2));
    BW1=im2bw(J(:,:,2),L);
    figure;imshow(BW1);
    M=graythresh(J(:,:,3));
    %figure;imshow(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    %figure;imshow(BW2);
    O=BW1.*BW2;
    % Bounding box
    P=bwlabel(O,8);
    BB=regionprops(P,'Boundingbox');
    BB1=struct2cell(BB);
    BB2=cell2mat(BB1);
    [s1 s2]=size(BB2);
    mx=0;
    for k=3:4:s2-1
        p=BB2(1,k)*BB2(1,k+1);
        if p>mx & (BB2(1,k)/BB2(1,k+1))<1.8
            mx=p;
            j=k;
        end
    end
    %figure,imshow(I);
    hold on;
    rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' )
end