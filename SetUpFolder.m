function [path, filename] = SetUpFolder(folder, fileName)
%function that sets up a folder within 'folder' to save data to.
%Folder name will be fileName with data appended to beginning. If a folder
%of that name already exists a number will be added to the end

filename = strcat(date,'_', fileName);
filename1 = filename;
TF = isfolder(strcat(folder,'\', filename));
counter = 1;
while TF == 1
    filename = strcat(filename1, '_', string(counter));
    TF = isfolder(strcat(folder,'\', filename)); 
    counter = counter + 1;
end
S = mkdir(folder ,filename);
path = strcat(folder,'\',filename,'\');
end