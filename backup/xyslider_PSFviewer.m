function xyslider_PSFviewer(ObjH,EventData,obj)
hSlider=EventData.AffectedObject;
hPanel=get(hSlider,'parent');
panelname=PanelSelection(obj,hPanel);
index=round(get(panelname.xyslider,'Value'));
panelname.curslice.String=string(index);
axes(panelname.xyshow);
PSFdata=obj.guihandles.PSFdata.data{index,1};
image2disp=PSFdata.xyMIP;
imagesc(image2disp);
colormap('hot');
axis equal
axis([0 size(image2disp,2) 0 size(image2disp,1)])
hold on
psf_pos=PSFdata.PosSet;
scatter(psf_pos(:,2),psf_pos(:,1),'MarkerEdgeColor',[0 1 0]);
%% create position annotation and table
data_temp=cell(size(psf_pos,1),6);
[x y z]=size(PSFdata.VolumeSet{1,1});
center_pos_xy=round(x/2);
center_pos_z=round(z/2);
for i=1:size(psf_pos,1)
    text(psf_pos(i,2)-30,psf_pos(i,1)-30,num2str(i),'Color','white','FontSize',10);
    data_temp{i,1}=PSFdata.FWHMset(i,1);
    data_temp{i,2}=PSFdata.FWHMset(i,2);
    data_temp{i,3}=PSFdata.FWHMset(i,3);
    temp=PSFdata.VolumeSet{i,1};
    data_temp{i,4}=temp(center_pos_xy,center_pos_xy,center_pos_z);
    data_temp{i,5}=PSFdata.PosSet(i,3);
    data_temp{i,6}=any(PSFdata.Manually_sele_idx==i);
end
obj.Panel_3.FWHMdisp=uitable(obj.Panel_3.panel,'ColumnName',{'FHWM_x','FHWM_y','FHWM_z','I_core',...
    strcat('pos_z_',num2str(obj.guihandles.PSFdata.slices),'/',num2str(center_pos_z)),'rule out'},...
    'Units','normalized','Position',[0 0.3 1 0.6],'FontSize',10);
obj.Panel_3.FWHMdisp.Data=data_temp;
obj.Panel_3.FWHMdisp.ColumnEditable=true;
obj.Panel_3.FWHMdisp.ColumnWidth={55,55,55,60,75,48};
obj.Panel_3.manulsel=uicontrol(obj.Panel_3.panel,'style','pushbutton','Units','normalized','Position',...
    [0.35 0.1 0.3 0.1],'FontSize',10,'String','confirm elimination','Callback',@(hObj,event) PSFruleout(hObj,event,obj,index));
end