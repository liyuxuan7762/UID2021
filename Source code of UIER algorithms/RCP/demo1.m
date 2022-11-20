% get the waterlight using the method from 2013-JVCIR
clc,clear
%load image
num = 47; % 57,51,50,47,36,37,38
img = load_image(num);
[m, n, ~] = size(img);
% get each channel and normlization
imgR = double(img(:, :, 1)) / 255;
imgG = double(img(:, :, 2)) / 255;
imgB = double(img(:, :, 3)) / 255;
if mean2(imgG) > mean2(imgB)
    Nrer = [0.8, 0.97, 0.95];
else
    Nrer = [0.8, 0.93, 0.95];
end
% inverse red component
imgRx = 1 - imgR;
% get the saturation component
Max = reshape(max([reshape(imgR, 1, m*n); reshape(imgG, 1, m*n); ...
    reshape(imgG, 1, m*n)]), m, n);
Min = reshape(min([reshape(imgR, 1, m*n); reshape(imgG, 1, m*n); ...
    reshape(imgG, 1, m*n)]), m, n);
sat = (Max - Min) ./ Max;

% find the waterlight using the 2013-JVCIR
im = img;
blocksize = 25;
[M, N, ~] = size(im);
point = [0,0];
y = 1;
while max(M, N) > blocksize
    [M, N, ~] = size(im);
    subim{1} = im(1:floor(M/2), 1:floor(N/2), :);
    subim{2} = im(1:floor(M/2), floor(N/2)+1:end, :);
    subim{3} = im(floor(M/2)+1:end, 1:floor(N/2), :);
    subim{4} = im(floor(M/2)+1:end, floor(N/2)+1:end, :);
    s(1) = mean2(subim{1}(:,:,1)) - std2(subim{1}(:,:,1)) + ...
        mean2(subim{1}(:,:,2)) - std2(subim{1}(:,:,2)) + ...
        mean2(subim{1}(:,:,3)) - std2(subim{1}(:,:,3));
    s(2) = mean2(subim{2}(:,:,1)) - std2(subim{2}(:,:,1)) + ...
        mean2(subim{2}(:,:,2)) - std2(subim{2}(:,:,2)) + ...
        mean2(subim{2}(:,:,3)) - std2(subim{2}(:,:,3));
    s(3) = mean2(subim{3}(:,:,1)) - std2(subim{3}(:,:,1)) + ...
        mean2(subim{3}(:,:,2)) - std2(subim{3}(:,:,2)) + ...
        mean2(subim{3}(:,:,3)) - std2(subim{3}(:,:,3));
    s(4) = mean2(subim{4}(:,:,1)) - std2(subim{4}(:,:,1)) + ...
        mean2(subim{4}(:,:,2)) - std2(subim{4}(:,:,2)) + ...
        mean2(subim{4}(:,:,3)) - std2(subim{4}(:,:,3));
    x = find(s == max(s));
    im = subim{x};
    % below used for draw patch
    %startpoint = [1,1;1,floor(N/2)+1;floor(M/2)+1,1;...
    %    floor(M/2)+1,floor(N/2)+1];
    %if y > 1
    %    point = point + startpoint(x,:);% + [-1, -1];
    %else
    %point = point + startpoint(x,:);
    %end
    %y = y + 1;
end
[M, N, ~] = size(im);
im1 = zeros(M,N);
im = double(im);
for i = 1:M
    for j = 1:N
        im1(i,j) = sqrt((im(i,j,1)-0)^2 + (im(i,j,2)-255)^2 + ...
            (im(i,j,3)-255)^2);
    end
end
[p, q] = find(im1 == min(min(im1)));
A = reshape(im(p(1),q(1),:) / 255, [1, 3]);
% draw the patch in the original image
%[state,data]=draw_rect(img,point,[M,N],1);

