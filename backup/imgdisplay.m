function panelhandle=imgdisplay(panel,obj,panelhandle,imagetodisp)
% handleList=allchild(panelhandle.panel);
% delete(handleList);
Abraham=panelhandle.panel;
[x y z]=size(imagetodisp);
handleList=allchild(Abraham);
delete(handleList);
panelhandle.xyshow=axes('Parent',Abraham);
set(panelhandle.xyshow,'Visible','off');
imshow(imagetodisp(:,:,1),[]);
panelhandle.xyslider=uicontrol('Parent',Abraham,'Enable','off',...
    'Units','normalized','Position',[0.1,0.01,0.8,0.05],...
    'Style','slider','UserData',struct('row',x,'col',y,'slice',z,'threeDdata',imagetodisp));
panelhandle.curslice=uicontrol(Abraham,'Style','edit','Units',...
    'normalized','FontSize',12,'String','1','Position',[0.01,0.015,0.08,0.05],...
    'Callback',@(ObjH,EventData) gotoslice(ObjH,EventData,obj));
set(panelhandle.xyslider,'Min',1,'Max',z,'Value',1,'SliderStep',[1/z,1/z*10]);
set(panelhandle.xyslider,'Enable','on');
panelhandle.xyslider.addlistener('Value','PostSet',@(ObjH,EventData) xyslider_continousshow(ObjH,EventData,obj));
panelhandle.totslice=uicontrol(Abraham,'Style','Text','Units',...
    'normalized','String',num2str(z),'FontSize',12,'Position',[0.91,0.015,0.08,0.05]);
end