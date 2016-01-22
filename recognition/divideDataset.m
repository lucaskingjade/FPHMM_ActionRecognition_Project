function [ trainingSet,testingSet ] = divideDataset( dataCell,splitProportion )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
numEmotion = size(dataCell,1);
trainingSet = cell(numEmotion,1);
testingSet = cell(numEmotion,1);
for i = 1:numEmotion
    tmpdata = dataCell{i,1};
    numFiles = size(dataCell{i,1},1);
    numTraining = fix(numFiles*splitProportion);
    numTesting = numFiles - numTraining;
    if(numTraining <=0 || numTesting<=0)
        disp('!!!!!!!!!!!!!!!errors: divideDataset.m :11');
    end

    trainingSet{i,1} = tmpdata(1:numTraining,:);
    testingSet{i,1} = tmpdata(numTraining+1:numTraining+numTesting,:);   
    
end


end

