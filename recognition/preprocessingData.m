function [ allDataCell ,allData ] = preprocessingData( actionStyle,emotionCell,userName )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
numEmotion = size(emotionCell,2);
allDataCell = cell(numEmotion,1);
allData = [];
totalTime = 0;
for ii = 1:numEmotion
    emotion = emotionCell{1,ii};
    [filePath,fileNamesList] = getFilePath(actionStyle,emotion,userName)
    numFiles = size(fileNamesList,1);
    data = cell(numFiles,2);
    fileNamesList
    for i = 1:numFiles
        currentFileName = fileNamesList(i,1).name
        currentEmotion = getEmotionType(currentFileName)
        if(currentEmotion ~= emotion)
            disp('file name isnt correct!!!!!!!!!!');
        end
        
        [anglesData,origin,O,t] = importMotionData(strcat(filePath(i,1).filePath,currentFileName)); 
        totalTime = totalTime +t;
        data{i,1} = anglesData;
        data{i,2} = currentEmotion;
        size(data{i,1})
        size(allData)
        i
        allData = [allData,data{i,1}];

    end
    allDataCell{ii,1} = data;
end

if(size(allData,2)~= totalTime)
    disp('allData dim dismatch totalTime!!!!!!!');
end



%% ===PCA for all data===%%
if 1
    dimPCA = 4;
    O=dimPCA;
    [eigenValue,eigenMatrix]=pca(allData',dimPCA);
    display(eigenValue);
    fprintf('eigenValue size is %d',size(eigenValue));
    fprintf('reducedData size is %d',size(eigenMatrix));
    allData = eigenMatrix'*allData;
    display(size(allData));
    
    %replace elements in  with those in allDataCell
    front = 0;
    back = 0;
    for ii = 1:numEmotion
        numFiles = size(allDataCell{ii,1},1)
        for i = 1:numFiles
            front = back +1;
            back = front + size(allDataCell{ii,1}{i,1},2)-1;
            allDataCell{ii,1}{i,1} = allData(:,front:back);
        end
    end
end
end