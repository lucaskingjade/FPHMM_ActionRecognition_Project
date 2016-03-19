function [ filePath,fileNamesList] = getFilePath_Bvh( actionStyle,emotion,userName)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Bvh_Files_AllSegmentData/AllAction_segments/PerAction/'; 
numUsers = size(userName,2);
filePath = [];
fileNamesList =[];
for i = 1:numUsers
    tmpfilePath = strcat(dataSetPath,actionStyle,'/',emotion,'/',userName{1,i},'/');
    tmpfileNamesList = dir(fullfile(tmpfilePath,'*.bvh'));
    filePathSt = struct('filePath', tmpfilePath);
    filePath = [filePath;repmat(filePathSt,size(tmpfileNamesList,1),1)];
    fileNamesList = [fileNamesList;tmpfileNamesList];

end
disp('dfsa')
filePath
fileNamesList
end

