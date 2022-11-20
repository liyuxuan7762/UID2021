function A = findAirlight2(img, blocksize, showFigure)
im = img;
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
    if showFigure
        % below used for draw patch
        startpoint = [1,1;1,floor(N/2)+1;floor(M/2)+1,1;...
            floor(M/2)+1,floor(N/2)+1];
        if y > 1
            point = point + startpoint(x,:);% + [-1, -1];
        else
            point = point + startpoint(x,:);
        end
        y = y + 1;
    end
end
[M, N, ~] = size(im);
im1 = zeros(M,N);
im = double(im);
for i = 1:M
    for j = 1:N
        im1(i,j) = sqrt((im(i,j,1)-255)^2 + (im(i,j,2)-255)^2 + ...
            (im(i,j,3)-255)^2);
    end
end
[p, q] = find(im1 == min(min(im1)));
A = reshape(im(p(1),q(1),:), [1, 3]);
if showFigure
    % draw the patch in the original image
    [state,data]=draw_rect(img,point,[M,N],1);
end





function [state,result]=draw_rect(data,pointAll,windSize,showOrNot)
% [state,result]=draw_rect(data,pointAll,windSize,showOrNot)
%          pointAll start location
%          windSize the patch size
%          showOrNot whether show the image

if nargin < 4
    showOrNot = 1;
end
rgb = [255 0 0];                                 
lineSize = 1;

windSize(1,1)=windSize(1,1);
windSize(1,2) = windSize(1,2);
if windSize(1,1) > size(data,1) ||...
        windSize(1,2) > size(data,2)
    state = -1;                                     
    disp('the window size is larger then image...');
    return;
end

result = data;
if size(data,3) == 3
    for k=1:3
        for i=1:size(pointAll,1)   
            result(pointAll(i,1),pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);   
            result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2)+windSize(i,1),k) = rgb(1,k);
            result(pointAll(i,1)+windSize(i,2),pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);  
            result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2),k) = rgb(1,k);  
            if lineSize == 2 || lineSize == 3
                result(pointAll(i,1)+1,pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);  
                result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2)+windSize(i,1)-1,k) = rgb(1,k);
                result(pointAll(i,1)+windSize(i,2)-1,pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);
                result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2)+1,k) = rgb(1,k);
                if lineSize == 3
                    result(pointAll(i,1)+1,pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);   
                    result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2)+windSize(i,1)+1,k) = rgb(1,k);
                    result(pointAll(i,1)+windSize(i,2)+1,pointAll(i,2):pointAll(i,2)+windSize(i,1),k) = rgb(1,k);
                    result(pointAll(i,1):pointAll(i,1)+windSize(i,2),pointAll(i,2)+1,k) = rgb(1,k);
                end
            end
        end
    end
end
state = 1;
if showOrNot == 1
    figure;
    imshow(result);
end
