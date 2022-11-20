%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cited EAAI paper: Bayesian Retinex Underwater Image Enhancement, 
%% Peixian Zhuang, Chongyi Li, Jiamin Wu, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code written by Peixian Zhuang, Tsinghua University
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;   clc;  clear all;


%% Input Raw Image
img1 = double(imread('Ori2.jpg'));


%% color correction
img  = double(color(img1,2.5));


%% RGB TurnTo HSV
cform = makecform('srgb2lab'); 
lab   = applycform(uint8(img), cform);
LL    = lab(:,:,1);
A     = lab(:,:,2);
B     = lab(:,:,3);


%% Retinex Variational Enhancement
[R, L] = retinex_variationa_enhancement(img,LL);



%% Gamma Correction
[R22, L22] =Gamma_correction(R, L);


%% HSV ReTurnTo RGB
lab(:,:,1)      = L22.*R22;
cform        = makecform('lab2srgb'); 
enhanced3 = applycform(lab, cform);
enhanced3 = cast(enhanced3, 'uint8');


%% output display
figure,imshow(uint8([img1, enhanced3]))

