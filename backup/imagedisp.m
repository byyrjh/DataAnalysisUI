function imagedisp(hObj,event,obj)
disp_dialobox=findobj('Tag','dispopt');
coorsele=findobj('Tag','coorsele');
coorsele=string(coorsele.SelectedObject.String);
data_disp=findobj('Tag','imgsele');
data_disp_idx=data_disp.Value;
dataname=data_disp.String(data_disp_idx);
datanamepool=data_disp.UserData;
idx=find(strcmp(string(datanamepool),string(dataname)));
panel_sele=findobj('Tag','panelsele');
panel_sele=panel_sele.Value;
close(disp_dialobox)
switch coorsele
    case "Lab"
        imagetodisp=obj.guihandles.Data{1,idx};
    case "Bio"
        if isempty(obj.guihandles.batchpipeline.method)
            obj.guihandles.batchpipeline.method{1,1}='Bio';
            obj.guihandles.batchpipeline.para{1,1}=[];
        else
            indx=length(obj.guihandles.batchpipeline.method);
            obj.guihandles.batchpipeline.method{1,indx+1}='Bio';
            obj.guihandles.batchpipeline.para{1,indx+1}=[];
        end
        imginfo=struct('magnification',[],'pixelsize',[],'stepsize',[]);
        imginfo.magnification=obj.guihandles.menu_file_f1.UserData.magnification;
        imginfo.stepsize=obj.guihandles.menu_file_f1.UserData.stepsize;
        imginfo.pixelsize=obj.guihandles.menu_file_f1.UserData.pixelsize;
        
        if rem((imginfo.stepsize),((imginfo.pixelsize)/(imginfo.magnification)))>0.1
            msgbox('rendering image in bio coordinate could lead to deadly artifact!')
            return
        else
            imagetodisp=coordinatetrans(obj.guihandles.Data{1,idx},imginfo);
            obj.guihandles.Data{2,idx}=imagetodisp;
        end
end
switch panel_sele
    case 1
        [x y z]=size(imagetodisp);
        obj.Panel_1.xyslider.UserData.threeDdata=imagetodisp;
        set(obj.Panel_1.xyslider,'Min',1,'Max',z,'Value',1,'SliderStep',[1/z,1/z*10]);
        obj.Panel_1.totslice.String=string(z);
        %                     volumeViewer
    case 2
        p2=obj.Panel_2;
        obj.Panel_2=imgdisplay(obj.Panel_2.panel,obj,p2,imagetodisp);
    case 3
        p3=obj.Panel_3;
        obj.Panel_3=imgdisplay(obj.Panel_3.panel,obj,p3,imagetodisp);
    case 4
        p4=obj.Panel_4;
        obj.Panel_4=imgdisplay(obj.Panel_4.panel,obj,p4,imagetodisp);
end

end