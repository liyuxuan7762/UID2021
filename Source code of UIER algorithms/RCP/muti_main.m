clear all;
close all;
clc;
fatherPath=['C:\Users\¿ÓˆŒΩ‹\Desktop\work\Xinjie Li-20210222\Source Images_0227'];
dirs=dir(fatherPath);
dircell=struct2cell(dirs);
for ii=3:length(dircell)
        subdirs=dircell(1,ii);
        SonPath=[fatherPath '\' cell2mat(subdirs)];
        %SonPath=[fatherPath?'\'?cell2mat(subdirs)?'\*.pgm'];
        dirs2=dir(SonPath);
        dircell2=struct2cell(dirs2);
        for jj=3:length(dirs2)
               PictureName=dircell2(1,jj);
               PicturePath=[SonPath '\' cell2mat(PictureName)];
               I=imread(PicturePath);
                %?imgname=[SonPath?'\'?cell2mat(PictureName)?'.png'];
                
                
               J=main_2(I);
                
              sav_name=cell2mat(PictureName);
             imgname=['C:\Users\¿ÓˆŒΩ‹\Desktop\work\Xinjie Li-20210222\Enhanced or Restored Images_0227\' cell2mat(subdirs) '\' 'ERI' sav_name(3:length(sav_name)-4) '_RCP.png'];
                imwrite(J,imgname);
        end
end
