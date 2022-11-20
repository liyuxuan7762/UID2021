clc;
clear all;

% image number is from 1~56
% input = load_image(47); 
input= imread('C:\Users\ÀîöÎ½Ü\Desktop\work\Xinjie Li-20210222\Source Images\Blue-Green\SI_BG_7.png');
output = underwater(input);
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(output)
uiqm = UIQM(output)
figure,imshow(input), title('original image');
figure,imshow(output),title('enhanced image');