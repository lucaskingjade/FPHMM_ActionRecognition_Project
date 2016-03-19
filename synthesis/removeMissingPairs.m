function [ DataCell,MissingDataCell ] = removeMissingPairs( allDataCell,emotionCell,activityCell,MissingPairs )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% numActivity = size(allDataCell,1);
% numEmotion = size(allDataCell,2);
%sparse MissingPairs, get the index of the missed Pairs in allDataCell;
numRow = size(MissingPairs,1);
numCol = size(MissingPairs,2);
numEmotion = size(emotionCell,2);
numActivity = size(activityCell,2);
if numCol ~=2
    disp('MissingPairs isnt correct!!/n');
end
MissingDataCell = cell(numActivity,numEmotion);
MissingDataCell =repmat({nan},size(MissingDataCell));
for i = 1:numRow
    indexEm = strcmp(MissingPairs{i,1},emotionCell);
    indexAct = strcmp(MissingPairs{i,2},activityCell);
    MissingDataCell{indexAct,indexEm} =  allDataCell{indexAct,indexEm};
    allDataCell{indexAct,indexEm} = nan;
end
DataCell = allDataCell;
end

