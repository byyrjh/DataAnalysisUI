%get multi files with output as a cell
%--Rui
function [file, filepath] = uigetfile_rui(extension, info)
[filename, filepath] = uigetfile(extension, info, ...
    'MultiSelect', 'on');
try
    % select no file, the filename type is double
    if class(filename) == 'double'
        file = [cdir];
    end
catch
    %multiple files selected
    if class(filename) =='cell'
        %go through all files
        for i = 1 : length(filename)
            %put together filenames for imread function
            file{i} = [filepath filename{i}];
        end
        %single file selected
    elseif class(filename) == 'char'
        %put together filename for imread function
        file = [filepath filename];
    end
end
if class(file) == 'char'
    %copy string variable
    imgfiletmp = file;
    %clear string variable
    clear file;
    %convert to cell array
    file{1} = imgfiletmp;
end
file = file';
end