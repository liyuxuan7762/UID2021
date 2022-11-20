%% 
% Matlab demo code for "A Variational Framework for Underwater Image
%Dehazing and Deblurring"
% 
% created by Jun Xie (my_love_mj@126.com) and Goujia Hou (hgjouc@126.com)
% 
% Copyright @ Jun Xie and Guojia Hou, 2020. 
%This software is free for academic usage. 
%If you publish results obtained using this software, please cite our paper.
%%
%All the experiments are implemented in MATLAB 2016b on an Intel 3.2GHz PC with 8GB RAM.
%This code runs on several versions Matlab included 2014/2016/2018/2019/2020
clear all; close all; clc;
originImage = '.\test4.png';
kernelSize = 13;
[origin, output] = UNTV(originImage,kernelSize);
figure; imshow(origin);title('Original image');
figure; imshow(output);title('Restored image');