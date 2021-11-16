clear;clc;
folder = 'Y:\hao\25_03_2019\lung_cancer_microtube_mgarnet2\';
gname='fov3_r_hemisphere.tiff';
gch=zeros(512,512,66,'uint16');
gsavepath=fullfile(folder,gname);
ori_g=Tiff(gsavepath,'r');
for i=1:66
    ori_g.setDirectory(i);
    gch(:,:,i)=flip(ori_g.read(),1);
end
yz_pro=MIP(gch,6.5,62.5,0.2,'yz');
xy_pro=MIP(gch,6.5,62.5,0.2,'xy');
yz_pro=uint16(yz_pro/max(max(yz_pro))*65535);
xy_pro=uint16(xy_pro/max(max(xy_pro))*65536);
imwrite(xy_pro,'xy_pro.tif')
imwrite(yz_pro,'yz_pro.tif')