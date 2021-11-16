clear;clc;
folder = 'Y:\hao\25_03_2019\lung_cancer_microtube_mgarnet2\';
gname='fov3_wnt_02step_c=473_b=G_t=0000_det1.tiff';
rname='fov3_02step_c=561_b=G_t=0000_det1.tiff';
g_name='fov3_g_hemisphere.tiff';
r_name='fov3_r_hemisphere.tiff';
subbere_x=512;
subbere_y=512;
anf_frame=35;
schl_frame=100;
rtrim_x=887;
rtrim_y=862;
gtrim_x=833;
gtrim_y=835;
anf_x=700;
anf_y=525;
offset = 128; %sCMOS-Camera Offset  
%%
shift_x=gtrim_x-rtrim_x;
shift_y=gtrim_y-rtrim_y;
gch=zeros(subbere_x,subbere_y,schl_frame-anf_frame+1,'uint16');
rch=zeros(subbere_x,subbere_y,schl_frame-anf_frame+1,'uint16');
bch=zeros(subbere_x,subbere_y,schl_frame-anf_frame+1,'uint16');
gpath = fullfile(folder, gname);
rpath = fullfile(folder, rname);
gsavepath=fullfile(folder,g_name);
rsavepath=fullfile(folder,r_name);
ori_g=Tiff(gpath,'r');
ori_r=Tiff(rpath,'r');
normal_r=0;
normal_g=0;
for i=anf_frame:schl_frame
    ori_g.setDirectory(i);
    ori_r.setDirectory(i);
    temp=ori_r.read()-offset;
    rch(:,:,i-anf_frame+1)=temp(anf_x+1:anf_x+subbere_x,anf_y+1:anf_y+subbere_y);
    if max(max(rch(:,:,i-anf_frame+1)))>normal_r
        normal_r=max(max(rch(:,:,i-anf_frame+1)));
    end
    temp=flip((ori_g.read()-offset),2);
    gch(:,:,i-anf_frame+1)=temp(anf_x+shift_x+1:anf_x+shift_x+subbere_x,anf_y+shift_y+1:anf_y+shift_y+subbere_y);
    if max(max(gch(:,:,i-anf_frame+1)))>normal_g
        normal_g=max(max(gch(:,:,i-anf_frame+1)));
    end
end
normal_g=double(normal_g);
normal_r=double(normal_r);
gch=uint16(double(gch)/normal_g*65535);
rch=uint16(double(rch)/normal_r*65535);
multi_ima=cat(3,rch(:,:,1),gch(:,:,1),bch(:,:,1));
for i=1:(schl_frame-anf_frame+1)
    imwrite(gch(:,:,i),gsavepath,'WriteMode','append');
    imwrite(rch(:,:,i),rsavepath,'WriteMode','append');
end