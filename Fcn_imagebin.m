function image3D=Fcn_imagebin(input,binsize)
if binsize>1
    input=double(input);
    [x y z]=size(input);
    x_trim=rem(x,binsize);
    y_trim=rem(y,binsize);
    xdim=floor(x/binsize);
    ydim=floor(y/binsize);
    img_prebin=input(1:(x-x_trim),1:(y-y_trim),:);
    oprt1=zeros(y-y_trim,ydim);
    oprt2=zeros(x-x_trim,xdim);
    for i=1:ydim
        oprt1(((i-1)*binsize+1):i*binsize,i)=1;
    end
    for i=1:xdim
        oprt2(((i-1)*binsize+1):i*binsize,i)=1;
    end
    image3D=zeros(xdim,ydim,z);
    for j=1:z
        temp=img_prebin(:,:,j)*oprt1;
        img_postbin=(temp')*oprt2;
        image3D(:,:,j)=img_postbin';
    end
    image3D=image3D/(binsize^2);
    image3D=uint16(image3D);
else
    image3D=input;
end
end