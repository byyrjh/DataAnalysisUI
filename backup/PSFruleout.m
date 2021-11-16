function PSFruleout(hObj,event,obj,index)
points_label=obj.Panel_3.FWHMdisp.Data;
point_num=[];
for i=1:size(points_label,1)
    if points_label{i,6}
        point_num=[point_num,i];
    end
end
obj.guihandles.PSFdata.data{index,1}.Manually_sele_idx=point_num;
end