%this file is used for test if thetas learned include information of
%emotions.This will be done by compute the accuracy of emotion recognition,
%when the activity label is given in test data.
%% testing FPHMM performance %%
% testingSet = cell(K,1);
%% TESTING%%%%%%%%%%%%%%
FPHMM_EMOTION_LABEL_CELL = cell(K,1);
disp('Begin to test the Emotion Recognition Accuracy of FPHMM');

%test FPHMM's ability of emotion recognition
Accuracy_of_Emotion_FPHMM = cell(K,1);
for indFold = 1:K
FPHMMCell = K_CV_FPHMMCell{indFold,1};
testingSet = K_TestingSet{indFold,1};

prdtEmotionLabel_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
parfor indAct = 1:numActivity
%     emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
%      emotionCell = {'Anger','Shame'};

    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,9);
        for indFl = 1:numFl
            emotionInd = 0;
            [prdtEmLabel,prdtEmInd,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(testingSet{indAct,indEm}{indFl,1},FPHMMCell(indAct,1),emotionInd,...
                emotionCell,activityCell(1,indAct));
            prdtEmotionLabel_FPHMM{indAct,indEm}{indFl,1} = prdtEmLabel;
            prdtEmotionLabel_FPHMM{indAct,indEm}{indFl,2} = prdtEmInd;
            prdtEmotionLabel_FPHMM{indAct,indEm}{indFl,3} = emotionCell{1,indEm};%true emotion label
            prdtEmotionLabel_FPHMM{indAct,indEm}{indFl,4} = indEm;
            prdtEmotionLabel_FPHMM{indAct,indEm}{indFl,5} = maxLoglik;

        end
    end
end

%% compute accuracy of activity classification 
FPHMM_EMOTION_LABEL_CELL{indFold,1} = prdtEmotionLabel_FPHMM;
Accuracy_of_Emotion_FPHMM{indFold,1} = computeAccuracy(prdtEmotionLabel_FPHMM);
end

act = [1 2];
CV_Accuracy_Emotion_FPHMM = cross_val_Accuracy(FPHMM_EMOTION_LABEL_CELL);

[CV_Variance_Emotion_FPHMM, accuracy_Emotion_FPHMM] = cross_val_Variance(FPHMM_EMOTION_LABEL_CELL);

%% compute variance of K fold %%
disp('compute variance of EMOTION accuracy of K folds...')
disp('Congra!Finish!');
