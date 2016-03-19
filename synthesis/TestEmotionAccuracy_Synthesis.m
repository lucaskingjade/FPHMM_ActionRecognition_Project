
%% compute accuracy of Emotion recognition on training set
%test FPHMM's ability of emotion recognition
FPHMMCell
prdtEmotionLabel_TestData_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
prdtEmotionLabel_MissingData_FPHMM = cell(numActivity,numEmotion);
prdtEmotionLabel_ValData_FPHMM = cell(numActivity,numEmotion);
prdtEmotionLabel_TrainData_FPHMM = cell(numActivity,numEmotion);

parfor indAct = 1:numActivity
    for indEm = 1:numEmotion
        if iscell(TestDataSet{indAct,indEm})
            prdtEmotionLabel_TestData_FPHMM{indAct,indEm} = EmotionRecognition_Synthesis( TestDataSet{indAct,indEm},FPHMMCell(indAct,1),activityCell(1,indAct),emotionCell, indEm);
            prdtEmotionLabel_ValData_FPHMM{indAct,indEm} = EmotionRecognition_Synthesis( ValDataSet{indAct,indEm},FPHMMCell(indAct,1),activityCell(1,indAct),emotionCell, indEm);
            prdtEmotionLabel_TrainData_FPHMM{indAct,indEm} = EmotionRecognition_Synthesis( TrainDataSet{indAct,indEm},FPHMMCell(indAct,1),activityCell(1,indAct),emotionCell, indEm);
        end
        if iscell(MissingDataSet{indAct,indEm})
            prdtEmotionLabel_MissingData_FPHMM{indAct,indEm} = EmotionRecognition_Synthesis( MissingDataSet{indAct,indEm},FPHMMCell(indAct,1),activityCell(1,indAct),emotionCell, indEm);
        end
    end
end

accuracyEmotion_FPHMM_TestSet_knownEm = compute_accuracy_Synthesis(prdtEmotionLabel_TestData_FPHMM);
accuracyEmotion_FPHMM_MissingSet_knownEm = compute_accuracy_Synthesis(prdtEmotionLabel_MissingData_FPHMM);
accuracyEmotion_FPHMM_ValSet_knownEm = compute_accuracy_Synthesis(prdtEmotionLabel_ValData_FPHMM);
accuracyEmotion_FPHMM_TrainSet_knownEm = compute_accuracy_Synthesis(prdtEmotionLabel_TrainData_FPHMM);


