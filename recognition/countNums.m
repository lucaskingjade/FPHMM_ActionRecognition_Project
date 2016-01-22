function [ numCorrectLb, NumSeq] = countNums(labelCell,testingSet)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

numEmotion = size(labelCell,1);
if numEmotion ~= size(testingSet,1)
    disp('error in function precisionEstimation at line 6!!!!!!!!!!')
end
numCorrectLb = zeros(1,numEmotion);
NumSeq = zeros(1,numEmotion);
precisionOneEm = zeros(numEmotion,1);
for i = 1:numEmotion
    sequenceNum = size(labelCell{i,1},1);
    numCorrectLb(1,i) = 0;
    for j = 1:sequenceNum
        if strcmp(labelCell{i,1}{j,1}, testingSet{i,1}{j,2})
            numCorrectLb(1,i) = numCorrectLb(1,i)+1;
        end
        NumSeq(1,i) =  NumSeq(1,i) + 1;
    end
%     precisionOneEm(i,1) = numCorrectLb(1,i)/NumSeq(1,i);
    
end
% totalPrecision = sum(numCorrectLb)/sum(NumSeq);

end

