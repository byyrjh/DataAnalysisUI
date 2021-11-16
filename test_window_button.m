function test_window_button (hObj,event,mainfigure)
test=mainfigure.guihandles;
mainfigure.guihandles=test_slideradd(test,mainfigure);
paraset=findobj('Tag','Inforeg');
close(paraset)
end
