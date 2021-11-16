function xyslider_continousshow(ObjH,EventData,obj)
hSlider=EventData.AffectedObject;
hPanel=get(hSlider,'parent');
panelname=PanelSelection(obj,hPanel);
index=round(get(panelname.xyslider,'Value'));
panelname.curslice.String=string(index);
axes(panelname.xyshow);
imshow((panelname.xyslider.UserData.threeDdata(:,:,index)),[]);
end