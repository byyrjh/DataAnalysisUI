function imagesaveproc(hObj,event,obj)
save_dialobox=findobj('Tag','imagesave');
zmin=findobj('Tag','slice_init_in');
zmax=findobj('Tag','slice_end_in');
zmin=str2double(zmin.String);
zmax=str2double(zmax.String);
indx=length(obj.guihandles.batchpipeline.method);
obj.guihandles.batchpipeline.method{1,indx+1}='SLICE';
obj.guihandles.batchpipeline.para{1,indx+1}=[zmin zmax];
coorsele=findobj('Tag','coorsele');
coorsele=string(coorsele.SelectedObject.String);
data_save=findobj('Tag','imgsele');
data_disp_idx=data_save.Value;
dataname=data_save.String(data_disp_idx);
datanamepool=data_save.UserData;
idx=find(strcmp(string(datanamepool),string(dataname)));
switch coorsele
    case "Lab"
        imagetosave=obj.guihandles.Data{1,idx};
    case "Bio"
        imagetosave=obj.guihandles.Data{2,idx};
end
imgpath=findobj('Tag','savePath');
imgpath=imgpath.String;
fullname=strcat(imgpath,obj.guihandles.menu_file_f3.UserData.imagename,'_',string(dataname),'_',coorsele,'.Tiff');
imagetosave=imagetosave(:,:,zmin:zmax);
[x y z]=size(imagetosave);
close(save_dialobox)
f=waitbar(0,'1','Name','Imagedata Saving',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
for i=1:z
    imwrite(imagetosave(:,:,i),fullname,'WriteMode','append');
    completed=strcat(num2str(round(i/z,2)*100),'%completed');
    waitbar(i/z,f,completed);
end
delete(f);
end