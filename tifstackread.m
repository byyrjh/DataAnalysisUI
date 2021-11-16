        function tifstackread(hObject,src,event)
            path = 'Y:\hao';
            datapath = [path filesep];
            [imgfile, imgpath] = uigetfile_rui(datapath, '*.tif', 'please simulation image');
            img = tiff_reader_rui(imgfile);
            [x y z]=size(img);
            data=struct('col',x,'row',y,'slice',z,'threeDdata',img);
            hObject.UserData = data;
%             axes(obj.guihandles.xyshow);
%             imshow(img(:,:,1));
        end