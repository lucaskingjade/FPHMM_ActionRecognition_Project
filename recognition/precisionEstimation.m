function [ precisionOneEm,totalPrecision ] = precisionEstimation( labelCell,testingSet )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numEmotion = size(labelCell,1);
if numEmotion ~= size(testingSet,1)
    disp('error in function precisionEstimation at line 6!!!!!!!!!!')
end
numCorrectLb = zeros(numEmotion,1);
NumSeq = zeros(numEmotion,1);
precisionOneEm = zeros(numEmotion,1);
for i = 1:numEmotion
    sequenceNum = size(labelCell{i,1},1);
    numCorrectLb(i,1) = 0;
    for j = 1:sequenceNum
        if strcmp(labelCell{i,1}{j,1}, testingSet{i,1}{j,2})
            numCorrectLb(i,1) = numCorrectLb(i,1)+1;
        end
        NumSeq(i,1) =  NumSeq(i,1) + 1;
    end
    precisionOneEm(i,1) = numCorrectLb(i,1)/NumSeq(i,1);
    
end
totalPrecision = sum(numCorrectLb)/sum(NumSeq);

end

