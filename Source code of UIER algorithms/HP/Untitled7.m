path = 'C:\Users\������\Desktop\�½��ļ��� (2)\ԭͼ';

numberOfImages = 4;


for i=1:numberOfImages
    disp(i);
    img  = char(strcat(path, filesep, string(name(i))));
    imgname = name(i);
    img = imread(img);
    img = wdf_chs(img);
    imwrite(img, imgname);
end