path = 'E:\database\≤‚ ‘75\‘≠Õº';

numberOfImages = 75;

parfor i=1:numberOfImages
    disp(i);
    img  = char(strcat(path, filesep, string(name(i))));
    imgname = name(i);
    UWB_fun(img, imgname);
end