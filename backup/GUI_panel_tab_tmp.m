%GUI using handle class
%--Rui
%==========================================================================
classdef GUI_panel_tab_tmp < handle
    %% 
    properties
        guihandles
    end
    %% 
    methods
        function obj = GUI_panel_tab_tmp(h, fontsize, obj1) 
            %%
            obj.guihandles.tab_group_1 = uitabgroup(...
                'Parent', h, ...
                'Position', [0.01, 0.01, 0.98, 0.98]);
            obj.guihandles.tab_1 = uitab(obj.guihandles.tab_group_1, ...
                'Title', 'Tab 1');
            obj.guihandles.tab_2 = uitab(obj.guihandles.tab_group_1, ...
                'Title', 'Tab 2');
        end
        %% 
        %==================================================================
        %callback
    end
end