function [ accuracy ] = compute_accuracy_Synthesis( prdtLabelCell )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
numActivity = size(prdtLabelCell,1);
numEmotion = size(prdtLabelCell,2);
totalrightNum =0;
totalSeqNum =0;
for indAct = 1:numActivity
    for indEm = 1:numEmotion
        if ~iscell(prdtLabelCell{indAct,indEm})
            continue;
        end
        indexPrdtLabel = [prdtLabelCell{indAct,indEm}{:,2}];
        indexTrueLabel = [prdtLabelCell{indAct,indEm}{:,4}];
        tmp =  (indexPrdtLabel==indexTrueLabel);
        rightNum = sum(tmp);
        totalrightNum = totalrightNum+rightNum;
        seqNum = size(indexPrdtLabel,2);
        totalSeqNum = totalSeqNum + seqNum;
    end
end
accuracy = totalrightNum/totalSeqNum;


end

