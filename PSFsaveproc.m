function PSFsaveproc(hObj,event,obj)
pararead=findobj('Tag','psfsave');
savepath=findobj('Tag','savePath');
savepath=savepath.String;
Alldata=findobj('Tag','Alldata');
Volumedata=findobj('Tag','Volumedata');
f=waitbar(0,'1','Name','PSF Data Saving',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
if logical(Alldata.Value)
    data=obj.guihandles.PSFdata;
    save(strcat(savepath,'.mat'),'data');
end
if logical(Volumedata.Value)
    [aver_psf aver_psf_N]=psf_aver(obj.guihandles.PSFdata.data);
    [~,~,slice]=size(aver_psf);
    for i=1:slice
        imwrite(aver_psf(:,:,i),strcat(savepath,'.tiff'),'WriteMode','append');
        completed=strcat(num2str(round(i/slice,2)*100),'%completed');
        waitbar(i/slice,f,completed);
    end
end
delete(f);
close(pararead);
end