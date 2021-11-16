clear;
clc;
path = 'Y:\Petr\20_02_07\';
datapath = [path filesep];
%frame mol x y photon
[imgfile, imgpath] = uigetfile_rui('*.tif', 'please simulation image');
img = tiff_reader_rui(imgfile);
[x y z]=size(img);
img_full=zeros(x,y,z*2-1);
cor_ori=linspace(1,z*2-1,z);
cor_inter=linspace(1,z*2-1,z*2-1);
for i=1:x
    for j=1:y
        temp=double(reshape(img(i,j,:),[z,1]));
        temp=(interp1(cor_ori,temp,cor_inter));
        img_full(i,j,:)=reshape(temp,[1,1,z*2-1]);
    end
end
img_full=uint16(img_full);
% theta = -33/180*pi;
% t = [1 0 0 0;
%      0 cos(theta) -sin(theta) 0;
%      0 sin(theta) cos(theta) 0;
%      0 0 0 1];
% tform = affine3d(t);
% mriVolumeRotated = imwarp(img_full,tform);
% mriVolumeRotated=uint16(mriVolumeRotated);
for j=1:199
    imwrite(img_full(:,:,j),'im_bio_cord_trim.tif','WriteMode','append');
end