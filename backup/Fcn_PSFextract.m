function Fcn_PSFextract(hObj,event,obj)
pararead=findobj('Tag','PSFpara');
width_in=findobj('Tag','width');
height_in=findobj('Tag','height');
% parameters setting
width=str2double(width_in.String);  % usually 30 with lattice light sheet microscopy configuration
height=str2double(height_in.String);
stepsize=obj.guihandles.PSFdata.stepsize;
pixelsize=(obj.guihandles.PSFdata.pixelsize)/(obj.guihandles.PSFdata.magnification);
path_ary=obj.guihandles.PSFdata.path;
ROI_sele=obj.guihandles.menu_analyze_ROIselect_flag.old;
obj.guihandles.PSFdata.slices=ROI_sele.zmax-ROI_sele.zmin+1;
close(pararead);

f=waitbar(0,'0','Name','PSF processing',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
pages_tot=(ROI_sele.zmax-ROI_sele.zmin+1)*length(path_ary);
for i=1:length(path_ary)
    [pageNumber ~]=size(imfinfo(path_ary{i,1}));
    imgobj = Tiff(path_ary{i,1},'r');
    img3D=zeros(ROI_sele.xmax-ROI_sele.xmin+1,ROI_sele.ymax-ROI_sele.ymin+1,ROI_sele.zmax-ROI_sele.zmin+1);
    for j=(ROI_sele.zmin):(ROI_sele.zmax)
        imgobj.setDirectory(j)
        temp=imgobj.read;
        img3D(:,:,(j-ROI_sele.zmin+1))=temp((ROI_sele.xmin):(ROI_sele.xmax),(ROI_sele.ymin):(ROI_sele.ymax));
        if getappdata(f,'canceling')
            delete(f);
            return
        end
        page_idx=(i-1)*(ROI_sele.zmax-ROI_sele.zmin+1)+(j+1-ROI_sele.zmin);
        completed=strcat(num2str(round(page_idx/pages_tot,2)*100),'%completed');
        waitbar(page_idx/pages_tot,f,completed);
    end
    img3D=double(img3D);
    [dimx dimy dimz]=size(img3D);
    % constant background shall be abstracted from ROI image. Doing
    % so prepares ROI image for either deconvolution or wbc on
    % account of PSF aquisition elliminated background
    greyval_tot=reshape(img3D,[dimx*dimy*dimz 1]);
    %%%%%%%%%%Gaussian fit%%%%%%%%%%%%%
    greylev_tot=linspace(70,3000,2931);
    [counts_tot centers_tot]=hist(greyval_tot,greylev_tot);
    bg_aver=centers_tot(find(counts_tot==max(counts_tot)));
    img3D=img3D-bg_aver;
    % so far img3D is still raw data
    %% PSF center localization
    img3D_bead=img3D; % preserve raw data
    img3D(   img3D < 5*mean(mean(mean(img3D)))   ) = 0;  % data to facilitate local maximum algorithm
    %Find local maxima with prominence 0.2 x max value (brightest bead)
    LM = islocalmax(img3D,'MinProminence',0.2 * ( max(max(max(img3D))) - min(min(min(img3D))) ) );
    %Get coordinates
    [x,y,z] = ind2sub(size(LM),find(LM));
    BeadsPosition = [x y z];
    %kill local max next to each other
    BeadsPosition_iso=BeadsPosition;
    BeadsPosition_iso(:,3)=BeadsPosition(:,3)*(stepsize/pixelsize);% real position normalized to lateral pixel size
    [BeadsPositionTol,Tol] = uniquetol(BeadsPosition_iso,max(stepsize/pixelsize*(height*2+1),(width*2+1))/3*1.5,'ByRows', true, ...
        'OutputAllIndices', true, 'DataScale', [1 1 1]);  % 10 [1 1 1 ] cooresponds to distance of 30    10 [2 2 2] cooresponds to distance of 60
    [BeadsPositionTol_2,Tol_2] = uniquetol(BeadsPositionTol(:,1:2),10,'ByRows', true, ...
        'OutputAllIndices', true, 'DataScale', [1 1]);  % rule out bead close to one another within 20 pixel regardless of z coordinat value
    BeadsPositionTol_3=[];
    for k=1:length(Tol_2)
        if length(Tol_2{k,1})==1
            BeadsPositionTol_3=[BeadsPositionTol_3;BeadsPositionTol(Tol_2{k,1},:)];
        end
    end
    BeadsPositionTol_3(:,3)=round(BeadsPositionTol_3(:,3)/(stepsize/pixelsize));
    %Cut beads close to the edge
    BeadsPosition_ult = [];
    for q = 1:size(BeadsPositionTol_3,1)
        if (BeadsPositionTol_3(q,1) > (width+1) && BeadsPositionTol_3(q,1) < (dimx - width-1) ...
                && BeadsPositionTol_3(q,2) > (width+1 )&& BeadsPositionTol_3(q,2) <( dimy - width-1) ...
                && BeadsPositionTol_3(q,3) > (height+1) && BeadsPositionTol_3(q,3) < (dimz - height-1))
            
            BeadsPosition_ult = [BeadsPosition_ult; BeadsPositionTol_3(q,:)];
        end
    end
    %Replace Segmentation bead position with position of maximum intensity
    RealBeadsPosition = zeros(size(BeadsPosition_ult,1),3);
    [beadsnum ~]=size(BeadsPosition_ult);
    for n = 1:beadsnum
        
        bead = img3D(BeadsPosition_ult(n,1)-width:BeadsPosition_ult(n,1)+width,...
            BeadsPosition_ult(n,2)-width:BeadsPosition_ult(n,2)+width,...
            BeadsPosition_ult(n,3)-height:BeadsPosition_ult(n,3)+height);
        
        
        [maxb_value,maxb_index] = max(bead(:));
        [maxb_x,maxb_y,maxb_z] = ind2sub(size(bead),maxb_index);
        
        RealBeadsPosition(n,1) = BeadsPosition_ult(n,1) + maxb_x -width-1;
        RealBeadsPosition(n,2) = BeadsPosition_ult(n,2) + maxb_y -width-1;
        RealBeadsPosition(n,3) = BeadsPosition_ult(n,3) + maxb_z -height-1;
    end
    %% once again
    BeadsPosition_ult_temp=RealBeadsPosition;
    BeadsPosition_ult_temp(:,3)=BeadsPosition_ult_temp(:,3)*(stepsize/pixelsize);
    [BeadsPositionTol_ult,Tol_ult] = uniquetol(BeadsPosition_ult_temp,max(stepsize/pixelsize*(height*2+1),(width*2+1))/3*1.5,'ByRows', true, ...
        'OutputAllIndices', true, 'DataScale', [1 1 1]);
    BeadsPositionTol_ult_ult=[];
    for q=1:length(Tol_ult)
        if length(Tol_ult{q,1})==1
            BeadsPositionTol_ult_ult=[BeadsPositionTol_ult_ult;RealBeadsPosition(Tol_ult{q,1},:)];
        end
    end
    num_bead_pos=size(BeadsPositionTol_ult_ult,1);
    for q=1:num_bead_pos
        idx=num_bead_pos-q+1;
        if ~(BeadsPositionTol_ult_ult(idx,1) > (width+1) && BeadsPositionTol_ult_ult(idx,1) < (dimx - width-1) ...
                && BeadsPositionTol_ult_ult(idx,2) > (width+1 )&& BeadsPositionTol_ult_ult(idx,2) <( dimy - width-1) ...
                && BeadsPositionTol_ult_ult(idx,3) > (height+1) && BeadsPositionTol_ult_ult(idx,3) < (dimz - height-1))
            BeadsPositionTol_ult_ult(idx,:)=[];
        end
    end
    
    [beadsnum ~]=size(BeadsPositionTol_ult_ult);
    inten_bead=[];
    for q=1:beadsnum
        inten_bead=[inten_bead sum(sum(sum(img3D(BeadsPositionTol_ult_ult(q,1)-1:BeadsPositionTol_ult_ult(q,1)+1,...
            BeadsPositionTol_ult_ult(q,2)-1:BeadsPositionTol_ult_ult(q,2)+1,BeadsPositionTol_ult_ult(q,3)-1:BeadsPositionTol_ult_ult(q,3)+1))))];
    end
    index_trival=find(inten_bead<(50*27));
    BeadsPositionTol_ult_ult(index_trival,:)=[];
    
%     figure()
%     imagesc(sum(img3D_bead,3));
%     colormap('gray');
%     axis equal
%     axis([0 dimy 0 dimx])
%     hold on
%     scatter(BeadsPositionTol_ult_ult(:,2),BeadsPositionTol_ult_ult(:,1));
    
    xylength=(width*2+1)*pixelsize;
    zlength=(height*2+1)*stepsize;
    intp_xy=width*16;
    intp_z=height*16;
    numofbeads = size(BeadsPositionTol_ult_ult,1);
    PSFdata=struct('VolumeSet',[],'xyMIP',[],'PosSet',[],'FWHMset',[],'Manually_sele_idx',[]);
    volumeset=cell(numofbeads,1);
    measurament_beads=zeros(numofbeads,3);
    for n = 1:numofbeads
        bead = (img3D_bead(BeadsPositionTol_ult_ult(n,1)-width:BeadsPositionTol_ult_ult(n,1)+width,...
            BeadsPositionTol_ult_ult(n,2)-width:BeadsPositionTol_ult_ult(n,2)+width,...
            BeadsPositionTol_ult_ult(n,3)-height:BeadsPositionTol_ult_ult(n,3)+height));
        volumeset{n,1}=uint16(bead);
        bead=bead/bead(width+1,width+1,height+1);
        measurament_beads(n,1)=FWHM(bead(width+1,:,height+1),xylength,intp_xy);
        measurament_beads(n,2)=FWHM(bead(:,width+1,height+1),xylength,intp_xy);
        measurament_beads(n,3)=FWHM(reshape(bead(width+1,width+1,:),[1,(height*2+1)]),zlength,intp_z);
    end
    inx_min=find(measurament_beads(:,3)==min(measurament_beads(:,3)));
    if length(inx_min)>1
        inx_min=inx_min(1);
    end
    inx_max=find(measurament_beads(:,3)==max(measurament_beads(:,3)));
    if length(inx_max)>1
        inx_max=inx_max(1);
    end
    PSFdata.Manually_sele_idx=[inx_max inx_min];
    PSFdata.VolumeSet=volumeset;
    PSFdata.xyMIP=MIP(img3D_bead,1,1,1,'xy');
    PSFdata.PosSet=BeadsPositionTol_ult_ult;
    PSFdata.FWHMset=measurament_beads;
    obj.guihandles.PSFdata.data{i,1}=PSFdata;
end
delete(f);
% volumeViewer(average_bead_8);
end