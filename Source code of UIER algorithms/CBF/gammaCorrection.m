function [ result ] = gammaCorrection(image, a, gamma)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

image = im2double(image);

result = a * (image .^ gamma);

end

