function [aver_psf aver_psf_N]=psf_aver(data_psf_temp)
temp=data_psf_temp{1,1};
aver_psf=zeros(size(temp.VolumeSet{1,1}));
aver_psf_N=zeros(size(temp.VolumeSet{1,1}));
for i=1:length(data_psf_temp)
    psfdataset=data_psf_temp{i,1};
    psfidx=linspace(1,length(psfdataset.VolumeSet),length(psfdataset.VolumeSet));
    psfidx=setdiff(psfidx,psfdataset.Manually_sele_idx);
    for j=1:length(psfidx)
        temp_psf=double(psfdataset.VolumeSet{psfidx(j),1});
        temp_psf=temp_psf/max(max(max(temp_psf)));
        aver_psf=aver_psf+temp_psf;
        aver_psf_N=aver_psf_N+double(psfdataset.VolumeSet{psfidx(j),1})/65535;
    end
end
aver_psf=uint16(aver_psf/max(max(max(aver_psf)))*65535);
aver_psf_N=uint16(aver_psf_N/max(max(max(aver_psf_N)))*65535);
end