function outputstruct=test_slideradd(test,mainfigure)


test.slider=uicontrol(mainfigure.guihandles.h,'Enable','off',...
    'Units','normalized','Position',[0.1,0.01,0.8,0.05],'Style','slider');

test.curslice=uicontrol(mainfigure.guihandles.h,'Style','edit','Units',...
    'normalized','FontSize',12,'Position',[0.01,0.015,0.08,0.05],...
    'Callback',@(ObjH,EventData) gotoslice(ObjH,EventData,mainfigure));
outputstruct=test;
end