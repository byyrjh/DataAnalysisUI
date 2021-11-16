function img=Fcn_wbc(Image3D,wbc_order,resolution_inpix)
Image3D=double(Image3D);
img=uint16(matWBNS(Image3D,resolution_inpix, wbc_order));  %resolution_inpix = 4 indicates the resolution(PSF FWHM) in pixels
% in light sheet microscopy lateral PSF FWHM is around 400 nm while the
% pixel size is 97 nm
end