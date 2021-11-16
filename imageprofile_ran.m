%GUI using handle class
%--Rui
%==========================================================================
classdef imageprofile_ran < handle
    %%
    properties
        guihandles
        Panel_1
        Panel_2
        Panel_3
        Panel_4
    end
    %%
    methods
        function obj = imageprofile(varargin)
            %%
            %==============================================================
            %consturctor: make GUI
            %dependency
            addpath(genpath(pwd));
            figureheight = 800;
            figurewidth = 800;
            
            h = figure('Name', 'GUI',...
                'MenuBar', 'none', ...
                'ToolBar', 'none');
            initPosition = h.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
            h.Position = [initPosition(1), ...
                initPosition(2) - figureheight + initPosition(4), figurewidth, figureheight];
            
            if ispc
                fontsize = 14;
            else
                fontsize = 16;
            end
            
            obj.guihandles.handle = h;
            %%
            %==============================================================
            %position for all the panels
            pos_panel_1 = [0.01 0.5 0.48 0.48];
            pos_panel_2 = [0.01 0.01 0.48 0.48];
            pos_panel_3 = [0.51 0.5 0.48 0.48];
            pos_panel_4=[0.51,0.01,0.48,0.48];
            
            obj.Panel_1.panel = uipanel(...
                'Parent', h, ...
                'Title', 'Panel 1', ...
                'Position', pos_panel_1, ...
                'BackgroundColor', 'white', ...
                'FontSize', fontsize, ...
                'FontWeight', 'bold');
            
            obj.Panel_2.panel = uipanel(...
                'Parent', h, ...
                'Title', 'Panel 2', ...
                'Position', pos_panel_2, ...
                'BackgroundColor', 'white', ...
                'FontSize', fontsize, ...
                'FontWeight', 'bold');
            
            obj.Panel_3.panel = uipanel(...
                'Parent', h, ...
                'Title', 'Panel 3', ...
                'Position', pos_panel_3, ...
                'BackgroundColor', 'white', ...
                'FontSize', fontsize, ...
                'FontWeight', 'bold');
            
            obj.Panel_4.panel=uipanel(...
                'parent',h,...
                'title','Panel 4',...
                'position',pos_panel_4,...
                'BackgroundColor','white',...
                'FontSize',fontsize,...
                'FontWeight','bold');
            %%
            obj.guihandles.Data=cell(2,5);
            obj.guihandles.twoChannelcor=[-3,-20];  %[xshift,yshift] with respect to det2
            %%
            % method includes 'WBC' 'DECONV' followed by cordinate
            % selection('Bio' or 'Lab') and image saving('SLICE')
            % corresponding parameter should be [number of cascade] [image
            % step size, psf step size, number of iterations] [] [ini slice ind, end slice ind]
            % batchpipeline updates during the whole image analysis workflow
            % until image saving
            obj.guihandles.batchpipeline=struct('method',cell(1,1),'para',cell(1,1));
            %% data type
            obj.guihandles.ifImg=true;
            %PSFdata.data{1,1}=struct('raw psf set',volume,'manually selected index'(label the beads to kick out),vector,'xyMIP',image,'Position set',three col array,'FWHM set',three col array)
            obj.guihandles.PSFdata=struct('path',[],'data',[],'name',[],'pixelsize',[],'stepsize',[],'magnification',[],'slices',[]);
            %%
            %==============================================================
            %panel1
            
            %==============================================================
            %panel2
            
            %==============================================================
            %panel3
            
            %% data memory allocation
            %%%%%%%%%%%%%%%%%%%%%% ROI raw data %%%%%%%%%%%%%%%%%%%
            % (1,1)  obj.guihandles.Data{1,1}=[];
            %%%%%%%%%%%%%%%%%%%%%% Deconv of ROI raw data %%%%%%%%%%%%%%%%%
            % (1,2)obj.guihandles.Data_ROI_decov=[];
            %%%%%%%%%%%%%%%%%%%%%% wltBkgClear of ROI raw data %%%%%%%%%%%%
            % (1,3)obj.guihandles.Data_ROI_wltBkgClear=[];
            %%%%%%%%%%%%%% ROI raw data + deconv + wltBkgClear %%%%%%%%%%%%
            % (1,4)obj.guihandles.Data_ROI_deconv_wltBkgClear=[];
            %%%%%%%%%%%%%% ROI raw data + wltBkgClear + deconv %%%%%%%%%%%%
            % (1,5)obj.guihandles.Data_ROI_wltBkgClear_deconv=[];
            %------------- in bio coordinate --------------
            % (2,1)obj.guihandles.Data_ROI_raw_bio=[];
            % (2,2)obj.guihandles.Data_ROI_decov_bio=[];
            % (2,3)obj.guihandles.Data_ROI_wltBkgClear_bio=[];
            % (2,4)obj.guihandles.Data_ROI_deconv_wltBkgClear_bio=[];
            % (2,5)obj.guihandles.Data_ROI_wltBkgClear_deconv_bio=[];
            %% menu
            obj.guihandles.menu_file = uimenu(obj.guihandles.handle, 'Text','file');
            obj.guihandles.menu_analyze = uimenu(obj.guihandles.handle, 'Text','analyze');
            obj.guihandles.menu_visualization=uimenu(obj.guihandles.handle,'Text','visualization');
            %%%%%%%%%%%%%%%%%%%%%% Image raw data %%%%%%%%%%%%%%%%%%%%%%%%%
            % the number of files determine the file type (one file:image data,multi-file:PSF data)
            obj.guihandles.menu_file_f1=uimenu(obj.guihandles.menu_file,'Text','Image Load','Accelerator','L',...
                'UserData',struct('row',0,'col',0,'slice',0,'magnification',[],'pixelsize',[],'stepsize',[],'threeDdata',[]));
            %%%%%%%%%%%%%%%%%%%%%% PSF raw data %%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.guihandles.menu_file_f2=uimenu(obj.guihandles.menu_file,'Text','PSF Load','Accelerator','P');
            %%
            obj.guihandles.menu_file_f3=uimenu(obj.guihandles.menu_file,'Text','Image Save','Accelerator','S','MenuSelectedFcn',{@obj.image_save,obj});
            obj.guihandles.menu_file_f4=uimenu(obj.guihandles.menu_file,'Text','PSF Save','Accelerator','F','MenuSelectedFcn',{@obj.PSF_save,obj});
            obj.guihandles.menu_analyze_axplanedisp=uimenu(obj.guihandles.menu_analyze,'Text','Display Axialplane','Accelerator','A');
            obj.guihandles.menu_analyze_ROIselect=uimenu(obj.guihandles.menu_analyze,'Text','ROI selection','Accelerator','R');
            obj.guihandles.menu_analyze_Deconv=uimenu(obj.guihandles.menu_analyze,'Text','Deconvolution','Accelerator','D');
            obj.guihandles.menu_analyze_WBC=uimenu(obj.guihandles.menu_analyze,'Text','WBC','Accelerator','W');
            obj.guihandles.menu_analyze_PSFextract=uimenu(obj.guihandles.menu_analyze,'Text','PSF extraction','Accelerator','P');
            obj.guihandles.menu_analyze_Batch=uimenu(obj.guihandles.menu_analyze,'Text','Batch','Accelerator','B','MenuSelectedFcn',{@obj.batchproce,obj});
            obj.guihandles.menu_imdisplay=uimenu(obj.guihandles.menu_visualization,'Text','Image display');
            obj.guihandles.menu_psfdisplay=uimenu(obj.guihandles.menu_visualization,'Text','PSF display');
            obj.guihandles.menu_psfcurve=uimenu(obj.guihandles.menu_visualization,'Text','PSF curve','Enable','off','MenuSelectedFcn',(@(hObj,event) psfcurveplot(hObj,event,obj)));
            obj.guihandles.menu_analyze_ROIselect_flag.new=struct('xmin',[],'ymin',[],'xmax',[],'ymax',[],'zmax',[],'zmin',[]);
            obj.guihandles.menu_analyze_ROIselect_flag.old=struct('xmin',[],'ymin',[],'xmax',[],'ymax',[],'zmax',[],'zmin',[]);
            obj.guihandles.menu_file_f1.MenuSelectedFcn= {@obj.tifstackread,obj};
            obj.guihandles.menu_file_f2.MenuSelectedFcn= {@obj.PSFread,obj};
            obj.guihandles.menu_analyze_axplanedisp.MenuSelectedFcn= {@obj.axplane_display,obj};
            obj.guihandles.menu_analyze_ROIselect.MenuSelectedFcn={@obj.ROIselect,obj};
            obj.guihandles.menu_analyze_Deconv.MenuSelectedFcn={@obj.Deconv_setting,obj};
            obj.guihandles.menu_analyze_WBC.MenuSelectedFcn={@obj.WBC_setting,obj};
            obj.guihandles.menu_imdisplay.MenuSelectedFcn=(@(hObj,event) imagedisp_setting(hObj,event,obj));
            obj.guihandles.menu_psfdisplay.MenuSelectedFcn=(@(hobj,event) psfdisp(hobj,event,obj));
            obj.guihandles.menu_analyze_PSFextract.MenuSelectedFcn={@obj.PSFextr_setting,obj};
            %%
            obj.guihandles.handlearr.psf=[obj.guihandles.menu_file_f4,obj.guihandles.menu_analyze_PSFextract,obj.guihandles.menu_psfdisplay];
            obj.guihandles.handlearr.img=[obj.guihandles.menu_file_f3,obj.guihandles.menu_analyze_axplanedisp,obj.guihandles.menu_analyze_Deconv,obj.guihandles.menu_analyze_WBC,obj.guihandles.menu_imdisplay];
        end
        %%
        %==================================================================
        
        function tifstackread(hObject,src,event, obj)
            handleList=allchild(obj.Panel_1.panel);
            delete(handleList);
            handleList=allchild(obj.Panel_2.panel);
            delete(handleList);
            handleList=allchild(obj.Panel_3.panel);
            delete(handleList);
            handleList=allchild(obj.Panel_4.panel);
            delete(handleList);
            obj.guihandles.Data=cell(2,5);
            obj.guihandles.batchpipeline=struct('method',cell(1,1),'para',cell(1,1));
            obj.Panel_1.xyshow=axes('Parent',obj.Panel_1.panel);
            set(obj.Panel_1.xyshow,'Visible','off');
            obj.Panel_1.xyslider=uicontrol('Parent',obj.Panel_1.panel,...
                'Units','normalized','Position',[0.1,0.01,0.8,0.05],...
                'Style','slider',...
                'UserData',struct('row',0,'col',0,'slice',0,'threeDdata',[],'xyMIP',[]));
            obj.Panel_1.curslice=uicontrol(obj.Panel_1.panel,'Style','edit','Units',...
                'normalized','String','0','FontSize',12,'Position',[0.01,0.015,0.08,0.05],...
                'Callback',@(ObjH,EventData) gotoslice(ObjH,EventData,obj));
            obj.Panel_1.totslice=uicontrol(obj.Panel_1.panel,'Style','Text','Units',...
                'normalized','String','0','FontSize',12,'Position',[0.91,0.015,0.08,0.05]);
            obj.Panel_1.xyslider.addlistener('Value','PostSet',@(ObjH,EventData) xyslider_continousshow(ObjH,EventData,obj));
            set(obj.Panel_1.xyslider,'Enable','off');
            [imgfile, imgpath] = uigetfile_rui( {'*.tiff';'*.tif'}, 'please select image');
            obj.guihandles.ifImg=(length(imgfile)==1);
            if ~obj.guihandles.ifImg    % these callback function can either read image raw be processed or PSF raw data
                obj.guihandles.PSFdata.path=imgfile;
                obj.guihandles.PSFdata.data=cell(size(imgfile)); % every cell element should be a structure
                temp=cell(1);
                temp{1,1}=imgfile{1,1};
            else
                temp=imgfile;
            end
            [img breakflag]= tiff_reader_rui(temp);
            if ~breakflag
                [x y z]=size(img);
                data=struct('row',x,'col',y,'slice',z,'threeDdata',img,'xyMIP',[]);
                slash_pos=strfind(imgfile{1,1},'\');
                dot_pos=strfind(imgfile{1,1},'.');
                temp_n=length(slash_pos);
                imagename=imgfile{1,1};
                imagename=imagename((slash_pos(temp_n)+1):(dot_pos-1));
                if obj.guihandles.ifImg
                    set(obj.guihandles.menu_analyze,'Enable','on');
                    set(obj.guihandles.handlearr.img,'Enable','on');
                    set(obj.guihandles.handlearr.psf,'Enable','off');
                    obj.guihandles.menu_file_f1.UserData.row=x;   % original data
                    obj.guihandles.menu_file_f1.UserData.col=y;
                    obj.guihandles.menu_file_f1.UserData.slice=z;
                    obj.guihandles.menu_file_f1.UserData.threeDdata=img;
                    obj.guihandles.menu_file_f3.UserData.imagename=imagename;
                    obj.guihandles.menu_file_f3.UserData.imagepath=imgpath;
                else
                    set(obj.guihandles.menu_analyze,'Enable','on');
                    set(obj.guihandles.handlearr.img,'Enable','off');
                    set(obj.guihandles.handlearr.psf,'Enable','on');
                    obj.guihandles.PSFdata.name=imagename;
                end
                set(obj.Panel_1.xyslider,'Enable','on','Min',1,'Max',z,'Value',1,'SliderStep',[1/z,1/z*10]);
                set(obj.Panel_1.xyslider,'UserData',data);   % data to be analyzed
                obj.Panel_1.totslice.String=string(z);
                axes(obj.Panel_1.xyshow);
                imshow(img(:,:,1),[]);
            end
            pararead=figure('Name','image information register','MenuBar','none','ToolBar','none','Tag','Inforeg');
            initPosition = pararead.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 300, 300];
            pixelsize=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Camera pixel size(micron)','FontSize',12,...
                'Position',[0.05,0.7,0.4,0.2]);
            magnification=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Magnification','FontSize',12,...
                'Position',[0.05,0.45,0.4,0.2]);
            step_size=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Step size(micron)','FontSize',12,...
                'Position',[0.05,0.25,0.4,0.2]);
            stepsize=string(obj.guihandles.menu_file_f1.UserData.stepsize);
            pixsize=string(obj.guihandles.menu_file_f1.UserData.pixelsize);
            magnif=string(obj.guihandles.menu_file_f1.UserData.magnification);
            pixelsize_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','pixelsize','String',pixsize,'FontSize',12,'Position',[0.55,0.77,0.3,0.1]);
            magnification_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','magnification','String',magnif,'FontSize',12,'Position',[0.55,0.57,0.3,0.1]);
            step_size_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','step_size','FontSize',12,'String',stepsize,'Position',[0.55,0.37,0.3,0.1]);
            confirmation=uicontrol(pararead,'Style','pushbutton','String','confirm',...
                'Units','normalized','Position',[0.4 0.1 0.2 0.1],'FontSize',12,...
                'Callback',{@obj.Inforegister,obj});
        end
        %------------------------------------------------------------------
        function PSFread(hObject,src,event, obj)
            [imgfile, imgpath] = uigetfile_rui( {'*.tif';'*.tiff';'*.mat'}, 'please select data');
            imgfilestr=imgfile{1,1};
            idx = strfind(imgfilestr,'.');
            file_exten=extractAfter(imgfilestr,idx);
            switch file_exten
                case 'mat'
                    data=load(imgfilestr);
                    data=struct2cell(data);
                    data=data{1,1};
                otherwise
                    data=tiff_reader_rui(imgfile);
            end
            obj.guihandles.menu_file_f2.UserData=data;
            if isstruct(data)
                set(obj.guihandles.menu_psfdisplay,'Enable','on');
                obj.guihandles.PSFdata=data;
            end
        end
        %------------------------------------------------------------------
        
        function image_save(hObject,src,event,obj)
            pararead=figure('Name','image save','MenuBar','none','ToolBar','none','Tag','imagesave');
            initPosition = pararead.Position;
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 400, 300];
            imgsele=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','image to be saved','FontSize',12,...
                'Position',[0.05,0.73,0.4,0.2]);
            datanamepool={'raw ROI','raw ROI Deconv','raw ROI WBC',...
                'raw ROI WBC Deconv','raw ROI Deconv WBC'};
            dataname=cell(1,1);
            dataname{1,1}='name';
            for i=1:5
                if ~isempty(obj.guihandles.Data{1,i})
                    idx=length(dataname);
                    dataname{1,idx+1}=datanamepool{1,i};
                end
            end
            dataname(ismember(dataname,'name'))=[];
            imgsele_in=uicontrol(pararead,'Style','popupmenu','Units','normalized','Tag','imgsele',...
                'FontSize',12,'String',dataname,'Position',[0.55,0.75,0.3,0.2],'UserData',datanamepool);
            coorsele=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','coordinate selection','FontSize',12,...
                'Position',[0.05,0.55,0.4,0.2]);
            coorsele_in=uibuttongroup(pararead,'Visible','off','Position',[0.55,0.65,0.3,0.12],'Tag','coorsele');
            labcoordi=uicontrol(coorsele_in,'Style','radiobutton','String','Lab','Position',[10,1,60,30],...
                'HandleVisibility','off','FontSize',12);
            biocoordi=uicontrol(coorsele_in,'Style','radiobutton','String','Bio','Position',[60,1,60,30],...
                'HandleVisibility','off','FontSize',12);
            coorsele_in.Visible='on';
            slice_init=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','z range designate:         from','FontSize',12,'Position',[0.05,0.38,0.5,0.2]);
            slice_end=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','to','FontSize',12,'Position',[0.68,0.38,0.05,0.2]);
            slice_init_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'FontSize',12,'Position',[0.57,0.5,0.1,0.1],'Tag','slice_init_in');
            slice_end_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'FontSize',12,'Position',[0.75,0.5,0.1,0.1],'Tag','slice_end_in');
            pathsele=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','please designate path:','FontSize',12,...
                'Position',[0.05,0.23,0.4,0.2]);
            pathsele_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'String',obj.guihandles.menu_file_f3.UserData.imagepath,'FontSize',12,...
                'Position',[0.05,0.21,0.9,0.1],'Tag','savePath');
            confirmation=uicontrol(pararead,'Style','pushbutton','String','Save',...
                'Units','normalized','Position',[0.4 0.05 0.2 0.1],'FontSize',12,...
                'Callback',@(hObj,event) imagesaveproc(hObj,event,obj));
        end
        %------------------------------------------------------------------
        function PSF_save(hObject,src,event,obj)
            pararead=figure('Name','save current PSF data','MenuBar','none','ToolBar','none','Tag','psfsave');
            initPosition = pararead.Position;
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 400, 180];
            pathsele=uicontrol(pararead,'Style','Text','Units','normalized',...
                'String','please designate save path and data name','FontSize',12,...
                'Position',[0.05,0.75,0.9,0.15]);
            ItemSele=uicontrol(pararead,'Style','Text','Units','normalized',...
                'String','Items to be saved','FontSize',12,...
                'Position',[0.05,0.3,0.4,0.15]);
            slash_pos=strfind(obj.guihandles.PSFdata.path{1,1},'\');
            psf_path=obj.guihandles.PSFdata.path{1,1};
            psf_path=strcat(psf_path(1:slash_pos(length(slash_pos))),'PSFdata');
            pathsele_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'String',psf_path,'FontSize',12,...
                'Position',[0.05,0.6,0.9,0.15],'Tag','savePath');
            Alldata=uicontrol(pararead,'Style','checkbox','Units','normalized',...
                'FontSize',12,'Position',[0.5,0.4,0.4,0.1],'Tag','Alldata','String','save all info');
            Volumedata=uicontrol(pararead,'Style','checkbox','Units','normalized',...
                'FontSize',12,'Position',[0.5,0.3,0.4,0.1],'Tag','Volumedata','String','save volume');
            confirmation=uicontrol(pararead,'Style','pushbutton','String','Save',...
                'Units','normalized','Position',[0.4 0.08 0.2 0.15],'FontSize',12,...
                'Callback',@(hObj,event) PSFsaveproc(hObj,event,obj));
        end
        %------------------------------------------------------------------
        
        function Inforegister(obj,a,b,c)
            pararead=findobj('Tag','Inforeg');
            pixelsize_in=findobj('Tag','pixelsize');
            magnification_in=findobj('Tag','magnification');
            step_size_in=findobj('Tag','step_size');
            pixsize=str2double(pixelsize_in.String);
            stepsize=str2double(step_size_in.String);
            magnif=str2double(magnification_in.String);
            if obj.guihandles.ifImg
                obj.guihandles.menu_file_f1.UserData.pixelsize=pixsize;  % camera pixel size
                obj.guihandles.menu_file_f1.UserData.stepsize=stepsize;
                obj.guihandles.menu_file_f1.UserData.magnification=magnif;
            else
                obj.guihandles.PSFdata.pixelsize=pixsize;
                obj.guihandles.PSFdata.stepsize=stepsize;
                obj.guihandles.PSFdata.magnification=magnif;
            end
            close(pararead);
            
        end
        %------------------------------------------------------------------
        function axplane_display(obj,a,b,c)
            pararead=figure('Name','scale','MenuBar','none','ToolBar','none','Tag','dialogbox');
            initPosition = pararead.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 300, 300];
            pixelsize=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Camera pixel size(micron)','FontSize',12,...
                'Position',[0.05,0.7,0.4,0.2]);
            magnification=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Magnification','FontSize',12,...
                'Position',[0.05,0.45,0.4,0.2]);
            step_size=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','Step size(micron)','FontSize',12,...
                'Position',[0.05,0.25,0.4,0.2]);
            pixelsize_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','pixelsize','FontSize',12,'Position',[0.55,0.77,0.3,0.1]);
            magnification_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','magnification','FontSize',12,'Position',[0.55,0.57,0.3,0.1]);
            step_size_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','step_size','FontSize',12,'Position',[0.55,0.37,0.3,0.1]);
            confirmation=uicontrol(pararead,'Style','pushbutton','String','Draw!',...
                'Units','normalized','Position',[0.4 0.1 0.2 0.1],'FontSize',12,...
                'Callback',{@obj.drawaxialplane,obj});
        end
        
        %------------------------------------------------------------------
        function drawaxialplane(obj,hObject,src,event)
            pixelsize_in=findobj('Tag','pixelsize');
            magnification_in=findobj('Tag','magnification');
            step_size_in=findobj('Tag','step_size');
            pixsize=str2double(pixelsize_in.String);
            stepsize=str2double(step_size_in.String);
            magnif=str2double(magnification_in.String);
            pararead=findobj('Tag','dialogbox');
            if pixsize<=0 | stepsize<=0 | magnif<=0 | (pixsize/magnif)>stepsize
                msgbox('Please entry compatible parameters')
                return
            else
                close(pararead)
                data=get(obj.guihandles.xyslider,'UserData');
                if data.row==0
                    msgbox('Please load imagedata')
                    return
                else
                    slice_factor=stepsize/pixsize*magnif;
                    num_row=data.row;
                    num_col=data.col;
                    num_slice_ori=data.slice;
                    num_slice=round(data.slice*slice_factor);
                    x=(linspace(1,num_slice_ori,num_slice_ori))';
                    xx=(linspace(1,num_slice_ori,num_slice))';
                    img=zeros(num_row,num_col,num_slice);
                    data_temp=double(data.threeDdata);
                    for i=1:num_row
                        for j=1:num_col
                            temp=spline(x,reshape(data_temp(i,j,:),num_slice_ori,1),xx);
                            img(i,j,:)=temp;
                        end
                    end
                    img(img<0)=0;
                    img=uint16(img);
                    data.slice=num_slice;
                    data.threeDdata=img;
                    obj.guihandles.xyslider.UserData=data;
                    set(obj.guihandles.xyslider,'Min',1,'Max',num_slice,'Value',1,'SliderStep',[1/num_slice,1/num_slice*10]);
                    obj.guihandles.xzshow=axes('Parent',obj.guihandles.panel_2);
                    obj.guihandles.yzshow=axes('Parent',obj.guihandles.panel_3);
                    axes(obj.guihandles.xzshow);
                    imshow(reshape(img(round(num_row/2),:,:),num_slice,num_col));
                    axes(obj.guihandles.yzshow);
                    imshow(reshape((img(:,round(num_col/2),:)),num_row,num_slice));
                end
            end
        end
        %------------------------------------------------------------------
        function ROIselect(obj,a,b,c)
            if isempty(findobj('Tag','ROIconfirmation'))
                data=get(obj.Panel_1.xyslider,'UserData');
                data_xyMIP=MIP(data.threeDdata,6.5,66.666667,0.2,'xy');
                obj.Panel_1.xyslider.UserData.xyMIP=data_xyMIP;
            else
                confirmationBox=findobj('Tag','ROIconfirmation');
                data_xyMIP=obj.Panel_1.xyslider.UserData.xyMIP;
                close(confirmationBox)
            end
            axes(obj.Panel_1.xyshow);
            imshow(data_xyMIP,[]);
            rect=getrect;
            obj.guihandles.menu_analyze_ROIselect_flag.new.xmin=round(rect(2));
            obj.guihandles.menu_analyze_ROIselect_flag.new.xmax=round(rect(2)+rect(4));
            obj.guihandles.menu_analyze_ROIselect_flag.new.ymin=round(rect(1));
            obj.guihandles.menu_analyze_ROIselect_flag.new.ymax=round(rect(1)+rect(3));
            imshow(data_xyMIP(rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3))),[]);
            confirmationBox=figure('Name','none','MenuBar','none','ToolBar','none','Tag','ROIconfirmation');
            initPosition = confirmationBox.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
            confirmationBox.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 300, 250];
            promptMsg=uicontrol(confirmationBox,'Style','text','Units','normalized',...
                'String','Please designate z range:','FontSize',12,'Position',[0.1,0.72,0.8,0.2]);
            slice_init=uicontrol(confirmationBox,'Style','text','Units','normalized',...
                'String','from','FontSize',12,'Position',[0.12,0.65,0.2,0.1]);
            slice_end=uicontrol(confirmationBox,'Style','text','Units','normalized',...
                'String','to','FontSize',12,'Position',[0.42,0.65,0.2,0.1]);
            slice_init_in=uicontrol(confirmationBox,'Style','edit','Units','normalized',...
                'FontSize',12,'Position',[0.3,0.65,0.15,0.1],'Tag','slice_init_in');
            slice_end_in=uicontrol(confirmationBox,'Style','edit','Units','normalized',...
                'FontSize',12,'Position',[0.6,0.65,0.15,0.1],'Tag','slice_end_in');
            bgsconfirm=uicontrol(confirmationBox,'Style','checkbox','Units','normalized',...
                'FontSize',12,'Position',[0.1,0.45,0.99,0.2],'Tag','bgs');
            lastsele=uicontrol(confirmationBox,'Style','checkbox','Units','normalized',...
                'FontSize',12,'Position',[0.15,0.3,0.99,0.2],'Tag','lastsele','String','       use last selection');
            if isempty(obj.guihandles.menu_analyze_ROIselect_flag.old.xmin)
                set(lastsele,'Enable','off')
            end
            set(bgsconfirm,'String','constant background subtraction');
            confirmation=uicontrol(confirmationBox,'Style','pushbutton','String','confirm',...
                'Units','normalized','Position',[0.15 0.1 0.3 0.15],'FontSize',12,...
                'Callback',{@obj.ROI_confirmation,obj});
            reselection=uicontrol(confirmationBox,'Style','pushbutton','String','re-select',...
                'Units','normalized','Position',[0.55 0.1 0.3 0.15],'FontSize',12,...
                'Callback',{@obj.ROIselect,obj});
        end
        function ROI_confirmation(obj,a,b,c)
            confirmationBox=findobj('Tag','ROIconfirmation');
            bgsflag=findobj('Tag','bgs');
            lastsele=findobj('Tag','lastsele');
            lastsele=logical(lastsele.Value);
            zmin=findobj('Tag','slice_init_in');
            zmax=findobj('Tag','slice_end_in');
            obj.guihandles.menu_analyze_ROIselect_flag.new.zmin=str2double(zmin.String);
            obj.guihandles.menu_analyze_ROIselect_flag.new.zmax=str2double(zmax.String);
            bgsflag=logical(bgsflag.Value);
            close(confirmationBox);
            if lastsele
                obj.guihandles.menu_analyze_ROIselect_flag.new=obj.guihandles.menu_analyze_ROIselect_flag.old;
                zmin=obj.guihandles.menu_analyze_ROIselect_flag.new.zmin;
                zmax=obj.guihandles.menu_analyze_ROIselect_flag.new.zmax;
                if isempty(strfind(obj.guihandles.menu_file_f3.UserData.imagename,'det2'))
                    xmin=obj.guihandles.menu_analyze_ROIselect_flag.new.xmin+obj.guihandles.twoChannelcor(1);
                    xmax=obj.guihandles.menu_analyze_ROIselect_flag.new.xmax+obj.guihandles.twoChannelcor(1);
                    ymin=obj.guihandles.menu_analyze_ROIselect_flag.new.ymin+obj.guihandles.twoChannelcor(2);
                    ymax=obj.guihandles.menu_analyze_ROIselect_flag.new.ymax+obj.guihandles.twoChannelcor(2);
                else
                    xmin=obj.guihandles.menu_analyze_ROIselect_flag.new.xmin;
                    xmax=obj.guihandles.menu_analyze_ROIselect_flag.new.xmax;
                    ymin=obj.guihandles.menu_analyze_ROIselect_flag.new.ymin;
                    ymax=obj.guihandles.menu_analyze_ROIselect_flag.new.ymax;
                end
            else
                zmin=obj.guihandles.menu_analyze_ROIselect_flag.new.zmin;
                zmax=obj.guihandles.menu_analyze_ROIselect_flag.new.zmax;
                xmin=obj.guihandles.menu_analyze_ROIselect_flag.new.xmin;
                xmax=obj.guihandles.menu_analyze_ROIselect_flag.new.xmax;
                ymin=obj.guihandles.menu_analyze_ROIselect_flag.new.ymin;
                ymax=obj.guihandles.menu_analyze_ROIselect_flag.new.ymax;
            end
            temp=obj.Panel_1.xyslider.UserData.threeDdata(xmin:xmax,ymin:ymax,zmin:zmax);
            if bgsflag
                % constant background shall be abstracted from ROI image. Doing
                % so prepares ROI image for either deconvolution or wbc on
                % account of PSF aquisition elliminated background
                [x y z]=size(temp);
                greyval_tot=reshape(temp,[x*y*z 1]);
                %%%%%%%%%%Gaussian fit%%%%%%%%%%%%%
                greylev_tot=linspace(70,3000,2931);
                [counts_tot centers_tot]=histcounts(greyval_tot,greylev_tot);
                bg_aver=centers_tot(find(counts_tot==max(counts_tot)));
                Image3D=temp-bg_aver;
            else
                Image3D=temp;
            end
            obj.guihandles.Data{1,1}=Image3D;
            obj.Panel_1.xyslider.UserData.threeDdata=obj.guihandles.Data{1,1};
            obj.Panel_1.xyslider.UserData.row=xmax-xmin+1;
            obj.Panel_1.xyslider.UserData.col=ymax-ymin+1;
            obj.Panel_1.xyslider.UserData.slice=zmax-zmin+1;
            z=zmax-zmin+1;
            set(obj.Panel_1.xyslider,'Max',z,'Value',1,'SliderStep',[1/z,1/z*10]);
            obj.Panel_1.totslice.String=string(z);
            obj.guihandles.menu_analyze_ROIselect_flag.old=obj.guihandles.menu_analyze_ROIselect_flag.new;
        end
        %------------------------------------------------------------------
        function Deconv_setting(obj,a,b,c)
            pararead=figure('Name','parameter setting','MenuBar','none','ToolBar','none','Tag','ParaDeconv');
            initPosition = pararead.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 300, 300];
            stepsize_img=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','step size of image(micron)','FontSize',12,...
                'Position',[0.05,0.71,0.4,0.2]);
            stepsize_psf=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','step size of PSF(micron)','FontSize',12,...
                'Position',[0.05,0.54,0.4,0.2]);
            iterations=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','number of iterations','FontSize',12,...
                'Position',[0.05,0.345,0.4,0.2]);
            imgtobedoconv=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','image selection','FontSize',12,...
                'Position',[0.05,0.175,0.4,0.2]);
            stepsize=string(obj.guihandles.menu_file_f1.UserData.stepsize);
            stepsize_img_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','stepsize_img','String',stepsize,'FontSize',12,'Position',[0.55,0.8,0.3,0.1]);
            stepsize_psf_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','stepsize_psf','FontSize',12,'Position',[0.55,0.63,0.3,0.1]);
            iterations_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','iterations','FontSize',12,'Position',[0.55,0.46,0.3,0.1]);
            imagepool={'raw ROI','raw ROI WBC'};
            dataname=cell(1,1);
            dataname{1,1}='name';
            if ~isempty(obj.guihandles.Data{1,1})
                idx=length(dataname);
                dataname{1,idx+1}=imagepool{1,1};
            end
            if ~isempty(obj.guihandles.Data{1,3})
                idx=length(dataname);
                dataname{1,idx+1}=imagepool{1,2};
            end
            dataname(ismember(dataname,'name'))=[];
            image_selec=uicontrol(pararead,'Style','popupmenu','Units','normalized',...
                'Tag','img_selec','Fontsize',12,'Position',[0.48,0.275,0.45,0.1],...
                'String',dataname);
            confirmation=uicontrol(pararead,'Style','pushbutton','String','Start',...
                'Units','normalized','Position',[0.35 0.1 0.3 0.12],'FontSize',12,...
                'Callback',{@obj.Deconv,obj});
        end
        function Deconv(obj,a,b,c)
            stepsize_img=findobj('Tag','stepsize_img');
            stepsize_psf=findobj('Tag','stepsize_psf');
            image_selec=findobj('Tag','img_selec');
            num_iter=findobj('Tag','iterations');
            image=string(image_selec.String(image_selec.Value));
            stepsize_img=str2double(stepsize_img.String);
            obj.guihandles.menu_file_f1.UserData.stepsize=stepsize_img;
            stepsize_psf=str2double(stepsize_psf.String);
            num_iter=str2double(num_iter.String);
            pararead=findobj('Tag','ParaDeconv');
            if (rem(stepsize_img,stepsize_psf)*rem(stepsize_psf,stepsize_img))~=0  % psf step size has to be integral multiple of image step size or vice versa
                msgbox('step sizes are not compatible');
            else
                if isempty(obj.guihandles.batchpipeline.method)
                    obj.guihandles.batchpipeline.method{1,1}='DECONV';
                    obj.guihandles.batchpipeline.para{1,1}=[stepsize_img stepsize_psf num_iter];
                else
                    indx=length(obj.guihandles.batchpipeline.method);
                    obj.guihandles.batchpipeline.method{1,indx+1}='DECONV';
                    obj.guihandles.batchpipeline.para{1,indx+1}=[stepsize_img stepsize_psf num_iter];
                end
                close(pararead);
                % image input should always be 16 bit
                if image=="raw ROI"
                    data_img=obj.guihandles.Data{1,1};
                else
                    data_img=obj.guihandles.Data{1,3};
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                data_psf_temp=obj.guihandles.menu_file_f2.UserData;
                if isstruct(data_psf_temp)
                    [data_psf ~]=psf_aver(data_psf_temp.data);
                else
                    data_psf=data_psf_temp;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if image=="raw ROI"
                    [img breakflag]=Fcn_deconv(data_img,data_psf,stepsize_img,stepsize_psf,num_iter);
                    if ~breakflag
                        obj.guihandles.Data{1,2}=img;
                    end
                else
                    [img breakflag]=Fcn_deconv(data_img,data_psf,stepsize_img,stepsize_psf,num_iter);
                    if ~breakflag
                        obj.guihandles.Data{1,5}=img;
                    end
                end
            end
        end
        %------------------------------------------------------------------
        function WBC_setting(obj,a,b,c)
            pararead=figure('Name','parameter setting','MenuBar','none','ToolBar','none','Tag','ParaWBC');
            initPosition = pararead.Position;
            pararead.Position = [initPosition(1), ...
                initPosition(2) - 400 + initPosition(4), 300, 150];
            order_wbc=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','noise level','FontSize',12,...
                'Position',[0.05,0.68,0.4,0.2]); % updated wbc version
            order_wbc_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                'Tag','wbc_order','FontSize',12,...
                'Position',[0.55,0.7,0.3,0.2]);
            imgtobewbc=uicontrol(pararead,'Style','text','Units','normalized',...
                'String','image selection','FontSize',12,...
                'Position',[0.05,0.375,0.4,0.2]);
            imagepool={'raw ROI','raw ROI Deconv'};
            dataname=cell(1,1);
            dataname{1,1}='name';
            if ~isempty(obj.guihandles.Data{1,1})
                idx=length(dataname);
                dataname{1,idx+1}=imagepool{1,1};
            end
            if ~isempty(obj.guihandles.Data{1,2})
                idx=length(dataname);
                dataname{1,idx+1}=imagepool{1,2};
            end
            dataname(ismember(dataname,'name'))=[];
            image_selec=uicontrol(pararead,'Style','popupmenu','Units','normalized',...
                'Tag','img_selec','Fontsize',12,'Position',[0.48,0.475,0.45,0.1],...
                'String',dataname);
            confirmation=uicontrol(pararead,'Style','pushbutton','String','Start',...
                'Units','normalized','Position',[0.35 0.15 0.3 0.15],'FontSize',12,...
                'Callback',{@obj.WBC,obj});
        end
        function WBC(obj,a,b,c)
            wbc_order=findobj('Tag','wbc_order');
            wbc_order=str2double(wbc_order.String);
            img_tag=findobj('Tag','img_selec');
            img_tag=string(img_tag.String(img_tag.Value));
            pararead=findobj('Tag','ParaWBC');
            if isempty(obj.guihandles.batchpipeline.method)
                obj.guihandles.batchpipeline.method{1,1}='WBC';
                obj.guihandles.batchpipeline.para{1,1}=wbc_order;
            else
                indx=length(obj.guihandles.batchpipeline.method);
                obj.guihandles.batchpipeline.method{1,indx+1}='WBC';
                obj.guihandles.batchpipeline.para{1,indx+1}=wbc_order;
            end
            close(pararead);
            switch img_tag
                case "raw ROI"
                    %                     [img breakflag]=Fcn_wbc(obj.guihandles.Data{1,1},wbc_order);
                    %                     if ~breakflag
                    %                         obj.guihandles.Data{1,3}=img;
                    %                     end
                    img=Fcn_wbc(obj.guihandles.Data{1,1},wbc_order);
                    obj.guihandles.Data{1,3}=img;
                case "raw ROI Deconv"
                    img=Fcn_wbc(obj.guihandles.Data{1,2},wbc_order);
                    obj.guihandles.Data{1,4}=img;
            end
        end
        %------------------------------------------------------------------
        % 1 reads ROI sele data and image info registration data
        % 2 read batchpipeline data
        % 3 initiate image loading
        function batchproce(obj,a,b,c)
            [imgfile, imgpath] = uigetfile_rui( {'*.tiff';'*.tif'}, 'please select image');
            median_value=[];
            bg_value=[];
            noise_value=[];
            for i=1:length(imgfile)
                slash_pos=strfind(imgfile{i,1},'\');
                dot_pos=strfind(imgfile{i,1},'.');
                temp_n=length(slash_pos);
                imagename=imgfile{i,1};
                imagename=imagename((slash_pos(temp_n)+1):(dot_pos-1));
                temp=cell(1,1);
                temp{1,1}=imgfile{i,1};
                [img breakflag]= tiff_reader_rui(temp);
                % image crop
                if isempty(strfind(imagename,'det2'))
                    xmin=obj.guihandles.menu_analyze_ROIselect_flag.old.xmin+obj.guihandles.twoChannelcor(1);
                    xmax=obj.guihandles.menu_analyze_ROIselect_flag.old.xmax+obj.guihandles.twoChannelcor(1);
                    ymin=obj.guihandles.menu_analyze_ROIselect_flag.old.ymin+obj.guihandles.twoChannelcor(2);
                    ymax=obj.guihandles.menu_analyze_ROIselect_flag.old.ymax+obj.guihandles.twoChannelcor(2);
                else
                    xmin=obj.guihandles.menu_analyze_ROIselect_flag.old.xmin;
                    xmax=obj.guihandles.menu_analyze_ROIselect_flag.old.xmax;
                    ymin=obj.guihandles.menu_analyze_ROIselect_flag.old.ymin;
                    ymax=obj.guihandles.menu_analyze_ROIselect_flag.old.ymax;
                end
                zmin=obj.guihandles.menu_analyze_ROIselect_flag.old.zmin;
                zmax=obj.guihandles.menu_analyze_ROIselect_flag.old.zmax;
                img=img(xmin:xmax,ymin:ymax,zmin:zmax);
                % direct current background subtracting
                [x y z]=size(img);
                greyval_tot=reshape(img,[x*y*z 1]);
                %%%%%%%%%%Gaussian fit%%%%%%%%%%%%%
                greylev_tot=linspace(70,3000,2931);
                [counts_tot centers_tot]=histcounts(greyval_tot,greylev_tot);
                bg_aver=centers_tot(find(counts_tot==max(counts_tot)));
                bg_vec=greyval_tot(find(greyval_tot<(bg_aver+1)));
                greylev=linspace(70,bg_aver,bg_aver-70+1);
                [counts centers]=hist(bg_vec,greylev);
                greylev_sym=linspace(70,70+2*(bg_aver-70),2*(bg_aver-70)+1);
                temp=flip(counts);
                greyval_vec_sym=[counts,temp(2:bg_aver-70+1)];
                [sigma,mu,A]=mygaussfit(greylev_sym,greyval_vec_sym);
                %   f(x) =  a1*exp(-((x-b1)/c1)^2)
                %%%%%%%%%%%%%% maximum and median find %%%%%%%%%%%%%%%%
                [counts_tot centers_tot]=histcounts(greyval_tot,greylev_tot);
                counts_tot(1:(2*(bg_aver-70)+1))=counts_tot(1:(2*(bg_aver-70)+1))-greyval_vec_sym;
                counts_tot(find(counts_tot<0))=0;
                centers_tot_shift=linspace(1,2000,2000);
                counts_tot_shift=counts_tot(bg_aver-70+1:bg_aver-70+2000);
                A=ones(length(counts_tot_shift));
                operator_A=tril(A)';
                posibility_greyval=flip(operator_A*flip(counts_tot_shift'));
                signal_median=abs(posibility_greyval-sum(counts_tot_shift)/2);
                signal_median=find(signal_median==min(signal_median));
                median_value=[median_value,signal_median];
                bg_value=[bg_value,bg_aver];
                noise_value=[noise_value,sigma*sqrt(2)];
                Image3D=img-bg_aver;
                for j=1:length(obj.guihandles.batchpipeline.method)
                    parameter_method=obj.guihandles.batchpipeline.para{1,j};
                    switch obj.guihandles.batchpipeline.method{1,j}
                        case 'WBC'
                            imagename=strcat(imagename,'_WBC');
                            Image3D=Fcn_wbc(Image3D,parameter_method);
                        case 'DECONV'
                            imagename=strcat(imagename,'_DECONV');
                            data_psf_temp=obj.guihandles.menu_file_f2.UserData;
                            if isstruct(data_psf_temp)
                                [data_psf ~]=psf_aver(data_psf_temp.data);
                            else
                                data_psf=data_psf_temp;
                            end
                            [Image3D breakflag]=Fcn_deconv(Image3D,data_psf,parameter_method(1),parameter_method(2),parameter_method(3));
                        case 'Bio'
                            imagename=strcat(imagename,'_Bio');
                            imginfo=struct('magnification',[],'pixelsize',[],'stepsize',[]);
                            imginfo.magnification=obj.guihandles.menu_file_f1.UserData.magnification;
                            imginfo.stepsize=obj.guihandles.menu_file_f1.UserData.stepsize;
                            imginfo.pixelsize=obj.guihandles.menu_file_f1.UserData.pixelsize;
                            Image3D=coordinatetrans(Image3D,imginfo);
                        case 'SLICE'
                            imagename=strcat(imagename,'.tiff');
                            fullname=strcat(imgpath,imagename);
                            for k=parameter_method(1):parameter_method(2)
                                imwrite(Image3D(:,:,k),fullname,'WriteMode','append');
                            end
                    end
                end
            end
            SNR=median_value./noise_value;
            SBR=median_value./bg_value;
            photobleaching=struct('SNR',SNR,'SBR',SBR);
            save(strcat(imgpath,'photobleaching_data.mat'),'photobleaching');
        end
        %------------------------------------------------------------------
        function PSFextr_setting(obj,a,b,c)
            if isempty(obj.guihandles.PSFdata.pixelsize)
                msgbox('please register image information')
            else
                if isempty(obj.guihandles.menu_analyze_ROIselect_flag.old.xmin)
                    msgbox('please select ROI')
                else
                    if isempty(obj.guihandles.PSFdata.path)
                        msgbox('Please load more than one image as PSF raw data')
                    else
                        pararead=figure('Name','PSF extraction parameter setting','MenuBar','none','ToolBar','none','Tag','PSFpara');
                        initPosition = pararead.Position;  % initPosition(1) initPosition(2) are x y cordinate, whose origin is located on lower left corner of screen
                        pararead.Position = [initPosition(1), ...
                            initPosition(2) - 400 + initPosition(4), 300, 150];
                        width=uicontrol(pararead,'Style','text','Units','normalized',...
                            'String','volume half width (pixel)','FontSize',12,...
                            'Position',[0.03,0.69,0.6,0.2]);
                        height=uicontrol(pararead,'Style','text','Units','normalized',...
                            'String','volume half height (step)','FontSize',12,...
                            'Position',[0.03,0.38,0.6,0.2]);
                        width_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                            'Tag','width','FontSize',12,'Position',[0.7,0.7,0.2,0.2]);
                        height_in=uicontrol(pararead,'Style','edit','Units','normalized',...
                            'Tag','height','FontSize',12,'Position',[0.7,0.4,0.2,0.2]);
                        confirmation=uicontrol(pararead,'Style','pushbutton','String','confirm',...
                            'Units','normalized','Position',[0.4 0.14 0.2 0.2],'FontSize',12,...
                            'Callback',@(hObj,event) Fcn_PSFextract(hObj,event,obj));
                    end
                end
            end
        end
        
    end
end

