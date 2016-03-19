function [ prdtLabelCell_HMM ] = ActivityRecognition_HMM_Synthesis( DataCell,HMMCell,activityCell,trueLabelInd,Marker)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin ==4
Marker =0;
end
numFl = size(DataCell,1);
prdtLabelCell_HMM = cell(numFl,5);
emotionInd =0;
for indFl = 1:numFl
if Marker==1
	[prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_HMM(DataCell{indFl,1},HMMCell,emotionInd,activityCell);
else
    [ prdtLabel, prdLabelInd,maxLoglik ] = recognitionActivity_HMM_Synthesis( DataCell{indFl,1},HMMCell,activityCell );
end
    prdtLabelCell_HMM{indFl,1} = prdtLabel;
    prdtLabelCell_HMM{indFl,2} = prdLabelInd;
    trueLabel = activityCell{1,trueLabelInd};
    prdtLabelCell_HMM{indFl,3} = trueLabel;
    prdtLabelCell_HMM{indFl,4} = trueLabelInd;
    prdtLabelCell_HMM{indFl,5} = maxLoglik;
end

end

