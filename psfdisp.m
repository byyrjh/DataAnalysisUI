function psfdisp(hobj,event,obj)
set(obj.guihandles.handlearr.img,'Enable','off');
set(obj.guihandles.handlearr.psf,'Enable','on');
set(obj.guihandles.menu_analyze,'Enable','off');
set(obj.guihandles.menu_psfcurve,'Enable','on');
handleList=allchild(obj.Panel_1.panel);
delete(handleList);
handleList=allchild(obj.Panel_2.panel);
delete(handleList);
handleList=allchild(obj.Panel_3.panel);
delete(handleList);
handleList=allchild(obj.Panel_4.panel);
delete(handleList);
obj.Panel_1.xyshow=axes('Parent',obj.Panel_1.panel);
set(obj.Panel_1.xyshow,'Visible','off');
obj.Panel_1.xyslider=uicontrol('Parent',obj.Panel_1.panel,...
    'Units','normalized','Position',[0.1,0.01,0.8,0.05],...
    'Style','slider',...
    'UserData',struct('row',0,'col',0,'slice',0,'threeDdata',[]));
slider_range=length(obj.guihandles.PSFdata.data);
set(obj.Panel_1.xyslider,'Min',1,'Max',slider_range,'Value',slider_range,'SliderStep',[1/(slider_range-1),1/(slider_range-1)*10]);
obj.Panel_1.xyslider.UserData.slice=slider_range;
obj.Panel_1.curslice=uicontrol(obj.Panel_1.panel,'Style','edit','Units',...
    'normalized','String','1','FontSize',12,'Position',[0.01,0.015,0.08,0.05],...
    'Callback',@(ObjH,EventData) gotoslice(ObjH,EventData,obj));
obj.Panel_1.totslice=uicontrol(obj.Panel_1.panel,'Style','Text','Units',...
    'normalized','String',num2str(slider_range),'FontSize',12,'Position',[0.91,0.015,0.08,0.05]);
obj.Panel_1.xyslider.addlistener('Value','PostSet',@(ObjH,EventData) xyslider_PSFviewer(ObjH,EventData,obj));

image2disp=obj.guihandles.PSFdata.data{1,1};
image2disp=image2disp.xyMIP;
axes(obj.Panel_1.xyshow);
imagesc(image2disp);
colormap('hot');
axis equal
axis([0 size(image2disp,2) 0 size(image2disp,1)])
set(obj.Panel_1.xyslider,'Enable','on');
set(obj.Panel_1.xyslider,'Value',1)
end