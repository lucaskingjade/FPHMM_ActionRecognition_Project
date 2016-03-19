%read variables from different files and save

numExp=4
accuracyMissingSet_UnknownEm = zeros(numExp,8);
accuracyTestSet_UnknownEm = zeros(numExp,8);
accuracyValSet_UnknownEm = zeros(numExp,8);
accuracyTrainSet_UnknownEm = zeros(numExp,8);

accuracyEmotionMissingSet  = zeros(numExp,8);
accuracyEmotionTestSet = zeros(numExp,8);
accuracyEmotionValSet = zeros(numExp,8);
accuracyEmotionTrainSet = zeros(numExp,8);

for indexp =3:numExp+2

disp('bigen to read \n');
path = strcat('./Experiment00',num2str(indexp),'/Results/');
tmpfileNamesList = dir(strcat(path,'2Act_*_25+35FPHMM*_Smaller.mat'));
numFl = length(tmpfileNamesList)
for indFl =1:numFl
load(strcat(path,tmpfileNamesList(indFl).name),'theta_dim');
    fprintf('dim fo theta is: %d',theta_dim);
    
%     load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_MissingSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_FPHMM_MissingSet_unknownEm');
%     load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TestSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_FPHMM_TestSet_unknownEm');
%     load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_ValSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_FPHMM_ValSet_unknownEm');
%     load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TrainSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_FPHMM_TrainSet_unknownEm');
    accuracyMissingSet_UnknownEm(indexp-2,theta_dim) = accuracy_FPHMM_MissingSet_unknownEm
    accuracyTestSet_UnknownEm(indexp-2,theta_dim) = accuracy_FPHMM_TestSet_unknownEm
    accuracyValSet_UnknownEm(indexp-2,theta_dim) = accuracy_FPHMM_ValSet_unknownEm
    accuracyTrainSet_UnknownEm(indexp-2,theta_dim) = accuracy_FPHMM_TrainSet_unknownEm
    
    %load emotion accuracy
        %Emotion Accuracy
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracyEmotion_FPHMM_MissingSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracyEmotion_FPHMM_TestSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracyEmotion_FPHMM_ValSet_knownEm');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracyEmotion_FPHMM_TrainSet_knownEm');
    
    accuracyEmotionMissingSet(indexp-2,theta_dim)  = accuracyEmotion_FPHMM_MissingSet_knownEm;
    accuracyEmotionTestSet(indexp-2,theta_dim) = accuracyEmotion_FPHMM_TestSet_knownEm;
    accuracyEmotionValSet(indexp-2,theta_dim) = accuracyEmotion_FPHMM_ValSet_knownEm;
    accuracyEmotionTrainSet(indexp-2,theta_dim) = accuracyEmotion_FPHMM_TrainSet_knownEm;
    

end

end

averageAct_Accuracy_FPHMM_MissingSet = mean(accuracyMissingSet_UnknownEm,1);
averageAct_Accuracy_FPHMM_TestSet = mean(accuracyTestSet_UnknownEm,1);
averageAct_Accuracy_FPHMM_ValSet = mean(accuracyValSet_UnknownEm,1);
averageAct_Accuracy_FPHMM_TrainSet = mean(accuracyTrainSet_UnknownEm,1);


averageEm_Accuracy_FPHMM_MissingSet = mean(accuracyEmotionMissingSet,1);
averageEm_Accuracy_FPHMM_TestSet = mean(accuracyEmotionTestSet,1);
averageEm_Accuracy_FPHMM_ValSet = mean(accuracyEmotionValSet,1);
averageEm_Accuracy_FPHMM_TrainSet = mean(accuracyEmotionTrainSet,1);

%% load HMM 
accuracy_TrainData_HMM_EmAct = zeros(numExp,1);
accuracy_TestData_HMM_EmAct = zeros(numExp,1);
accuracy_ValData_HMM_EmAct = zeros(numExp,1);
accuracy_MissingData_HMM_EmAct = zeros(numExp,1);

accuracy_Em_TrainData_HMM_EmAct = zeros(numExp,1);
accuracy_Em_TestData_HMM_EmAct = zeros(numExp,1);
accuracy_Em_ValData_HMM_EmAct = zeros(numExp,1);
accuracy_Em_MissingData_HMM_EmAct = zeros(numExp,1);
for indexp =3:numExp+2
path = strcat('./Experiment00',num2str(indexp),'/Results/');
tmpfileNamesList = dir(strcat(path,'2Act_*HMM*EachEmAct*_Smaller.mat'));
numFl = length(tmpfileNamesList);
    for indFl =1:numFl
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_Emotion_MissingData_HMM');
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_Emotion_TestData_HMM');
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_Emotion_TrainData_HMM');
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_Emotion_ValData_HMM');

    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_MissingData_HMM');
    load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_TestData_HMM');
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_TrainData_HMM');
     load(strcat(path,tmpfileNamesList(indFl).name),'accuracy_ValData_HMM');
     
