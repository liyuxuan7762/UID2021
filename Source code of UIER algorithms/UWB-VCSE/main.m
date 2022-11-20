%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    File: UWB_VCE.m                                         %
%    Author: XinJie_Li                                       %
%    Date: Feb/2020                                          %
%    A Hybrid Framework for Underwater Image enhancement     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
close all;
tic;

I = im2double(imread('2_SI.png')); 

%----------------------------------
%Parameter configurations
para.alpha=0.28;  % 0.2 0.25
para.beta=0.005; % 0.06 0.01
para.lambda =5; %6 5

para.t=0.9; % 0<t<1,the step size.
% __________________________________
Op=UWB_VCE(I,para);
Op=strech_color(Op);%Histogram streching

figure, imshow([I Op], 'Border','tight');
imwrite(Op,'0500.png')
toc;