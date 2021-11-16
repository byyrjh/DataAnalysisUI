classdef test_guidata < handle
    properties
        guihandles
    end
    methods 
        function mainfigure=test_guidata(varargin)
            
figureheight = 800;
figurewidth = 800;

mainfigure.guihandles.h = figure('Name', 'GUI',...
    'MenuBar', 'none', ...
    'ToolBar', 'none');
initPosition = mainfigure.guihandles.h.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
mainfigure.guihandles.h.Position = [initPosition(1), ...
    initPosition(2) - figureheight + initPosition(4), figurewidth, figureheight];
mainfigure.guihandles.clickbutton=uicontrol('Parent',mainfigure.guihandles.h,'Style','pushbutton','String','create','Units','normalized','Position',[0.5,0.5,0.2,0.1],'FontSize',12,...
    'Callback',@(hObj,event) test_button(hObj,event,mainfigure));
        end
    end
end