accuracy_TrainData_HMM_EmAct(indexp-2,1) = accuracy_TrainData_HMM
accuracy_TestData_HMM_EmAct(indexp-2,1) = accuracy_TestData_HMM
accuracy_ValData_HMM_EmAct(indexp-2,1) = accuracy_ValData_HMM
accuracy_MissingData_HMM_EmAct(indexp-2,1) = accuracy_MissingData_HMM

accuracy_Em_TrainData_HMM_EmAct(indexp-2,1) = accuracy_Emotion_TrainData_HMM
accuracy_Em_TestData_HMM_EmAct(indexp-2,1) = accuracy_Emotion_TestData_HMM;
accuracy_Em_ValData_HMM_EmAct(indexp-2,1)= accuracy_Emotion_ValData_HMM;
accuracy_Em_MissingData_HMM_EmAct(indexp-2,1) = accuracy_Emotion_MissingData_HMM;

    
    
    end

end

average_Act_Accuracy_HMM_Train = mean(accuracy_TrainData_HMM_EmAct,1);
average_Act_Accuracy_HMM_Test = mean(accuracy_TestData_HMM_EmAct,1);
average_Act_Accuracy_HMM_Val = mean(accuracy_ValData_HMM_EmAct,1);
average_Act_Accuracy_HMM_Missing = mean(accuracy_MissingData_HMM_EmAct,1);


average_Em_Accuracy_HMM_Train = mean(accuracy_Em_TrainData_HMM_EmAct,1);
average_Em_Accuracy_HMM_Test = mean(accuracy_Em_TestData_HMM_EmAct,1);
average_Em_Accuracy_HMM_Val = mean(accuracy_Em_ValData_HMM_EmAct,1);
average_Em_Accuracy_HMM_Missing = mean(accuracy_Em_MissingData_HMM_EmAct,1);

save('-mat7-binary','savedAccuracy.mat','average_Act_Accuracy_HMM_Train');
save('-mat7-binary','savedAccuracy.mat','average_Act_Accuracy_HMM_Test','-append');
save('-mat7-binary','savedAccuracy.mat','average_Act_Accuracy_HMM_Val','-append');
save('-mat7-binary','savedAccuracy.mat','average_Act_Accuracy_HMM_Missing','-append');

save('-mat7-binary','savedAccuracy.mat','average_Em_Accuracy_HMM_Train','-append');
save('-mat7-binary','savedAccuracy.mat','average_Em_Accuracy_HMM_Test','-append');
save('-mat7-binary','savedAccuracy.mat','average_Em_Accuracy_HMM_Val','-append');
save('-mat7-binary','savedAccuracy.mat','average_Em_Accuracy_HMM_Missing','-append');

save('-mat7-binary','savedAccuracy.mat','averageAct_Accuracy_FPHMM_MissingSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageAct_Accuracy_FPHMM_TrainSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageAct_Accuracy_FPHMM_TestSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageAct_Accuracy_FPHMM_ValSet','-append');

save('-mat7-binary','savedAccuracy.mat','averageEm_Accuracy_FPHMM_MissingSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageEm_Accuracy_FPHMM_TestSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageEm_Accuracy_FPHMM_TrainSet','-append');
save('-mat7-binary','savedAccuracy.mat','averageEm_Accuracy_FPHMM_ValSet','-append');

% figure 
% plot(averageAct_Accuract_FPHMM_MissingSet,'--o')
% hold on;
% plot(averageAct_Accuract_FPHMM_TestSet,'--*')
% hold on;
% plot(averageAct_Accuract_FPHMM_ValSet,'--^')
% hold on;
% plot(averageAct_Accuract_FPHMM_TrainSet,'--s')
% hold on;
% xlabel('dim of theta','FontSize',14);
% ylabel('activity classification Accuracy','FontSize',18);
% % legend({'HMM TrainSet','HMM TestSet','HMM ValSet','HMM MissPairs','TrainSet KnownEm','TrainSet UnknownEm','MissingSet KnownEm', 'MissingSet UnknownEm','TestSet KnownEm','TestSet UnknownEm',...
% %     'ValSet KnownEm','ValSetUnknownEm'},'FontSize',14);
% legend({'HMM TrainSet','HMM TestSet','HMM ValSet','HMM MissPairs','CHMM TrainSet', 'CHMM MissingSet','CHMM TestSet',...
%     '~CHMM Val_Set'},'FontSize',14);
% axis([1,8,0,1]);
% figure
% set(gca,'LooseInset',get(gca,'TightInset'));


