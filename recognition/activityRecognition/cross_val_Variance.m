function [ crossValVariance,accuracyEachFold ] = cross_val_Variance( LabelCell)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
K = size(LabelCell,1);

numActivity = size(LabelCell{1,1},1);
numEmotion = size(LabelCell{1,1},2);

accuracyEachFold = zeros(K,1);

for indFold = 1:K
    rightNum =0;
    seqNum = 0; 
    prdtLabelCell = LabelCell{indFold,1};
    for indAct = 1:numActivity
        for indEm = 1:numEmotion
            indexPrdtLabel = [prdtLabelCell{indAct,indEm}{:,2}];
            indexTrueLabel = [prdtLabelCell{indAct,indEm}{:,4}];
            tmp =  (indexPrdtLabel==indexTrueLabel);
            rightNum = rightNum + sum(tmp)
            seqNum =seqNum + size(indexPrdtLabel,2)
        end
    end
    disp('a new fold');
    accuracyEachFold(indFold,1) = rightNum/seqNum;    
end

crossValVariance = sqrt(var(accuracyEachFold));

end

