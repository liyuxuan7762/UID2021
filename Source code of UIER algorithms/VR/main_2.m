% clc;
% clear all;

% image number is from 1~56
function output=main_2(input)
% input = load_image(47); 

output = underwater(input);
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(output)
% uiqm = UIQM(output)
%figure,imshow(input), title('original image');
%figure,imshow(output),title('enhanced image');