% get the red channel
krnlsz = 10;
minRx = minfilt2(imgRx, [krnlsz, krnlsz]);
minRx(m,n) = 0;
minG = minfilt2(imgG, [krnlsz, krnlsz]);
minG(m,n) = 0;
minB = minfilt2(imgB, [krnlsz, krnlsz]);
minB(m,n) = 0;
minsat = minfilt2(sat, [krnlsz, krnlsz]);
minsat(m,n) = 0;
Ired = reshape(min([reshape(minRx, 1, m*n); reshape(minG, 1, m*n); ...
    reshape(minB, 1, m*n); reshape(minsat, 1, m*n)]), m, n);
%figure,imshow(Ired)
% get transmission map
lambda = 0.5;
t = reshape(min([reshape(minRx/(1-A(1)), 1, m*n);...
    reshape(minG/A(2), 1, m*n); reshape(minB/A(3), 1, m*n); ...
    reshape(lambda*minsat, 1, m*n)]), m, n);
%figure,imagesc(t), axis image, truesize;
t = 1 - t;
%figure,imshow(t);
%figure,imagesc(t), axis image, truesize;
r = krnlsz;
eps = 10^-6;
t = guidedfilter(double(rgb2gray(img))/255, t, r, eps);
% testing: three different t
beta_red = -log10(Nrer(1));
beta_green = -log10(Nrer(2));
beta_blue = -log10(Nrer(3));
tr = t;
tg = tr.^(beta_green/beta_red);
tb = tr.^(beta_blue/beta_red);
%figure,imshow(t);
%figure,imagesc(t), axis image, truesize; colorbar
%t = SimplestColorBalance(t);
%figure,imshow(t);
%figure,imagesc(t), axis image, truesize;
D = 1;
% final step
t0 = 0.1;
Jr = (imgR - A(1)) ./ max(t, t0) + (1 - A(1)) * A(1);
%Jr = (imgR - A(1)) ./ max(t, t0) + A(1);
%Jr=(Jr - min(min(Jr))) / (max(max(Jr)) - min(min(Jr)));
Jg = (imgG - A(3)) ./ max(t, t0) + (1 - A(2)) * A(2);
%Jg = (imgG - A(3)) ./ max(t, t0) + A(2);
%Jg=(Jg - min(min(Jg))) / (max(max(Jg)) - min(min(Jg)));
Jb = (imgB - A(3)) ./ max(t, t0) + (1 - A(3)) * A(3);
%Jb = (imgB - A(3)) ./ max(t, t0) + A(3);
%Jb=(Jb - min(min(Jb))) / (max(max(Jb)) - min(min(Jb)));
%SCB = SimplestColorBalance(cat(3,Jr,Jg,Jb));
%figure,imshow([double(img)/255, cat(3,Jr,Jg,Jb)])
figure, imagesc(cat(3,Jr,Jg,Jb)), axis image, truesize;
%figure,imshow(SCB)
%adapthisteq,fcnBPDFHE
%BPDFHE: Brightness Preserving Dynamic Fuzzy Histogram Equalization
%HE = cat(3,histeq(Jr),histeq(Jg),histeq(Jb));
%aHE = cat(3,adapthisteq(Jr),adapthisteq(Jg),adapthisteq(Jb));
%bHE = cat(3,fcnBPDFHE(Jr),fcnBPDFHE(Jg),fcnBPDFHE(Jb));





