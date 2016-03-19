function [ prdtEmotionLabel_FPHMM ] = EmotionRecognition_Synthesis( DataCell,FPHMMCell,activityCell,emotionCell, trueEmotionInd)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
numFl = size(DataCell,1);
prdtEmotionLabel_FPHMM = cell(numFl,9);
for indFl = 1:numFl
    emotionInd = 0;
    [prdtEmLabel,prdtEmInd,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(DataCell{indFl,1},FPHMMCell,emotionInd,...
        emotionCell,activityCell);
    prdtEmotionLabel_FPHMM{indFl,1} = prdtEmLabel;
    prdtEmotionLabel_FPHMM{indFl,2} = prdtEmInd;
    prdtEmotionLabel_FPHMM{indFl,3} = emotionCell{1,trueEmotionInd};%true emotion label
    prdtEmotionLabel_FPHMM{indFl,4} = trueEmotionInd;
    prdtEmotionLabel_FPHMM{indFl,5} = maxLoglik;

end

end

