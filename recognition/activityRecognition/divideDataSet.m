function [ trainingSet,testSet ] = divideDataSet( allDataCell,K)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%split dataset into training and test sets.
if nargin <2
K =10;
end
numActivity = size(allDataCell,1);
numEmotion = size(allDataCell,2);
KFolders = cell(numActivity,numEmotion);
for indAct = 1:numActivity
    for indEm = 1:numEmotion
        if iscell(allDataCell{indAct,indEm})
            KFolders{indAct,indEm} = cvpartition(size(allDataCell{indAct,indEm},1),'KFold',K);
        else
            KFolders{indAct,indEm} = nan;
        end
    end
end


trainingSet = cell(numActivity,numEmotion);
testSet = cell(numActivity,numEmotion);
for indAct = 1:numActivity
    for indEm = 1:numEmotion
        if iscell(allDataCell{indAct,indEm})
            currentFold = KFolders{indAct,indEm};
            indTraining = training(currentFold,1);
            indTesting = test(currentFold,1);        
            trainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
            testSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
        else
            trainingSet{indAct,indEm} = nan;
            testSet{indAct,indEm} = nan;
        end
    end
end

end

