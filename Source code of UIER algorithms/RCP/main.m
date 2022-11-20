clc,clear
%load image
num = 57; % 57,51,50,47,36,37,38
% img = load_image(num);
img= imread('C:\Users\李鑫杰\Desktop\work\Xinjie Li-20210222\Source Images\Blue-Green\SI_BG_7.png');
[m, n, ~] = size(img);
% get each channel and normlization
imgR = double(img(:, :, 1)) / 255;
imgG = double(img(:, :, 2)) / 255;
imgB = double(img(:, :, 3)) / 255;
% inverse red component
imgRx = 1 - imgR;
% get the saturation component
Max = reshape(max([reshape(imgR, 1, m*n); reshape(imgG, 1, m*n); ...
    reshape(imgG, 1, m*n)]), m, n);
Min = reshape(min([reshape(imgR, 1, m*n); reshape(imgG, 1, m*n); ...
    reshape(imgG, 1, m*n)]), m, n);
sat = (Max - Min) ./ Max;

% find water light
blocksize = 25;
showFigure = 0;
A = findAirlight2(cat(3, imgR, imgG, imgB), blocksize, showFigure);
%A  = findAirlight1(cat(3, imgR, imgG, imgB));

% get transmission map
% initialize the degradation parameter
if mean2(imgG) > mean2(imgB)
    Nrer = [0.8, 0.97, 0.95];
else
    Nrer = [0.8, 0.93, 0.95];
end
betar = -log(Nrer(1));
betag = -log(Nrer(2));
betab = -log(Nrer(3));

krnlsz = 10;
minRx = minfilt2(imgRx, [krnlsz, krnlsz]);
minRx(m,n) = 0;
minG = minfilt2(imgG, [krnlsz, krnlsz]);
minG(m,n) = 0;
minB = minfilt2(imgB, [krnlsz, krnlsz]);
minB(m,n) = 0;
minsat = minfilt2(sat, [krnlsz, krnlsz]);
minsat(m,n) = 0;

lambda = 0.5;
t = reshape(min([reshape(minRx/(1-A(1)), 1, m*n);...
    reshape(minG/A(2), 1, m*n); reshape(minB/A(3), 1, m*n); ...
    reshape(lambda*minsat, 1, m*n)]), m, n);
%figure,imshow(t)
r = krnlsz;
eps = 10^-6;
t = guidedfilter(double(rgb2gray(img))/255, 1 - t, r, eps);
%figure,imshow(t)
tr = t;
tg = tr.^(betag/betar);
tb = tr.^(betab/betar);

% final step
t0 = 0.1;
%Airlight = sum(A) / length(A);
Jr = (imgR - A(1)) ./ max(t, t0) + (1 - A(1)) * A(1);
%Jr = (imgR - A(1) ) ./ max(tr, t0) + Airlight;
Jr=(Jr - min(min(Jr))) / (max(max(Jr)) - min(min(Jr)));
Jg = (imgG - A(2)) ./ max(t, t0) + (1 - A(2)) * A(2);
%Jg = (imgG - A(2) ) ./ max(tg, t0) + Airlight;
Jg=(Jg - min(min(Jg))) / (max(max(Jg)) - min(min(Jg)));
Jb = (imgB - A(3)) ./ max(t, t0) + (1 - A(3)) * A(3);
%Jb = (imgB - A(3)) ./ max(tb, t0) + Airlight;
Jb=(Jb - min(min(Jb))) / (max(max(Jb)) - min(min(Jb)));
%SCB = SimplestColorBalance(cat(3,Jr,Jg,Jb));
%figure,imshow([double(img)/255, cat(3,Jr,Jg,Jb), SCB])
%figure,imshow([double(img) / 255, cat(3,Jr,Jg,Jb)])
%title('red channel')
J = cat(3,Jr,Jg,Jb);
J = uint8(J * 255);
%[meanRG, deltaRG, meanYB, deltaYB, uicm] = UICM(J)
imshow([img,J])
imwrite(J,'C:\Users\李鑫杰\Desktop\对比\arcp907.jpg');