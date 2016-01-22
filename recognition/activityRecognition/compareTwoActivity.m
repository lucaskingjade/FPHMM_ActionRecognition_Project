function [ crossValAccuracy ] = compareTwoActivity( LabelCell,act )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
K = size(LabelCell,1);


numActivity = size(act,2);
numEmotion = size(LabelCell{1,1},2);
crossValAccuracy = zeros(numActivity,numEmotion+1);
RightSeqNumber =0;
AllSeqNumber = 0;
act
for indAct = 1:numActivity
    totalrightNum =0;
    totalSeqNum =0;
    for indEm = 1:numEmotion
        rightNum = 0;
        seqNum = 0;
        for indFold = 1:K
            prdtLabelCell = LabelCell{indFold,1};
            indexPrdtLabel = [prdtLabelCell{act(indAct),indEm}{:,2}]
            indexTrueLabel = [prdtLabelCell{act(indAct),indEm}{:,4}]
            tmp =  (indexPrdtLabel==indexTrueLabel);
            rightNum = rightNum + sum(tmp);
            seqNum =seqNum + size(indexPrdtLabel,2);
        end
        totalrightNum = totalrightNum+rightNum;
        totalSeqNum = totalSeqNum + seqNum;
        crossValAccuracy(indAct,indEm) = rightNum/seqNum;
    end
    RightSeqNumber = RightSeqNumber + totalrightNum;
    AllSeqNumber = AllSeqNumber + totalSeqNum;
    crossValAccuracy(indAct,indEm+1) = totalrightNum/totalSeqNum;
end
crossValAccuracy(1,numEmotion+2) = RightSeqNumber/AllSeqNumber;

end

