f=figure(1);
data_table=uitable(f,'ColumnName',{'FHWM_x','FHWM_y','FHWM_z','center intensity'},...
    'Units','normalized','Position',[0.1 0.1 0.8 0.8],'FontSize',10,'ColumnEditable',true);
data_temp=cell(2,4);
data_temp{1,1}=1;
data_temp{1,2}=1;
data_temp{1,3}=1;
data_temp{1,4}=false;
data_temp{2,1}=1;
data_temp{2,2}=1;
data_temp{2,3}=1;
data_temp{2,4}=false;
data_table.Data=data_temp;
set (data_table,'ColumnWidth', {100,100,83,83})

f = figure;
uit = uitable(f);
d = {'Male',52,true;'Male',40,true;'Female',25,false};
uit.Data = d;
uit.Position = [20 20 258 78];
uit.ColumnEditable = true;