path = 'C:\Users\李宇轩\Desktop\新建文件夹 (2)\原图';

numberOfImages = 4;


for i=1:numberOfImages
    disp(i);
    img  = char(strcat(path, filesep, string(name(i))));
    imgname = name(i);
    img = imread(img);
    img = wdf_chs(img);
    imwrite(img, imgname);
end