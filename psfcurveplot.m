function psfcurveplot (hObj,event,obj)
FWHMset=[];
for i=1:length(obj.guihandles.PSFdata.data)
    temp=obj.guihandles.PSFdata.data{i,1}.FWHMset;
    temp(obj.guihandles.PSFdata.data{i,1}.Manually_sele_idx,:)=[];
    FWHMset=[FWHMset;temp];
end
[aver_psf aver_psf_N]=psf_aver(obj.guihandles.PSFdata.data);
[dimx dimy dimz]=size(aver_psf);
pixelsize=obj.guihandles.PSFdata.pixelsize;
stepsize=obj.guihandles.PSFdata.stepsize;
magnification=obj.guihandles.PSFdata.magnification;
Iprof_x=double(aver_psf((dimx-1)/2+1,:,(dimz-1)/2+1));
Iprof_x=Iprof_x/max(Iprof_x);
Iprof_y=double(aver_psf(:,(dimy-1)/2+1,(dimz-1)/2+1));
Iprof_y=Iprof_y/max(Iprof_y);
Iprof_z=double(aver_psf((dimx-1)/2+1,(dimy-1)/2+1,:));
Iprof_z_N=double(aver_psf_N((dimx-1)/2+1,(dimy-1)/2+1,:));
Iprof_z=Iprof_z/max(Iprof_z);
Iprof_z_N=Iprof_z_N/max(Iprof_z_N);
intp_xy=(dimx-1)*8;
intp_z=(dimz-1)*8;
coor_x=linspace(-pixelsize/magnification*(dimx-1)/2,pixelsize/magnification*(dimx-1)/2,dimx);
coor_y=linspace(-pixelsize/magnification*(dimy-1)/2,pixelsize/magnification*(dimy-1)/2,dimy);
coor_z=linspace(-stepsize*(dimz-1)/2,stepsize*(dimz-1)/2,dimz);
FWHM_x=round(FWHM(Iprof_x,pixelsize/magnification*dimx,intp_xy),2);
FWHM_y=round(FWHM(Iprof_y,pixelsize/magnification*dimx,intp_xy),2);
FWHM_z=round(FWHM(reshape(Iprof_z_N,[dimz,1]),stepsize*dimz,intp_z),2);
FWHM_x_devi=round(sqrt(sum((FWHMset(:,1)-FWHM_x).^2)/size(FWHMset,1)),2);
FWHM_y_devi=round(sqrt(sum((FWHMset(:,2)-FWHM_y).^2)/size(FWHMset,1)),2);
FWHM_z_devi=round(sqrt(sum((FWHMset(:,3)-FWHM_z).^2)/size(FWHMset,1)),2);
handleList=allchild(obj.Panel_2.panel);
delete(handleList);
obj.Panel_2.profileplot=axes('Parent',obj.Panel_2.panel);
axes(obj.Panel_2.profileplot);
hold on;
xlim([-2 2]);
plot(coor_x,Iprof_x);
plot(coor_y,Iprof_y);
plot(coor_z,reshape(Iprof_z_N,[dimz,1]));
% plot(coor_z,reshape(Iprof_z_N,[dimz,1])); strcat('FWHM_z_N',num2str(FWHM_z_N),'µm'),
lh=legend(strcat('FWHM_x',num2str(FWHM_x),'+-',num2str(FWHM_x_devi),'µm'),strcat('FWHM_y',num2str(FWHM_y),'+-',num2str(FWHM_y_devi),'µm'),...
    strcat('FWHM_z',num2str(FWHM_z),'+-',num2str(FWHM_z_devi),'µm'),'NumColumns',1);
set(lh,'Position',[0.65, 0.73, .25, .25])
end