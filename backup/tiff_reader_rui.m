%reading single tiff stack using tifflib
%--Rui
%input: imgfile: filepath, cell, output of uigetfile_rui
function [img breakflag]= tiff_reader_rui(imgfile)
info = cell(size(imgfile));
nframe = 0;
for i = 1 : length(imgfile)
  info{i} = imfinfo(imgfile{i}); 
  nframe = nframe + length(info{i});
end
nframe_1 = length(info{1});
width = info{1}(1).Width;
height = info{1}(1).Height;
img = zeros(height, width, nframe, 'uint16');
breakflag=logical(0);
f=waitbar(0,'1','Name','Imagedata Loading','tag','waitbar',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% F = findall(0,'type','figure','tag','waitbar');
setappdata(f,'canceling',0);
for i = 1 : nframe
    if getappdata(f,'canceling')
        breakflag=~breakflag;
        break
    end
    completed=strcat(num2str(round(i/nframe,2)*100),'%completed');
    waitbar(i/nframe,f,completed);
    b = mod(i - 1, nframe_1);
    a = floor((i - 1) / nframe_1);
    img(:, :, i) = imread(imgfile{a + 1}, 'Index', b + 1, 'Info', info{a + 1});
end
delete(f)
if breakflag
    img=0;
end
end