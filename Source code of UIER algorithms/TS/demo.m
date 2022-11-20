clc 
% clear

% input = imread('C:\Users\ÀîöÎ½Ü\Desktop\raw_in_ACCESS_11_28\387_img_.png');
input = imread('D:\ÊµÑé\raw-890\459_img_.png');

alpha = 0.5;   % parameter alpha

output = undert_water(input,alpha);

figure,imshow([input,output])

