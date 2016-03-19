%% testing FPHMM performance %%
%% test FPHMM performance
%% TESTING%%%%%%%%%%%%%%
disp('Begin to test HMM and FPHMM under the case where Emotion information is known....');

   
prdtLabel_FPHMM_TestSet_knownEm = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
prdtLabel_FPHMM_TestSet_unknownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_ValSet_knownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_ValSet_unknownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_TrainSet_knownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_TrainSet_unknownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_MissingSet_knownEm = cell(numActivity,numEmotion);
prdtLabel_FPHMM_MissingSet_unknownEm = cell(numActivity,numEmotion);
parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        if iscell(TestDataSet{indAct,indEm})
            prdtLabel_FPHMM_TestSet_knownEm{indAct,indEm} = ActivityRecognition_Synthesis( TestDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,1);
            prdtLabel_FPHMM_TestSet_unknownEm{indAct,indEm} = ActivityRecognition_Synthesis( TestDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,0);
            prdtLabel_FPHMM_ValSet_knownEm{indAct,indEm} = ActivityRecognition_Synthesis( ValDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,1);
            prdtLabel_FPHMM_ValSet_unknownEm{indAct,indEm} = ActivityRecognition_Synthesis( ValDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,0);
            prdtLabel_FPHMM_TrainSet_knownEm{indAct,indEm} = ActivityRecognition_Synthesis( TrainDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,1);
            prdtLabel_FPHMM_TrainSet_unknownEm{indAct,indEm} = ActivityRecognition_Synthesis( TrainDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,0);
        end
        if iscell(MissingDataSet{indAct,indEm})
            prdtLabel_FPHMM_MissingSet_knownEm{indAct,indEm} = ActivityRecognition_Synthesis( MissingDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,1);
            prdtLabel_FPHMM_MissingSet_unknownEm{indAct,indEm} = ActivityRecognition_Synthesis( MissingDataSet{indAct,indEm},FPHMMCell,activityCell,emotionCell,indAct,indEm,0);
        end
    end
end

accuracy_FPHMM_TestSet_knownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_TestSet_knownEm);
accuracy_FPHMM_TestSet_unknownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_TestSet_unknownEm);
accuracy_FPHMM_ValSet_knownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_ValSet_knownEm);
accuracy_FPHMM_ValSet_unknownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_ValSet_unknownEm);
accuracy_FPHMM_TrainSet_knownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_TrainSet_knownEm);
accuracy_FPHMM_TrainSet_unknownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_TrainSet_unknownEm);
accuracy_FPHMM_MissingSet_knownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_MissingSet_knownEm);
accuracy_FPHMM_MissingSet_unknownEm = compute_accuracy_Synthesis(prdtLabel_FPHMM_MissingSet_unknownEm);



