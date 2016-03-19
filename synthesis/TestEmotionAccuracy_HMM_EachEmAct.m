%% Test HMM

prdtEmotionLabelCell_TestData_HMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
prdtEmotionLabelCell_MissingData_HMM = cell(numActivity,numEmotion);
prdtEmotionLabelCell_ValData_HMM = cell(numActivity,numEmotion);
prdtEmotionLabelCell_TrainData_HMM = cell(numActivity,numEmotion);

parfor indAct = 1:numActivity
    
    for indEm =1:numEmotion
        if iscell(TestDataSet{indAct,indEm})
            prdtEmotionLabelCell_TestData_HMM{indAct,indEm}  = EmotionAccuracy_HMM_Synthesis( TestDataSet{indAct,indEm},HMMCell,activityCell,emotionCell,indEm,indAct);
        end
        if iscell(MissingDataSet{indAct,indEm})
            prdtEmotionLabelCell_MissingData_HMM{indAct,indEm}  = EmotionAccuracy_HMM_Synthesis( MissingDataSet{indAct,indEm},HMMCell,activityCell,emotionCell,indEm,indAct);
        end
        if iscell(ValDataSet{indAct,indEm})
            prdtEmotionLabelCell_ValData_HMM{indAct,indEm}  = EmotionAccuracy_HMM_Synthesis( ValDataSet{indAct,indEm},HMMCell,activityCell,emotionCell,indEm,indAct);
        end
        if iscell(TrainDataSet{indAct,indEm})
            prdtEmotionLabelCell_TrainData_HMM{indAct,indEm}  = EmotionAccuracy_HMM_Synthesis( TrainDataSet{indAct,indEm},HMMCell,activityCell,emotionCell,indEm,indAct);
        end
    end
    
end

%% compute accuracy of activity classification %%
accuracy_Emotion_TestData_HMM = compute_accuracy_Synthesis(prdtEmotionLabelCell_TestData_HMM);
accuracy_Emotion_MissingData_HMM = compute_accuracy_Synthesis(prdtEmotionLabelCell_MissingData_HMM);
accuracy_Emotion_ValData_HMM = compute_accuracy_Synthesis(prdtEmotionLabelCell_ValData_HMM);
accuracy_Emotion_TrainData_HMM = compute_accuracy_Synthesis(prdtEmotionLabelCell_TrainData_HMM);