function [ outDataCell,outData ] = PCA_GivenEigenMatrix( DataCell, DataMatrix, eigenMatrix )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

tmpDataCell = DataCell;
tmpData = DataMatrix;
numAct = size(tmpDataCell,1);
numEm = size(tmpDataCell,2);
% [eigenValue,eigenMatrix]=pca(tmpData',dim);
% display(eigenValue);
% fprintf('eigenValue size is [%d,%d]\n',size(eigenValue));
% fprintf('eigenMatrix size is [%d,%d]\n',size(eigenMatrix));
tmpData = eigenMatrix'*tmpData;
display(size(tmpData));
outData = tmpData;
%replace elements in  with those in allDataCell
front = 0;
back = 0;
for indAct = 1:numAct
    for indEm = 1:numEm
        if iscell(tmpDataCell{indAct,indEm})
            numFiles = size(tmpDataCell{indAct,indEm},1);
            for indFl = 1:numFiles
                front = back +1;
                back = front + size(tmpDataCell{indAct,indEm}{indFl,1},2)-1;
                outDataCell{indAct,indEm}{indFl,1} = tmpData(:,front:back);
                outDataCell{indAct,indEm}{indFl,2} = tmpDataCell{indAct,indEm}{indFl,2};
                outDataCell{indAct,indEm}{indFl,3} = tmpDataCell{indAct,indEm}{indFl,3};
            end
        else
            outDataCell{indAct,indEm} = nan;
        end
    end
end

end

