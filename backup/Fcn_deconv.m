function [img breakflag]=Fcn_deconv(Image3D,data_psf,stepsize_img,stepsize_psf,num_iter);
%% modification on psf adapts psf to image step size
breakflag=logical(0);
f=waitbar(0,'1','Name','Deconvolution is running',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);

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
data_psf_new=uint16(data_psf_new);
data_psf_new=double(data_psf_new);
data_psf_new=data_psf_new/max(max(max(data_psf_new)));
if getappdata(f,'canceling')
    breakflag=~breakflag;
    img=[];
    return
else
    completed='20%completed';
    waitbar(0.2,f,completed);
end
%% deconvolution
[a b c]=size(Image3D);
[d e ff]=size(data_psf_new);
Image3D=double(Image3D);
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
%-----------------Lese Bild in 3D Matrix ein------------------------------
Image3D_deconv = zeros(a,b,c,'uint16');
[J1,~]=deconvblind(img1,data_psf_new,num_iter);
if getappdata(f,'canceling')
    breakflag=~breakflag;
    img=[];
    return
else
    completed='40%completed';
    waitbar(0.4,f,completed);
end
[J2,~]=deconvblind(img2,data_psf_new,num_iter);
if getappdata(f,'canceling')
    breakflag=~breakflag;
    img=[];
    return
else
    completed='60%completed';
    waitbar(0.6,f,completed);
end
[J3,~]=deconvblind(img3,data_psf_new,num_iter);
if getappdata(f,'canceling')
    breakflag=~breakflag;
    img=[];
    return
else
    completed='80%completed';
    waitbar(0.8,f,completed);
end
[J4,~]=deconvblind(img4,data_psf_new,num_iter);
if getappdata(f,'canceling')
    breakflag=~breakflag;
    img=[];
    return
else
    completed='99%completed';
    waitbar(0.99,f,completed);
end
Image3D_deconv(1:a/2,1:b/2,:)=J1(1:a/2,1:b/2,:);
Image3D_deconv(1:a/2,b/2+1:b,:)=J2(1:a/2,2*e+1:b/2+2*e,:);
Image3D_deconv(a/2+1:a,1:b/2,:)=J3(2*d+1:a/2+2*d,1:b/2,:);
Image3D_deconv(a/2+1:a,b/2+1:b,:)=J4(2*d+1:a/2+2*d,2*e+1:b/2+2*e,:);
img=Image3D_deconv;
delete(f)
end