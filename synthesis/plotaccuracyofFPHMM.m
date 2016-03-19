%plot the accuracy of FPHMM

ExperimentName ='SynthesisExp001';
ResultPath = strcat('/Users/qiwang/Documents/matlab projects/fullyParameterizedHMM/Project/recognition/activityRecognition/'...
    ,ExperimentName,'/Results');tmpfileNamesList = dir(fullfile(ResultPath,'*35FPHMM*.mat'));
numFl = length(tmpfileNamesList);
accuracyMissingSet_KnownEm = zeros(1,numFl);
accuracyMissingSet_UnknownEm= zeros(1,numFl);
accuracyTestSet_KnownEm = zeros(1,numFl);
accuracyTestSet_UnknownEm = zeros(1,numFl);
accuracyValSet_KnownEm = zeros(1,numFl);
accuracyValSet_UnknownEm = zeros(1,numFl);
accuracyTrainSet_KnownEm = zeros(1,numFl);
accuracyTrainSet_UnknownEm = zeros(1,numFl);

accuracyEmotionMissingSet  = zeros(1,numFl);
accuracyEmotionTestSet = zeros(1,numFl);
accuracyEmotionValSet = zeros(1,numFl);
accuracyEmotionTrainSet = zeros(1,numFl);

thetadim = zeros(1,numFl);
for indFl = 1:numFl
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_MissingSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_MissingSet_unknownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TestSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TestSet_unknownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_ValSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_ValSet_unknownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TrainSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracy_FPHMM_TrainSet_unknownEm');
    
    load(tmpfileNamesList(indFl).name,'theta_dim');
    fprintf('dim fo theta is: %d',theta_dim);
    thetadim(1,indFl) = theta_dim;
    accuracyMissingSet_KnownEm(1,indFl) = accuracy_FPHMM_MissingSet_knownEm;
    accuracyMissingSet_UnknownEm(1,indFl) = accuracy_FPHMM_MissingSet_unknownEm;
    accuracyTestSet_KnownEm(1,indFl) = accuracy_FPHMM_TestSet_knownEm;
    accuracyTestSet_UnknownEm(1,indFl) = accuracy_FPHMM_TestSet_unknownEm;
    accuracyValSet_KnownEm(1,indFl) = accuracy_FPHMM_ValSet_knownEm;
    accuracyValSet_UnknownEm(1,indFl) = accuracy_FPHMM_ValSet_unknownEm;
    accuracyTrainSet_KnownEm(1,indFl) = accuracy_FPHMM_TrainSet_knownEm;
    accuracyTrainSet_UnknownEm(1,indFl) = accuracy_FPHMM_TrainSet_unknownEm;
    
    %Emotion Accuracy
    load(tmpfileNamesList(indFl).name,'accuracyEmotion_FPHMM_MissingSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracyEmotion_FPHMM_TestSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracyEmotion_FPHMM_ValSet_knownEm');
    load(tmpfileNamesList(indFl).name,'accuracyEmotion_FPHMM_TrainSet_knownEm');

    accuracyEmotionMissingSet(1,indFl)  = accuracyEmotion_FPHMM_MissingSet_knownEm;
    accuracyEmotionTestSet(1,indFl) = accuracyEmotion_FPHMM_TestSet_knownEm;
    accuracyEmotionValSet(1,indFl) = accuracyEmotion_FPHMM_ValSet_knownEm;
    accuracyEmotionTrainSet(1,indFl) = accuracyEmotion_FPHMM_TrainSet_knownEm;
    
end

%plot
plot(thetadim,accuracyMissingSet_KnownEm,'--o');
hold on;
plot(thetadim,accuracyMissingSet_UnknownEm,'--o');
hold on;
plot(thetadim,accuracyTestSet_KnownEm,'--o');
hold on;
plot(thetadim,accuracyTestSet_UnknownEm,'--o');
hold on;
plot(thetadim,accuracyValSet_KnownEm,'--o');
hold on;
plot(thetadim,accuracyValSet_UnknownEm,'--o');
hold on;
plot(thetadim,accuracyTrainSet_KnownEm,'--o');
hold on;
plot(thetadim,accuracyTrainSet_UnknownEm,'--o');
hold on;
plot(thetadim,accuracyEmotionMissingSet,'-.*');
hold on;
plot(thetadim,accuracyEmotionTestSet,'-.*');
hold on;
plot(thetadim,accuracyEmotionValSet,'-.*');
hold on;
plot(thetadim,accuracyEmotionTrainSet,'-.*');
xlabel('dim of theta','FontSize',14);
ylabel('activity classification error rate','FontSize',18);
legend({'MissingSet KnownEm', 'MissingSet UnknownEm','TestSet KnownEm','TestSet UnknownEm',...
    'ValSet KnownEm','ValSetUnknownEm','TrainSet KnownEm','TrainSet UnknownEm',...
    'Emotion MissingSet','Emotion TestSet','Emotion ValSet','Emotion TrainSet'},'FontSize',14);


