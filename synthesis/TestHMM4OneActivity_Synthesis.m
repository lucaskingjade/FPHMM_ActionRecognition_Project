%% Test HMM

prdtLabelCell_TestData_HMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
prdtLabelCell_MissingData_HMM = cell(numActivity,numEmotion);
prdtLabelCell_ValData_HMM = cell(numActivity,numEmotion);
prdtLabelCell_TrainData_HMM = cell(numActivity,numEmotion);

parfor indAct = 1:numActivity
    
    for indEm =1:numEmotion
        if iscell(TestDataSet{indAct,indEm})
            prdtLabelCell_TestData_HMM{indAct,indEm}  = ActivityRecognition_HMM_Synthesis( TestDataSet{indAct,indEm},HMMCell,activityCell,indAct);
        end
        if iscell(MissingDataSet{indAct,indEm})
            prdtLabelCell_MissingData_HMM{indAct,indEm}  = ActivityRecognition_HMM_Synthesis( MissingDataSet{indAct,indEm},HMMCell,activityCell,indAct);
        end
        if iscell(ValDataSet{indAct,indEm})
            prdtLabelCell_ValData_HMM{indAct,indEm}  = ActivityRecognition_HMM_Synthesis( ValDataSet{indAct,indEm},HMMCell,activityCell,indAct);
        end
        if iscell(TrainDataSet{indAct,indEm})
            prdtLabelCell_TrainData_HMM{indAct,indEm}  = ActivityRecognition_HMM_Synthesis( TrainDataSet{indAct,indEm},HMMCell,activityCell,indAct);
        end
    end
    
end

%% compute accuracy of activity classification %%
accuracy_TestData_HMM = compute_accuracy_Synthesis(prdtLabelCell_TestData_HMM);
accuracy_MissingData_HMM = compute_accuracy_Synthesis(prdtLabelCell_MissingData_HMM);
accuracy_ValData_HMM = compute_accuracy_Synthesis(prdtLabelCell_ValData_HMM);
accuracy_TrainData_HMM = compute_accuracy_Synthesis(prdtLabelCell_TrainData_HMM);
