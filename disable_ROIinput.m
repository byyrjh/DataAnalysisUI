function disable_ROIinput(ObjH,EventData,obj)
xmin_in=findobj('Tag','xmin_in');
xmax_in=findobj('Tag','xmax_in');
ymin_in=findobj('Tag','ymin_in');
ymax_in=findobj('Tag','ymax_in');
zmin_in=findobj('Tag','zmin_in');
zmax_in=findobj('Tag','zmax_in');
if get(ObjH,'Value')
    xmin_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.xmin;
    xmax_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.xmax;
    ymin_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.ymin;
    ymax_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.ymax;
    zmin_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.zmin;
    zmax_in.String=obj.guihandles.menu_analyze_ROIselect_flag.old.zmax;
    set(xmin_in,'Enable','off');
    set(xmax_in,'Enable','off');
    set(ymin_in,'Enable','off');
    set(ymax_in,'Enable','off');
    set(zmin_in,'Enable','off');
    set(zmax_in,'Enable','off');
else
    set(xmin_in,'Enable','on');
    set(xmax_in,'Enable','on');
    set(ymin_in,'Enable','on');
    set(ymax_in,'Enable','on');
    set(zmin_in,'Enable','on');
    set(zmax_in,'Enable','on');
    xmin_in.String=obj.guihandles.menu_analyze_ROIselect_flag.new.xmin;
    xmax_in.String=obj.guihandles.menu_analyze_ROIselect_flag.new.xmax;
    ymin_in.String=obj.guihandles.menu_analyze_ROIselect_flag.new.ymin;
    ymax_in.String=obj.guihandles.menu_analyze_ROIselect_flag.new.ymax;
end
end