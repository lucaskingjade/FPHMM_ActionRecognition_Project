
%% compute accuracy of Emotion recognition on training set
FPHMM_TRAIN_SET_EMOTION_LABEL_CELL = cell(K,1);
disp('Begin to test the Emotion Recognition Accuracy of FPHMM');

%test FPHMM's ability of emotion recognition
Accuracy_of_TrainSet_Emotion_FPHMM = cell(K,1);
for indFold = 1:K
FPHMMCell = K_CV_FPHMMCell{indFold,1};
trainingSet = K_TrainingSet{indFold,1};

prdtEmotionLabel_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
parfor indAct = 1:numActivity
%     emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
%      emotionCell = {'Anger','Shame'};

    for indEm = 1:numEmotion
        numFl = size(trainingSet{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,9);
        for indFl = 1:numFl
            emotionInd = 0;
            [prdtEmLabel,prdtEmInd,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(trainingSet{indAct,indEm}{indFl,1},FPHMMCell(indAct,1),emotionInd,...
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
FPHMM_TRAIN_SET_EMOTION_LABEL_CELL{indFold,1} = prdtEmotionLabel_FPHMM;
Accuracy_of_TrainSet_Emotion_FPHMM{indFold,1} = computeAccuracy(prdtEmotionLabel_FPHMM);
end

CV_Accuracy_TrainSet_Emotion_FPHMM = cross_val_Accuracy(FPHMM_TRAIN_SET_EMOTION_LABEL_CELL);

[CV_Variance_TrainSet_Emotion_FPHMM, accuracy_TrainSet_Emotion_FPHMM] = cross_val_Variance(FPHMM_TRAIN_SET_EMOTION_LABEL_CELL);

%% compute variance of K fold %%
disp('compute variance of EMOTION accuracy of K folds...')
disp('Congra!Finish!');
testEmotionErrorRate =1- CV_Accuracy_Emotion_FPHMM(1,numEmotion+2);
trainingEmotionErrorRate = 1- CV_Accuracy_TrainSet_Emotion_FPHMM(1,numEmotion+2);

% %save all the test and training set error into a 
% save('1Act_8Em_4Actors_2thetadim_RandInit_UnNormalised_25+35FPHMM_2016_2_1_9_10.mat','testErrorRate','trainingErrorRate','-append');
% plot(4,testErrorRate,'ro');
% hold on
% plot(4,trainingErrorRate,'b*');
% axis([0,9,0,1]);
% xlabel('dim of theta');
% ylabel('emotion recognition error rate');
% legend('test error','training error');
