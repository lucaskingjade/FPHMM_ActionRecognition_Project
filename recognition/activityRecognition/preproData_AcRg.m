function [ allDataCell, allData ] = preproData_AcRg( activityCell,emotionCell,Names )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
numAct = length(activityCell);
numEm = length(emotionCell);
numName = length(Names);
allDataCell = cell(numAct, numEm);
allData = [];
totalTime = 0;
%% import all data from different directories %%
for indAct = 1:numAct
    for indEm = 1:numEm
        currentEm = emotionCell{1,indEm};
        currentAc = activityCell{1,indAct};
        [filePathLs,fileNamesLs] = getFilePath(currentAc,currentEm,Names)
        numCurFiles = size(fileNamesLs,1);
        data = cell(numCurFiles,2);
        for indFl = 1:numCurFiles
            currentFileName = fileNamesLs(indFl,1).name;
            currentFilePath = filePathLs(indFl,1).filePath;
            currentEmotion = getEmotionType(currentFileName);
            currentEm
            currentEmotion
            if strcmp(currentEmotion,currentEm)~=1
                disp('!!!!!!!!!!!!file name isnt correct!!!!!in preproData_AcRg.m at 18');                
            end
            
            [anglesData,origin,O,t] = importMotionData(strcat(currentFilePath,currentFileName)); 
            totalTime = totalTime + t;
            data{indFl,1} = anglesData;
            data{indFl,2} = currentEmotion;
            size(data{indFl,1})
            allData = [allData,data{indFl,1}];
            size(allData)
        end
        allDataCell{indAct,indEm} = data;
    end   
end

if (size(allData,2) ~=totalTime)
    disp('!!!!!!!!allData length dismatch totalTime!!!!!!!!!');
end

end

