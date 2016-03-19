function [ prdtLabelCell_FPHMM ] = ActivityRecognition_Synthesis( DataCell,FPHMMCell,activityCell,emotionCell,trueLabelInd,indEm,knownEm )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
numFl = size(DataCell,1);
prdtLabelCell_FPHMM = cell(numFl,5);
for indFl = 1:numFl
    if knownEm ==1
        emotionInd = indEm;
    else
        emotionInd = 0;    
    end
    
    [x,y,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(DataCell{indFl,1},FPHMMCell,emotionInd,...
        emotionCell,activityCell);
    prdtLabelCell_FPHMM{indFl,1} = prdtLabel;
    prdtLabelCell_FPHMM{indFl,2} = prdLabelInd;
    trueLabel = activityCell{1,trueLabelInd};
    prdtLabelCell_FPHMM{indFl,3} = trueLabel;
    prdtLabelCell_FPHMM{indFl,4} = trueLabelInd;
    prdtLabelCell_FPHMM{indFl,5} = maxLoglik;
end

end

