function [img breakflag]=Fcn_deconv(Image3D,data_psf,stepsize_img,stepsize_psf,num_iter,binsize)
%% modification on psf adapts psf to image step size
if stepsize_img>stepsize_psf  %down sampling PSF
    coef_ds=stepsize_img/stepsize_psf;
    [x y z]=size(data_psf);
    slice_num=floor((z-(z-1)/2)/coef_ds)+floor(((z-1)/2-1)/coef_ds)+1;
    data_psf_new=zeros(x,y,slice_num);
    for i=1:slice_num
        idx=1+rem((z-1)/2-1,coef_ds)+(i-1)*coef_ds;
        data_psf_new(:,:,i)=data_psf(:,:,idx);
    end
else  %interpolate PSF
    coef_interp=stepsize_psf/stepsize_img;
    [x y z]=size(data_psf);
    cor_ori=linspace(1,(z-1)*coef_interp+1,z);
    cor_inter=linspace(1,(z-1)*coef_interp+1,(z-1)*coef_interp+1);
    data_psf_new=zeros(x,y,(z-1)*coef_interp+1);
    for i=1:x
        for j=1:y
            temp=double(reshape(data_psf(i,j,:),[z,1]));
            temp=interp1(cor_ori,temp,cor_inter,'spline');
            data_psf_new(i,j,:)=reshape(temp,[1,1,(z-1)*coef_interp+1]);            
        end
    end
end
data_psf_new=Fcn_imagebin(data_psf_new,binsize);
data_psf_new=double(data_psf_new);
data_psf_new=data_psf_new/sum(sum(sum(data_psf_new)));
%% deconvolution
[a b c]=size(Image3D);
[d e f]=size(data_psf_new);
Image3D=double(Image3D);
data_psf_new=double(data_psf_new);
% Normalize_V=max(max(max(Image3D)));
% data_psf_new=data_psf_new/max(max(max(data_psf_new)))*Normalize_V;
if  rem(a,2)==1
    Image3D=Image3D(1:a-1,:,:);
end
if rem(b,2)==1
    Image3D=Image3D(:,1:b-1,:);
end
[a b c]=size(Image3D);
img1=Image3D(1:a/2+2*d,1:b/2+2*e,:);%left up
img2=Image3D(1:a/2+2*d,b/2-2*e+1:b,:);%right up
img3=Image3D(a/2-2*d+1:a,1:b/2+2*e,:);%left down
img4=Image3D(a/2-2*d+1:a,b/2-2*e+1:b,:);%right down
imgcell_pre=cell(4);
imgcell_pre{1}=img1;
imgcell_pre{2}=img2;
imgcell_pre{3}=img3;
imgcell_pre{4}=img4;
imgcell_post=cell(4);
%-----------------Lese Bild in 3D Matrix ein------------------------------
Image3D_deconv = zeros(a,b,c,'double');
parfor j=1:4
imgcell_post{j}=deconvlucy(imgcell_pre{j},data_psf_new,num_iter);
end
Image3D_deconv(1:a/2,1:b/2,:)=imgcell_post{1}(1:a/2,1:b/2,:);
Image3D_deconv(1:a/2,b/2+1:b,:)=imgcell_post{2}(1:a/2,2*e+1:b/2+2*e,:);
Image3D_deconv(a/2+1:a,1:b/2,:)=imgcell_post{3}(2*d+1:a/2+2*d,1:b/2,:);
Image3D_deconv(a/2+1:a,b/2+1:b,:)=imgcell_post{4}(2*d+1:a/2+2*d,2*e+1:b/2+2*e,:);
img=uint16(Image3D_deconv);
breakflag=false;
end