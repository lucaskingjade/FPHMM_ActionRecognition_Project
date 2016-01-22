function [ crossValAccuracy ] = cross_val_Accuracy( LabelCell )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
K = size(LabelCell,1);


numActivity = size(LabelCell{1,1},1);
numEmotion = size(LabelCell{1,1},2);
crossValAccuracy = zeros(numActivity,numEmotion+1);
RightSeqNumber =0;
AllSeqNumber = 0;

for indAct = 1:numActivity
    totalrightNum =0;
    totalSeqNum =0;
    for indEm = 1:numEmotion
        rightNum = 0;
        seqNum = 0;
        for indFold = 1:K
            prdtLabelCell = LabelCell{indFold,1};
            indexPrdtLabel = [prdtLabelCell{indAct,indEm}{:,2}]
            indexTrueLabel = [prdtLabelCell{indAct,indEm}{:,4}]
            tmp =  (indexPrdtLabel==indexTrueLabel);
            rightNum = rightNum + sum(tmp);
            disp('wq');
            seqNum =seqNum + size(indexPrdtLabel,2)
        end%K
        totalrightNum = totalrightNum+rightNum
        totalSeqNum = totalSeqNum + seqNum
        crossValAccuracy(indAct,indEm) = rightNum/seqNum
    end%indEm
    
    RightSeqNumber = RightSeqNumber + totalrightNum
    AllSeqNumber = AllSeqNumber + totalSeqNum
    crossValAccuracy(indAct,indEm+1) = totalrightNum/totalSeqNum
end%indAct
crossValAccuracy(1,numEmotion+2) = RightSeqNumber/AllSeqNumber

end%Function

