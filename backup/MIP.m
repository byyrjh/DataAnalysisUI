function y=MIP(threeDimage,pixelsize,magnification,stepsize,prodir)
[height width stacks]=size(threeDimage);
threeDimage=double(threeDimage);
switch prodir
    case 'xy'
        y=(zeros(height,width));
        parfor i=1:stacks
            temp=threeDimage(:,:,i);
            y=max(y,temp);
        end
    case 'xz'
        y0=(zeros(stacks,height));
        for i=1:stacks
            temp=threeDimage(:,:,i);
            y0(i,:)=max(temp,[],2);
            realrows=round(stepsize*stacks*magnification/pixelsize);
            y=imresize(y0, [realrows height]);
        end
    case 'yz'
        y0=(zeros(stacks,width));
        for i=1:stacks
            temp=threeDimage(:,:,i);
            y0(i,:)=max(temp);
            realrows=round(stepsize*stacks*magnification/pixelsize);
            y=imresize(y0, [realrows width]);
        end
    otherwise
        warning('please provide valid projection plane.')
end
end