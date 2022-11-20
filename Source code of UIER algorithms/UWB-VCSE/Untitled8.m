path = 'E:\database\水下数据集\Raw-890 Resized';

numberOfImages = 392;


parfor i=1:numberOfImages
    disp(i);
    img  = char(strcat(path, filesep, string(name(i))));
    imgname = name(i);
    img = imread(img);
    img = main_2(img);
    imwrite(img, imgname);
end