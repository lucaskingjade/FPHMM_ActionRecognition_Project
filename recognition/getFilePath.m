function [ filePath,fileNamesList] = getFilePath( actionStyle,emotion,userName)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
dataSetRoot = getenv('Emily_Dataset');
dataSetPath = strcat(dataSetRoot,'Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/'); 
numUsers = size(userName,2);
filePath = [];
fileNamesList =[];
for i = 1:numUsers
    tmpfilePath = strcat(dataSetPath,actionStyle,'/',emotion,'/',userName{1,i},'/');
    tmpfileNamesList = dir(fullfile(tmpfilePath,'*AngleAxis*.mat'))
    filePathSt = struct('filePath', tmpfilePath);
    filePath = [filePath;repmat(filePathSt,size(tmpfileNamesList,1),1)];
    fileNamesList = [fileNamesList;tmpfileNamesList];
    
end
filePath
fileNamesList
end

