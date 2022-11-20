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