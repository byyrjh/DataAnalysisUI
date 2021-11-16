clear;clc;
folder = 'Y:\hao\25_03_2019\lung_cancer_microtube_mgarnet2\';
gname='fov3_02step_c=561_b=G_t=0000_det1.tiff';
g_name='hemisphere_microtube.tiff';
subbere_x=512;
subbere_y=512;
anf_frame=50;
schl_frame=100;
anf_x=647;
anf_y=499;
offset = 128; %sCMOS-Camera Offset  
%%
gch=zeros(subbere_x,subbere_y,schl_frame-anf_frame+1,'uint16');
gpath = fullfile(folder, gname);
gsavepath=fullfile(folder,g_name);
ori_g=Tiff(gpath,'r');
normal_g=0;
for i=anf_frame:schl_frame
    ori_g.setDirectory(i);
    temp=flip((ori_g.read()-offset),2);
    gch(:,:,i-anf_frame+1)=temp(anf_x+1:anf_x+subbere_x,anf_y+1:anf_y+subbere_y);
    if max(max(gch(:,:,i-anf_frame+1)))>normal_g
        normal_g=max(max(gch(:,:,i-anf_frame+1)));
    end
end
normal_g=double(normal_g);
gch=uint16(double(gch)/normal_g*65535);

for i=1:(schl_frame-anf_frame+1)
    imwrite(gch(:,:,i),gsavepath,'WriteMode','append');
end