%**********************Plot**************************
% Iorg = double(img)/255;
% Ires = cat(3,Jr,Jg,Jb);
% %figure,
% %subplot(221), imshow(Iorg), title('Original')
% %subplot(222), imshow(Ires), title('Restored by red channel')
% %subplot(223), imshow(SCB), title('After SCB method')
% %subplot(224), imshow(aHE), title('After CLAHE method')
% figure,imshow(Iorg), title('Original')
% figure,imshow(Ires), title('Restored by red channel')
% figure,imshow(SCB), title('After SCB method')
% figure,imshow(aHE), title('After CLAHE method')
% % plot the color locations of each pixel of the image in the RGB space
% %figure,
% %subplot(221)
% figure,plot3(Iorg(:,:,1),Iorg(:,:,2),Iorg(:,:,3), '.b'),grid on
% xlabel('R'),ylabel('G'),zlabel('B'),title('RGB space of original')
% %subplot(222)
% figure,plot3(Ires(:,:,1),Ires(:,:,2),Ires(:,:,3), '.b'),grid on
% xlabel('R'),ylabel('G'),zlabel('B'),title('RGB space of restored')
% %subplot(223)
% figure,plot3(SCB(:,:,1),SCB(:,:,2),SCB(:,:,3), '.b'),grid on
% xlabel('R'),ylabel('G'),zlabel('B'),title('RGB space of SCB')
% %subplot(224)
% figure,plot3(aHE(:,:,1),aHE(:,:,2),aHE(:,:,3), '.b'),grid on
% xlabel('R'),ylabel('G'),zlabel('B'),title('RGB space of CLAHE')
% % plot histogram
% figure,
% subplot(341),imhist(Iorg(:,:,1)),title('RC of Org')
% subplot(342),imhist(Ires(:,:,1)),title('RC of Restored')
% subplot(343),imhist(SCB(:,:,1)),title('RC after SCB')
% subplot(344),imhist(aHE(:,:,1)),title('RC after CLAHE')
% subplot(345),imhist(Iorg(:,:,2)),title('GC of Org')
% subplot(346),imhist(Ires(:,:,2)),title('GC of Restored')
% subplot(347),imhist(SCB(:,:,2)),title('GC after SCB')
% subplot(348),imhist(aHE(:,:,2)),title('GC after CLAHE')
% subplot(349),imhist(Iorg(:,:,3)),title('BC of Org')
% subplot(3,4,10),imhist(Ires(:,:,3)),title('BC of Restored')
% subplot(3,4,11),imhist(SCB(:,:,3)),title('BC after SCB')
% subplot(3,4,12),imhist(aHE(:,:,3)),title('BC after CLAHE')

%compare different HE
% figure,
% subplot(221), imshow(Ires), title('Restored by red channel')
% subplot(222), imshow(HE), title('After histeq')
% subplot(223), imshow(aHE), title('After adapthisteq')
% subplot(224), imshow(bHE), title('After Histeq method')
% 
% figure,
% subplot(221)
% plot3(Ires(:,:,1),Ires(:,:,2),Ires(:,:,3), '.b'),grid on
% xlabel('r'),ylabel('g'),zlabel('b'),title('RGB space of restored')
% subplot(222)
% plot3(HE(:,:,1),HE(:,:,2),HE(:,:,3), '.b'),grid on
% xlabel('r'),ylabel('g'),zlabel('b'),title('RGB space of histeq')
% subplot(223)
% plot3(aHE(:,:,1),aHE(:,:,2),aHE(:,:,3), '.b'),grid on
% xlabel('r'),ylabel('g'),zlabel('b'),title('RGB space of adapthisteq')
% subplot(224)
% plot3(bHE(:,:,1),bHE(:,:,2),bHE(:,:,3), '.b'),grid on
% xlabel('r'),ylabel('g'),zlabel('b'),title('RGB space of BPDFHE')
% 
% figure,
% subplot(341),imhist(Ires(:,:,1)),title('red channel')
% subplot(342),imhist(HE(:,:,1)),title('red channel')
% subplot(343),imhist(aHE(:,:,1)),title('red channel')
% subplot(344),imhist(bHE(:,:,1)),title('red channel')
% subplot(345),imhist(Ires(:,:,2)),title('green channel')
% subplot(346),imhist(HE(:,:,2)),title('green channel')
% subplot(347),imhist(aHE(:,:,2)),title('green channel')
% subplot(348),imhist(bHE(:,:,2)),title('green channel')
% subplot(349),imhist(Ires(:,:,3)),title('blue channel')
% subplot(3,4,10),imhist(HE(:,:,3)),title('blue channel')
% subplot(3,4,11),imhist(aHE(:,:,3)),title('blue channel')
% subplot(3,4,12),imhist(bHE(:,:,3)),title('blue channel')