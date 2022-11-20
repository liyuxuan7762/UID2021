function Histogram(Img)
imhist(double(Img(:,:,1)));
hold on
imhist(double(Img(:,:,2)));
imhist(double(Img(:,:,3)));
hold off