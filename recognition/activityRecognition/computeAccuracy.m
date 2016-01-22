function [ accuracy ] = computeAccuracy( prdtLabelCell )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
numActivity = size(prdtLabelCell,1);
numEmotion = size(prdtLabelCell,2);
accuracy = zeros(numActivity,numEmotion+1);

for indAct = 1:numActivity
    totalrightNum =0;
    totalSeqNum =0;
    for indEm = 1:numEmotion
        indexPrdtLabel = [prdtLabelCell{indAct,indEm}{:,2}]
        indexTrueLabel = [prdtLabelCell{indAct,indEm}{:,4}]
        tmp =  (indexPrdtLabel==indexTrueLabel);
        rightNum = sum(tmp);
        totalrightNum = totalrightNum+rightNum;
        seqNum = size(indexPrdtLabel,2);
        totalSeqNum = totalSeqNum + seqNum;
        accuracy(indAct,indEm) = rightNum/seqNum;
    end
    accuracy(indAct,indEm+1) = totalrightNum/totalSeqNum;
end




end

