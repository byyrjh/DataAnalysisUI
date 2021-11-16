%%%%%%%%%%%%%definition on SNR and SBR%%%%%%%%%%%%%%%
% as the complexity of real image, the background here is just defined as the background of the camera
% the noise is defined as the standard deviation of background 
% the method to abstract signal out of background
% step 1
% assume background to be a constant 107, abstract pixel values less than
% 107, mirror this data with respect to 107, fit data to Gaussian curve,
% thus the sigma of Gaussian is noise
% step 2 
% fit all data histogram to a curve consisted of a Gaussion in step one and
% the remnant curve, which is the (signal+direct curent background) histogram
% step 3
% regard the median of signal as the representative value in calculation
%%
close all;
clear;
clc;
folder = 'Y:\Hao\2020_5_20\well1\fov13 time lapse\raw data\';
offset=0;
%-----Read Image-----------------------------------------------------
Image_fn = strcat('fov_hex_13_timelapse_c=473_b=h_t=0178_det2','.tiff');
ImageFileName = fullfile(folder, Image_fn);
[pageNumber ~]=size(imfinfo(ImageFileName));
obj = Tiff(ImageFileName,'r');
dimx = obj.getTag('ImageWidth');
dimy = obj.getTag('ImageLength');
dimz = pageNumber;   % # of Slices
Image3D_deconv = zeros(dimy,dimx,dimz,'uint16');
for i = 1:dimz
    obj.setDirectory(i);
    Image3D_deconv(:,:,i) =imrotate((obj.read()-offset),0);
end
Image3D_deconv=double(Image3D_deconv);
img=Image3D_deconv(1:889,585:1085,:);
[x y z]=size(img);
greyval_tot=reshape(img,[x*y*z 1]);
%%%%%%%%%%Gaussian fit%%%%%%%%%%%%%
greylev_tot=linspace(70,3000,2931);
[counts_tot centers_tot]=hist(greyval_tot,greylev_tot);

figure(1)
bar(centers_tot(1:200),counts_tot(1:200));
hold on
bg_aver=centers_tot(find(counts_tot==max(counts_tot)));
bg_vec=greyval_tot(find(greyval_tot<(bg_aver+1)));
greylev=linspace(70,bg_aver,bg_aver-70+1);
[counts centers]=hist(bg_vec,greylev);
greylev_sym=linspace(70,70+2*(bg_aver-70),2*(bg_aver-70)+1);
temp=flip(counts);
greyval_vec_sym=[counts,temp(2:bg_aver-70+1)];
[sigma,mu,A]=mygaussfit(greylev_sym,greyval_vec_sym);
plot(greylev_sym,A*exp((-(greylev_sym-mu).^2)/(2*sigma^2)));
figure(2)
bar(greylev_sym,greyval_vec_sym)
%   f(x) =  a1*exp(-((x-b1)/c1)^2)

%%%%%%%%%%%%%%poisson fit%%%%%%%%%%%%%%%%

[counts_tot centers_tot]=hist(greyval_tot,greylev_tot);
counts_tot(1:(2*(bg_aver-70)+1))=counts_tot(1:(2*(bg_aver-70)+1))-greyval_vec_sym;
counts_tot(find(counts_tot<0))=0;

centers_tot_shift=linspace(1,2000,2000);
counts_tot_shift=counts_tot(bg_aver-70+1:bg_aver-70+2000);
signal_max=find(counts_tot_shift==max(counts_tot_shift));
A=ones(length(counts_tot_shift));
operator_A=tril(A)';
posibility_greyval=flip(operator_A*flip(counts_tot_shift'));
signal_median=abs(posibility_greyval-sum(counts_tot_shift)/2);
signal_median=find(signal_median==min(signal_median));

centers_tot_shift_sum=linspace(5,1995,200);
counts_tot_shift_sum=sum(reshape(counts_tot_shift,[10,200]));
f1=figure(3);
ax=axes(f1);
set(gcf,'position',[200,200,1000,618])
bar(centers_tot_shift_sum,counts_tot_shift_sum)
set(gca,'FontSize',20)
axis([0 300  0 inf]);
xlabel('grey value','FontSize', 20)
ylabel('frequency','FontSize', 20)

f2=figure(4);
ax=axes(f2);
set(gcf,'position',[200,200,1000,618])
bar(centers_tot_shift,counts_tot_shift)
set(gca,'FontSize',20)
axis([0 300  0 inf]);
xlabel('grey value','FontSize', 20)
ylabel('frequency','FontSize', 20)
SNR=signal_median/sigma;
SBR=signal_median/mu;