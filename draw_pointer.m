function [ I1_r ] = draw_pointer( I1_r, x, y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    I1_r(x,y, 1) = 255;
    I1_r(x,y, 2) = 0;
    I1_r(x,y, 3) = 0;
    
    I1_r(x-1,y, 1) = 255;
    I1_r(x-1,y, 2) = 0;
    I1_r(x-1,y, 3) = 0;
    
    I1_r(x+1,y, 1) = 255;
    I1_r(x+1,y, 2) = 0;
    I1_r(x+1,y, 3) = 0;
    
    I1_r(x,y-1, 1) = 255;
    I1_r(x,y-1, 2) = 0;
    I1_r(x,y-1, 3) = 0;
    
    I1_r(x,y+1, 1) = 255;
    I1_r(x,y+1, 2) = 0;
    I1_r(x,y+1, 3) = 0;
    
end

