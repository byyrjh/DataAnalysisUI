function gotoslice(ObjH,EventData,obj)
hPanel=get(ObjH,'parent');
panelname=PanelSelection(obj,hPanel);
idx=str2double(panelname.curslice.String);
slice=panelname.xyslider.UserData.slice;
if (rem(idx,1)==0)&(idx>0)&(idx<(slice+1))
    panelname.xyslider.Value=idx;
else
    msgbox('Please designate a valid index');
end
end