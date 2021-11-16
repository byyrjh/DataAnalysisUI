clear;
clc;
a=uint16(zeros(2048,2048,200));
for i=1:2048
    for j=1:2048
     a(i,j,1)=round(normrnd(110,30));
    end
end
for k=1:200
    a(:,:,k)=a(:,:,1);
end
for k=1:100
    imwrite(a(:,:,k),'null_psf_data100.tiff','WriteMode','append');
end