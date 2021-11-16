function Fcn_affineTrans(hObj,event,obj)
axisarr=cell(3,1);
angle=zeros(3,1);
axisarr1=findobj('Tag','axisele_in1').Value;
axisarr2=findobj('Tag','axisele_in2').Value;
axisarr3=findobj('Tag','axisele_in3').Value;
axisarr11=findobj('Tag','axisele_in1').String;
axisarr22=findobj('Tag','axisele_in2').String;
axisarr33=findobj('Tag','axisele_in3').String;
axisarr{1,1}=axisarr11(axisarr1);
axisarr{2,1}=axisarr22(axisarr2);
axisarr{3,1}=axisarr33(axisarr3);
axisarr=string(axisarr);
angle(1)=str2num(findobj('Tag','axis_in1').String);
angle(2)=str2num(findobj('Tag','axis_in2').String);
angle(3)=str2num(findobj('Tag','axis_in3').String);
angle=angle/180*pi;
imdata=obj.guihandles.Data{1,1};
magnification=obj.guihandles.menu_file_f1.UserData.magnification;
stepsize=obj.guihandles.menu_file_f1.UserData.stepsize;
pixelsize=obj.guihandles.menu_file_f1.UserData.pixelsize;
binsize=obj.guihandles.menu_file_f1.UserData.binsize;
real_pixelsize=pixelsize/magnification*binsize;
aspect_a2t=floor(stepsize/real_pixelsize);
if aspect_a2t>1
    coef_interp=aspect_a2t;
    [x y z]=size(imdata);
    cor_ori=linspace(1,(z-1)*coef_interp+1,z);
    cor_inter=linspace(1,(z-1)*coef_interp+1,(z-1)*coef_interp+1);
    data_new=zeros(x,y,(z-1)*coef_interp+1);
    parfor i=1:x
        for j=1:y
            temp=double(reshape(imdata(i,j,:),[z,1]));
            temp=interp1(cor_ori,temp,cor_inter,'spline');
            data_new(i,j,:)=reshape(temp,[1,1,(z-1)*coef_interp+1]);
        end
    end
else 
    data_new=imdata;
end
data_new=double(data_new);
for i=1:3
    switch axisarr(i)
        case 'x'
            t = [1     0     0    0;
                0   cos(angle(i)) -sin(angle(i))  0;
                0   sin(angle(i))  cos(angle(i))  0;
                0     0     0       1];
        case 'y'
            t = [cos(angle(i)) 0 -sin(angle(i)) 0;
                0      1     0       0;
                sin(angle(i)) 0  cos(angle(i)) 0;
                0      0     0       1];
        case 'z'
            t = [cos(angle(i)) -sin(angle(i)) 0   0;
                sin(angle(i))  cos(angle(i))  0   0;
                       0          0           1   0;
                       0          0           0   1];
    end
    tform=affine3d(t);
    data_new=imwarp(data_new,tform);
end
imagetodisp=uint16(data_new);
pararead=findobj('Tag','imrot_setting');
close(pararead);
p4=obj.Panel_4;
obj.Panel_4=imgdisplay(obj.Panel_4.panel,obj,p4,imagetodisp);
for i=1:305
    imwrite(imagetodisp(:,:,i),'W:\Lucas\2021_1_29\fov1\proc_561\raw_TNT_rot.Tiff','WriteMode','append');
end
end