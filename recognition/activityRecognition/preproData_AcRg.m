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
        currentAct = activityCell{1,indAct};
        [filePathLs,fileNamesLs] = getFilePath(currentAct,currentEm,Names)
        numCurFiles = size(fileNamesLs,1);
        data = cell(numCurFiles,3);
        randomIndex = randperm(numCurFiles);%generate random index
        for indFl = 1:numCurFiles
            currentFileName = fileNamesLs(randomIndex(indFl),1).name
            currentFilePath = filePathLs(randomIndex(indFl),1).filePath
            currentEmotion = getEmotionType(currentFileName);
            currentEm
            currentEmotion
            if strcmp(currentEmotion,currentEm)~=1
                disp('!!!!!!!!!!!!file name isnt correct!!!!!in preproData_AcRg.m at 18');                
            end
            
            [anglesData,origin,O,t] = importMotionData(strcat(currentFilePath,currentFileName));
            if size(anglesData,1)> size(anglesData,2)
                disp('!!!!!!!!!!!anglesData row number is larger that col number!!!!!!!');
                
            end
            totalTime = totalTime + t;
            %find all zero elements in angelesData,and replace them!
            anglesData = replaceZeroElement(anglesData,currentFileName);
            data{indFl,1} = anglesData;
            data{indFl,2} = currentEmotion;
            data{indFl,3} = currentAct;
            size(data{indFl,1})
            allData = [allData,data{indFl,1}];
            size(allData)
            anglesData = [];
        end
        allDataCell{indAct,indEm} = data;
    end   
end

if (size(allData,2) ~=totalTime)
    disp('!!!!!!!!allData length dismatch totalTime!!!!!!!!!');
end

end

