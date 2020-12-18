function [path, fileName] = SetUpFolder(folder, filename)
%function that sets up a folder within 'folder' to save data to.
%Folder name will be fileName with data appended to beginning. If a folder
%of that name already exists a number will be added to the end

fileName = strcat(date,'_', filename);
filename1 = fileName;
TF = isfolder(strcat(folder,'\', fileName));
counter = 1;
while TF == 1
    fileName = strcat(filename1, '_', string(counter));
    TF = isfolder(strcat(folder,'\', fileName)); 
    counter = counter + 1;
end
S = mkdir(folder ,fileName);
path = strcat(folder,'\',fileName,'\');
end