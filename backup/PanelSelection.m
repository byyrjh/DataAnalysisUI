function panelClass=PanelSelection(obj,hPanel)
curpanel=[hPanel hPanel hPanel hPanel];
PanelList=[obj.Panel_1.panel obj.Panel_2.panel obj.Panel_3.panel obj.Panel_4.panel];
flag_panelsele=eq(PanelList,curpanel);
panel_idx=find(flag_panelsele==true);
switch panel_idx
    case 1
        panelClass=obj.Panel_1;
    case 2
        panelClass=obj.Panel_2;
    case 3
        panelClass=obj.Panel_3;
    case 4
        panelClass=obj.Panel_4;
end 
end