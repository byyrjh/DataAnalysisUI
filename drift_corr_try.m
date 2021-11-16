clear;clc;
x_shift=0;
y_shift=0;
z_shift=0;
for i=1:70
    img_ini(:,:,i)=imtranslate(double(imread('M:\Hao\2021_11_3\well1\fov2\mem_ini-1.tif',i)),[y_shift,x_shift]);
end
temp=img_ini;
img_ini=zeros(size(temp));
img_ini(:,:,1:70-z_shift)=temp(:,:,z_shift+1:end);
img_ini = gpuArray(img_ini);

for i=1:70
    img_medial(:,:,i)=double(imread('M:\Hao\2021_11_3\well1\fov2\mem_end-1.tif',i));
end
img_medial = gpuArray(img_medial);
IMG_INI=fftn(img_ini);
IMG_MEDIAL=fftn(img_medial);
cross_corr=ifftn((IMG_INI).*conj(IMG_MEDIAL));
clear IMG_INI;
clear IMG_MEDIAL;
% cross_corr = gather(cross_corr);
cross_corr=cross_corr/max(max(max(cross_corr)));
[M] = max(cross_corr,[],'all');
for i=1:70
    if ~isempty(find(cross_corr(:,:,i)==M))
        z=i;
        [x y]=find(cross_corr(:,:,i)==M);
    break
    end
end
test=cross_corr(:,:,1);