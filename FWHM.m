function z=FWHM(data,datalength,interpolate)
data=double(data);
data=data/max(data);
pn_ori=length(data);
pn_intp=interpolate;
x=linspace(0,datalength,pn_ori);
xx=linspace(0,datalength,pn_intp);
data_intp=spline(x,data,xx);
loc_peak=find(data_intp==max(data_intp));
left_seg=data_intp(1:loc_peak);
left_seg=(left_seg-0.5);
right_seg=data_intp(loc_peak:pn_intp);
right_seg=(right_seg-0.5);
loc_left_arr=find(left_seg<0);
loc_left=loc_left_arr(length(loc_left_arr));
loc_right_arr=find(right_seg<0);
loc_right=loc_right_arr(1);
z=(loc_right-1+length(left_seg)-loc_left)*datalength/(pn_intp-1);
end

%% old version
% data=double(data);
% data=data/max(data);
% pn_ori=length(data);
% pn_intp=interpolate;
% x=linspace(0,datalength,pn_ori);
% xx=linspace(0,datalength,pn_intp);
% data_intp=spline(x,data,xx);
% loc_peak=find(data_intp==max(data_intp));
% left_seg=data_intp(1:loc_peak);
% left_seg=abs(left_seg-0.5);
% right_seg=data_intp(loc_peak:pn_intp);
% right_seg=abs(right_seg-0.5);
% loc_left=find(left_seg==min(left_seg));
% loc_right=find(right_seg==min(right_seg));
% z=(loc_right-1+length(left_seg)-loc_left)*datalength/(pn_intp-1);