function batchproce(obj,a,b,c)
[imgfile, imgpath] = uigetfile_rui( {'*.tiff';'*.tif'}, 'please select image');
pararead=figure('Name','real-time processing parameter','MenuBar','none','ToolBar','none','Tag','ParaBatch');
initPosition = pararead.Position;
pararead.Position = [initPosition(1), ...
    initPosition(2) - 400 + initPosition(4), 300, 150];
num_stack=uicontrol(pararead,'Style','text','Units','normalized',...
    'String','number of stacks','FontSize',12,...
    'Position',[0.05,0.68,0.4,0.2]);
num_stack_in=uicontrol(pararead,'Style','edit','Units','normalized',...
    'Tag','num_stack','FontSize',12,...
    'Position',[0.55,0.7,0.3,0.2]);
t_wait=uicontrol(pararead,'Style','text','Units','normalized',...
    'String','waiting time(s)','FontSize',12,...
    'Position',[0.05,0.39,0.4,0.2]);
t_wait_in=uicontrol(pararead,'Style','edit','Units','normalized',...
    'Tag','t_wait','FontSize',12,...
    'Position',[0.55,0.4,0.3,0.2]);
confirmation=uicontrol(pararead,'Style','pushbutton','String','confirm',...
    'Units','normalized','Position',[0.35 0.15 0.3 0.15],'FontSize',12,...
    'Callback',{@obj.batch_para_load,obj});

median_value=zeros(obj.guihandles.batchpipeline.num_stack,length(imgfile));
bg_value=zeros(obj.guihandles.batchpipeline.num_stack,length(imgfile));
noise_value=zeros(obj.guihandles.batchpipeline.num_stack,length(imgfile));

slash_pos=strfind(imgfile{1,1},'\');
dot_pos=strfind(imgfile{1,1},'.');
temp_n=length(slash_pos);

imagename=cell(length(imgfile),1);
ini_ind=zeros(length(imgfile),1);
for i=1:length(imgfile)
    imgname=imgfile{i,1}((slash_pos(temp_n)+1):(dot_pos-1));
    imgind=strfind(imgname,'.tiff');
    ini_ind(i,1)=str2number(imgname(imgind-9:imgind-6));
    imagename{i,1}=imgname;
end

for i=1:obj.guihandles.batchpipeline.num_stack
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
    Image3D=Fcn_imagebin(Image3D,obj.guihandles.menu_file_f1.UserData.binsize);
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
                [Image3D breakflag]=Fcn_deconv(Image3D,data_psf,parameter_method(1),parameter_method(2),parameter_method(3),obj.guihandles.menu_file_f1.UserData.binsize);
            case 'Bio'
                imagename=strcat(imagename,'_Bio');
                imginfo=struct('magnification',[],'pixelsize',[],'stepsize',[]);
                imginfo.magnification=obj.guihandles.menu_file_f1.UserData.magnification;
                imginfo.stepsize=obj.guihandles.menu_file_f1.UserData.stepsize;
                imginfo.pixelsize=obj.guihandles.menu_file_f1.UserData.pixelsize;
                imginfo.binsize=obj.guihandles.menu_file_f1.UserData.binsize;
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
function batch_para_load(obj,a,b,c)
num_stack=findobj('Tag','num_stack');
t_wait=findobj('Tag','t_wait');
para_window=findobj('Tag','ParaBatch');
obj.guihandles.batchpipeline.t_wait=str2double(t_wait);
obj.guihandles.batchpipeline.num_stack=str2double(num_stack);
close(para_window);
end