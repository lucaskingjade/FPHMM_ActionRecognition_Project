function [ DataMatrix ] = flattenDataSample( DataSet )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
numActivity = size(DataSet,1);
numEmotion = size(DataSet,2);
DataMatrix = [];
for indAct = 1:numActivity
    for indEm = 1:numEmotion
        if iscell(DataSet{indAct,indEm})
            numFiles = size(DataSet{indAct,indEm},1)
            for indFl = 1:numFiles
                DataMatrix = [DataMatrix,DataSet{indAct,indEm}{indFl,1}];
            end    
        end
    end

end
end

