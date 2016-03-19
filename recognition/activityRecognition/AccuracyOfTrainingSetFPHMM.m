%% TESTING%%%%%%%%%%%%%%
Accuracy_TrainingSet_FPHMM_knownEm = cell(K,1);
FPHMM_TrainingSet_LABEL_CELL = cell(K,1);
disp('Begin to test the accuracy of training set, FPHMM under the case where Emotion information is known....');
%test FPHMM with known emotion
for indFold = 1:K

tmptrainingset = K_TrainingSet{indFold,1};    
FPHMMCell = K_CV_FPHMMCell{indFold,1};
prdtLabelCell_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.

parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        numFl = size(tmptrainingset{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,5);
        for indFl = 1:numFl
            emotionInd = indEm;
            [x,y,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(tmptrainingset{indAct,indEm}{indFl,1},FPHMMCell,emotionInd,...
                emotionCell,activityCell);
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,1} = prdtLabel;
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,2} = prdLabelInd;
            trueLabel = activityCell{1,indAct};
            trueLabelInd = indAct;
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,3} = trueLabel;
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,4} = trueLabelInd;
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,5} = maxLoglik;
        end
    end
end

%% compute accuracy of activity classification 
FPHMM_TrainingSet_LABEL_CELL{indFold,1} = prdtLabelCell_FPHMM;
Accuracy_TrainingSet_FPHMM_knownEm{indFold,1} = computeAccuracy(prdtLabelCell_FPHMM);



end

%%compute accuracy of all activity
% act = [1 2];
CV_Accuracy_TrainingSet_FPHMM_knownEm = cross_val_Accuracy(FPHMM_TrainingSet_LABEL_CELL);
[CV_Variance_TrainingSet_FPHMM_knownEm, accuracy_TrainingSet_FPHMM_knownEm] = cross_val_Variance(FPHMM_TrainingSet_LABEL_CELL);
% CV_Accuracy_FPHMM_knownEm_SW_WH = compareTwoActivity(FPHMM_LABEL_KNOW_EM_CELL,act);
%% compare Simple Walk and Walk with smth in the Hands
%% compute variance of K fold %%

testSetActError =1- CV_Accuracy_FPHMM_knownEm(1,numEmotion+2);
trainingsetActError = 1- CV_Accuracy_TrainingSet_FPHMM_knownEm(1,numEmotion+2);
disp('Congra!Finish!');
