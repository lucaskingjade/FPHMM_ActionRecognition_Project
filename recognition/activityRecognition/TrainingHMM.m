%% Training HMM
path0 = '/Users/qiwang/Documents/matlab projects/';
addpath(genpath(strcat(path0,'fullyParameterizedHMM\Project\recognition\activityRecognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001')));
load('dataSet_001_TrainingTest.mat')

indFold = 1;
K_CV_HMMCell = cell(K,1);
for indFold = 1:K
fprintf('IndFolde =%d',indFold);
%%prepare training set and testing set%%
% trainingSet = cell(numActivity,numEmotion);
% testingSet = cell(numActivity,numEmotion);
% parfor indAct = 1:numActivity
%     for indEm = 1:numEmotion
%         currentFold = KFolders{indAct,indEm};
%         indTraining = currentFold.training(indFold);
% %         indTesting = currentFold.test(indFold);
%         trainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
% %         testingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
%     end
% end
trainingSet = K_TrainingSet{indFold,1};
%%training conventional HMM for each activity and emotion pair%%
numStates = 20;%8!!!!!!
numMix = 1;
max_iter = 5;%!!!!!!!!!!!!!!!!!!!
HMMCell = cell(numActivity,numEmotion);

parfor indAct =1:numActivity
    for indEm = 1:numEmotion
        HMMCell{indAct,indEm} = cell(6,1);
        [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
            trainingConventionHMM(trainingSet{indAct,indEm},numStates,numMix,max_iter,left2rightHMMtopology);
        HMMCell{indAct,indEm}{1,1} = LL;
        HMMCell{indAct,indEm}{2,1} = prior1;
        HMMCell{indAct,indEm}{3,1} = transmat1;
        HMMCell{indAct,indEm}{4,1} = mu1;
        HMMCell{indAct,indEm}{5,1} = Sigma1;
        HMMCell{indAct,indEm}{6,1} = mixmat1;
    end   

    % [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(testData, prior1, transmat1, mu1, Sigma1, mixmat1);
end

%%save all data here

K_CV_HMMCell{indFold,1} = HMMCell;

end

TestHMM
%print accuracy
disp('HMM');
fprintf('%.2f%%\n',CV_Accuracy_HMM_knownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_HMM_knownEm(1,1)*100);
fprintf('%.2f%%\n',CV_Accuracy_HMM_unknownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_HMM_unknownEm(1,1)*100);

fprintf('%d iteration HMM',max_iter);
disp('save all variables....')
save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001/');
save_file_name = strcat(save_path,'data001_LearnThetas_',num2str(numActivity),'Act_',num2str(numEmotion),'Em_',num2str(numStates),'St_',num2str(K),'CV_',num2str(max_iter),'HMM_Classifier_AllVariables.mat');
save(save_file_name);
disp('Finish saving!')
disp('Dont forget to record the result into Numbers')

