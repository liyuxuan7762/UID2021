function img = load_image(num)
% num is the num of image with 

prefix = 'D:\สตั้\raw-890\';
suffix = '_img_.png';
path = [prefix,num2str(num),suffix];

img = imread(path);