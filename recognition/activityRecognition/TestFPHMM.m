%% testing FPHMM performance %%
% testingSet = cell(K,1);
%% TESTING%%%%%%%%%%%%%%
Accuracy_FPHMM_knownEm = cell(K,1);
Accuracy_FPHMM_unknownEm = cell(K,1);
FPHMM_LABEL_CELL = cell(K,1);
disp('Begin to test HMM and FPHMM under the case where Emotion information is known....');
% K_TestingSet = cell(K,1);
% for indFold =1:K
%     tmpTestingSet = cell(numActivity,numEmotion);
%     parfor indAct = 1:numActivity
%         for indEm = 1:numEmotion
%             currentFold = KFolders{indAct,indEm};
%             indTesting = currentFold.test(indFold);
%             tmpTestingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
%         end
%     end
%     K_TestingSet{indFold,1} = tmpTestingSet;
% end

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
            [x,y,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(testingSet{indAct,indEm}{indFl,1},FPHMMCell,emotionInd,...
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
FPHMM_LABEL_CELL{indFold,1} = prdtLabelCell_FPHMM;
Accuracy_FPHMM_knownEm{indFold,1} = computeAccuracy(prdtLabelCell_FPHMM);



end
FPHMM_LABEL_KNOW_EM_CELL = FPHMM_LABEL_CELL;
%% compute accuracy of all activity
act = [1 2];
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
%     emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
%      emotionCell = {'Anger','Shame'};

    for indEm = 1:numEmotion
        numFl = size(testingSet{indAct,indEm},1);
        prdtLabelCell_FPHMM{indAct,indEm} = cell(numFl,9);
        for indFl = 1:numFl
            emotionInd = 0;
            [prdtEmLabel,prdtEmInd,prdtLabel, prdLabelInd, maxLoglik] = recognitionActivity_FPHMM(testingSet{indAct,indEm}{indFl,1},FPHMMCell,emotionInd,...
                emotionCell,activityCell);
            %add the following lins for compute the emotion prediction
            %accuracy
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,8} = emotionCell{1,indEm};%true emotion label
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,9} = indEm;%true emotion label
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,6} = prdtEmLabel;
            prdtLabelCell_FPHMM{indAct,indEm}{indFl,7} = prdtEmInd;
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
act = [1 2];
CV_Accuracy_FPHMM_unknownEm = cross_val_Accuracy(FPHMM_LABEL_UNKNOW_EM_CELL);
% CV_Emotion_Recog_Accuracy_unknownEm = cross_val_Accuracy %add a line for computing the emotion classification accuracy.
CV_Accuracy_FPHMM_unknownEm_SW_WH = compareTwoActivity(FPHMM_LABEL_UNKNOW_EM_CELL,act);
[CV_Variance_FPHMM_unknownEm, accuracy_FPHMM_unknownEm] = cross_val_Variance(FPHMM_LABEL_UNKNOW_EM_CELL);

%% compute variance of K fold %%
disp('compute variance of accuracy of K folds...')







disp('Congra!Finish!');
