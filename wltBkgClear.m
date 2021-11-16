function imgout = wltBkgClear(datain, pxreg, lvl)

nframes = 0;
dinfo = [];
imgout = [];

if (isa(datain, 'char'))
    if (exist(datain,'file'))
        dinfo = imfinfo(datain);
        nframes = length(dinfo);
        if (isempty(pxreg))
            pxreg = {[1 dinfo(1).Height],[1 dinfo(1).Width]};
        end
        imgout = zeros([diff(pxreg{1})+1, diff(pxreg{2})+1, nframes]);
    end
elseif (isa(datain,'double') || isa(datain,'integer'))
    imgin = datain;
    nframes = size(datain,3);
    imgout = zeros(size(imgin));
    if (isempty(pxreg))
        pxreg = {[1 size(datain,1)],[1 size(datain,2)]};
    end
end

psf_lat = pow2(lvl);

for f_idx = 1:nframes

    if (~isempty(dinfo))
        rimg = double(imread(dinfo(f_idx).Filename,'Info',dinfo, 'Index', f_idx, 'PixelRegion',pxreg));
    else
        rimg = imgin(pxreg{1}(1):pxreg{1}(2),pxreg{2}(1):pxreg{2}(2),f_idx);
    end
    
    wpt = wpdec2(rimg, lvl, 'db1');

    wptn = wpt;
    for l_idx = 1:lvl-1
        wptn = wpzero(wptn, l_idx, 1:3);
    end
    %plot(wptn);

    bkg = double(wprec2(wptn));
    %bkg = imfilter(bkg, gfs, 'same');
    bkg = imgaussfilt(bkg,psf_lat);

    imgout(:,:,f_idx) = rimg - bkg;
end