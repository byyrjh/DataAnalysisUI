function imagetodisp=coordinatetrans(data,imginfo)
f=waitbar(0,'1','Name','coordinate transformation',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
completed='interpolation is runing';
waitbar(0.1,f,completed);
magnification=imginfo.magnification;
pixelsize=imginfo.pixelsize;
stepsize=imginfo.stepsize;
real_pixelsize=pixelsize/magnification;
aspect_a2t=floor(stepsize/real_pixelsize);
if aspect_a2t>1
    coef_interp=aspect_a2t;
    [x y z]=size(data);
    cor_ori=linspace(1,(z-1)*coef_interp+1,z);
    cor_inter=linspace(1,(z-1)*coef_interp+1,(z-1)*coef_interp+1);
    data_new=zeros(x,y,(z-1)*coef_interp+1);
    parfor i=1:x
        for j=1:y
            temp=double(reshape(data(i,j,:),[z,1]));
            temp=interp1(cor_ori,temp,cor_inter,'spline');
            data_new(i,j,:)=reshape(temp,[1,1,(z-1)*coef_interp+1]);
        end
    end
else 
    data_new=data;
end
completed='image rotation is runing';
waitbar(0.5,f,completed);
data_new=double(data_new);
theta = -33/180*pi;
t = [cos(theta) 0 -sin(theta) 0;
    0      1     0       0;
    sin(theta) 0  cos(theta) 0;
    0      0     0       1];
tform=affine3d(t);
mriVolumeRotated=imwarp(data_new,tform);
imagetodisp=uint16(mriVolumeRotated);
delete(f)
end