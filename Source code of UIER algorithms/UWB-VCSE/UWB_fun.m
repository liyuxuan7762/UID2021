function UWB_fun(filename, imgname)
    I = im2double(imread(filename)); 

    %----------------------------------
    %Parameter configurations
    para.alpha=0.2;
    para.beta=0.06;
    para.lambda =6;

    para.t=0.5; % 0<t<1,the step size.
    % __________________________________
    Op=UWB_VCE(I,para);
    % Op=strech_color(Op);%Histogram streching

    % figure, imshow([I Op], 'Border','tight');
    imwrite(Op,imgname);

end 
