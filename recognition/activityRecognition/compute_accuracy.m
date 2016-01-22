% testingSet = cell(K,1);
%% TESTING%%%%%%%%%%%%%%
Accuracy_HMM_knownEm = cell(K,1);
Accuracy_FPHMM_knownEm = cell(K,1);
Accuracy_HMM_unknownEm = cell(K,1);
Accuracy_FPHMM_unknownEm = cell(K,1);
FPHMM_LABEL_CELL = cell(K,1);
HMM_LABEL_CELL = cell(K,1);
disp('Begin to test HMM and FPHMM under the case where Emotion information is known....');
K_TestingSet = cell(K,1);
for indFold =1:K
    tmpTestingSet = cell(numActivity,numEmotion);
    parfor indAct = 1:numActivity
        for indEm = 1:numEmotion
            currentFold = KFolders{indAct,indEm};
            indTesting = currentFold.test(indFold);
            tmpTestingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
        end
    end
    K_TestingSet{indFold,1} = tmpTestingSet;
end
%% test HMM

% test HMM with known emotion
for indFold = 1:K
%testing HMM performance,given emotion information %%
%prepare training set and testing set%%
testingSet = K_TestingSet{indFold,1};

% numTestSize = size(testingSet{indFold,1},1);
prdtLabelCell_HMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
HMMCell = K_CV_HMMCell{indFold,1};
parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_HMM{indAct,indEm} = cell(numFl,5);
        for indFl = 1:numFl
            emotionInd = indEm;
            [prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_HMM(testingSet{indAct,indEm}{indFl,1},HMMCell,emotionInd);
            prdtLabelCell_HMM{indAct,indEm}{indFl,1} = prdtLabel;
            prdtLabelCell_HMM{indAct,indEm}{indFl,2} = prdLabelInd;
            trueLabel = activityCell{1,indAct};
            trueLabelInd = indAct;
            prdtLabelCell_HMM{indAct,indEm}{indFl,3} = trueLabel;
            prdtLabelCell_HMM{indAct,indEm}{indFl,4} = trueLabelInd;
            prdtLabelCell_HMM{indAct,indEm}{indFl,5} = maxLoglik;
        end
    end
end

%% compute accuracy of activity classification %%
HMM_LABEL_CELL{indFold,1} = prdtLabelCell_HMM;
Accuracy_HMM_knownEm{indFold,1} = computeAccuracy(prdtLabelCell_HMM);
end
HMM_LABEL_KNOW_EM_CELL = HMM_LABEL_CELL;
act = [1 2];
CV_Accuracy_HMM_knownEm = cross_val_Accuracy(HMM_LABEL_KNOW_EM_CELL);
CV_Accuracy_HMM_knownEm_SW_WH = compareTwoActivity(HMM_LABEL_KNOW_EM_CELL,act);
[CV_Variance_HMM_knownEm, accuracy_HMM_knownEm]= cross_val_Variance(HMM_LABEL_KNOW_EM_CELL);

%test HMM with unknown emotion
for indFold = 1:K
%testing HMM performance,given emotion information %%
% numTestSize = size(testingSet{indFold,1},1);
testingSet = K_TestingSet{indFold,1};

prdtLabelCell_HMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.
HMMCell = K_CV_HMMCell{indFold,1};
parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_HMM{indAct,indEm} = cell(numFl,5);
        for indFl = 1:numFl
            emotionInd = 0;
            [prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_HMM(testingSet{indAct,indEm}{indFl,1},HMMCell,emotionInd);
            prdtLabelCell_HMM{indAct,indEm}{indFl,1} = prdtLabel;
            prdtLabelCell_HMM{indAct,indEm}{indFl,2} = prdLabelInd;
            trueLabel = activityCell{1,indAct};
            trueLabelInd = indAct;
            prdtLabelCell_HMM{indAct,indEm}{indFl,3} = trueLabel;
            prdtLabelCell_HMM{indAct,indEm}{indFl,4} = trueLabelInd;
            prdtLabelCell_HMM{indAct,indEm}{indFl,5} = maxLoglik;
        end
    end
end

%% compute accuracy of activity classification %%
HMM_LABEL_CELL{indFold,1} = prdtLabelCell_HMM;
Accuracy_HMM_unknownEm{indFold,1} = computeAccuracy(prdtLabelCell_HMM);
end%K
HMM_LABEL_UNKNOW_EM_CELL = HMM_LABEL_CELL;
CV_Accuracy_HMM_unknownEm = cross_val_Accuracy(HMM_LABEL_UNKNOW_EM_CELL);
[CV_Variance_HMM_unknownEm, accuracy_HMM_unknownEm] = cross_val_Variance(HMM_LABEL_UNKNOW_EM_CELL);
CV_Accuracy_HMM_unknownEm_SW_WH = compareTwoActivity(HMM_LABEL_UNKNOW_EM_CELL,act);



%% testing FPHMM performance %%

%test FPHMM with known emotion
for indFold = 1:K

testingSet = K_TestingSet{indFold,1};    
FPHMMCell = K_CV_FPHMMCell{indFold,1};
prdtLabelCell_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.

parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,5);
        for indFl = 1:numFl
            emotionInd = indEm;
            [prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(testingSet{indAct,indEm}{indFl,1},FPHMMCell,emotionInd);
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
FPHMM_LABEL_CELL{indFold,1} = prdtLabelCell_FPHMM;
Accuracy_FPHMM_knownEm{indFold,1} = computeAccuracy(prdtLabelCell_FPHMM);



end
FPHMM_LABEL_KNOW_EM_CELL = FPHMM_LABEL_CELL;
%% compute accuracy of all activity
CV_Accuracy_FPHMM_knownEm = cross_val_Accuracy(FPHMM_LABEL_KNOW_EM_CELL);
[CV_Variance_FPHMM_knownEm, accuracy_FPHMM_knownEm] = cross_val_Variance(FPHMM_LABEL_KNOW_EM_CELL);
CV_Accuracy_FPHMM_knownEm_SW_WH = compareTwoActivity(FPHMM_LABEL_KNOW_EM_CELL,act);
%% compare Simple Walk and Walk with smth in the Hands



disp('Finish the experiment where emotion is known.');


disp('Begin to test HMM and FPHMM under the case where Emotion information is unknown....');
fprintf('waiting...\n');

%test FPHMM with unknown emotion

for indFold = 1:K
FPHMMCell = K_CV_FPHMMCell{indFold,1};
testingSet = K_TestingSet{indFold,1};

prdtLabelCell_FPHMM = cell(numActivity,numEmotion); %inferred emotion label for each test sequence.

parfor indAct = 1:numActivity
    
    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,5);
        for indFl = 1:numFl
            emotionInd = 0;
            [prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(testingSet{indAct,indEm}{indFl,1},FPHMMCell,emotionInd);
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
FPHMM_LABEL_CELL{indFold,1} = prdtLabelCell_FPHMM;
Accuracy_FPHMM_unknownEm{indFold,1} = computeAccuracy(prdtLabelCell_FPHMM);



end

FPHMM_LABEL_UNKNOW_EM_CELL = FPHMM_LABEL_CELL;

CV_Accuracy_FPHMM_unknownEm = cross_val_Accuracy(FPHMM_LABEL_UNKNOW_EM_CELL);
CV_Accuracy_FPHMM_unknownEm_SW_WH = compareTwoActivity(FPHMM_LABEL_UNKNOW_EM_CELL,act);
[CV_Variance_FPHMM_unknownEm, accuracy_FPHMM_unknownEm] = cross_val_Variance(FPHMM_LABEL_UNKNOW_EM_CELL);

%% compute variance of K fold %%
disp('compute variance of accuracy of K folds...')







disp('Congra!Finish!');
printaccuracy
