%% test the accuracy of emotion classification
function [ prdtEmotionLabel_FPHMM ] = EmotionAccuracy_HMM_Synthesis( DataCell,HMMCell,activityCell,emotionCell, trueEmotionInd,IndAct)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
numFl = size(DataCell,1);
prdtEmotionLabel_FPHMM = cell(numFl,5);
for indFl = 1:numFl

    [prdtEmLabel,prdtEmInd,maxLoglik] = recognitionEmotion_HMM_Synthesis(DataCell{indFl,1},HMMCell,IndAct,...
        emotionCell,activityCell);
    
    prdtEmotionLabel_FPHMM{indFl,1} = prdtEmLabel;
    prdtEmotionLabel_FPHMM{indFl,2} = prdtEmInd;
    prdtEmotionLabel_FPHMM{indFl,3} = emotionCell{1,trueEmotionInd};%true emotion label
    prdtEmotionLabel_FPHMM{indFl,4} = trueEmotionInd;
    prdtEmotionLabel_FPHMM{indFl,5} = maxLoglik;

end

end

