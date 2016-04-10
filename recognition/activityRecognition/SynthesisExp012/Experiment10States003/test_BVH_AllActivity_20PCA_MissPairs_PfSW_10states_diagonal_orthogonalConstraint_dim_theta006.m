%This is experiment script to test the convergence of thetas

close all
clear all
clc

ExperimentName = 'SynthesisExp012';
subExperiment = 'Experiment10States003';
path0 = getenv('FPHMM_PATH')
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/ContextualModel')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project')))
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001/')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/HMM')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMstats')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMtools')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/netlab3.3')));

addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Experiments')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName)));

left2rightHMMtopology = 0;
cov_type = 'diag';
orthogonal_constrain_W = 1;
numStates = 10;
numMix = 1;
mxIter_FPHMM = 35;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FPHMM_HMM_init_Iter = 25;  %!!!!!!!!!!!!!!!!!!!!!!!!!!
isNormalized = 0;
isRandomInit = 1;
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
MissingPairs = {'Panic Fear','Simple Walk'};
%Names = {'Brian','Elie','Florian','Hu'};
Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
TestProportion = 0.3;
TrainingProportion = 0.7;

isPCA = 1;
TestProportion = 0.3;
TrainingPropotion = 0.7;

numEmotion = size(emotionCell,2);
numActivity = size(activityCell,2);
numActor = size(Names,2);
numMissPair = size(MissingPairs,1);

MissingStr = 'PfSW_RmFirst3Dims_Unscaled_MeanSubtracted_EachActor_Centred_';
LoadDataName = 'DataSetOffSet4thDim_RmFirst3Dims_UnScaled_20PCA_allTrainingSet_Bvh_MeanSub_eachActor_PfSW_Centered_003.mat';

load(LoadDataName);
theta_dim = 6;
contextualVector = cell(numEmotion,1);% save thetas values
contextualVector{1,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{2,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{3,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{4,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{5,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{6,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{7,1} = [rand;rand;rand;rand;rand;rand];
contextualVector{8,1} = [rand;rand;rand;rand;rand;rand];
%isFixed = [0 0 0 1 0 0 0 0];

TrainingFPHMM_Synthesis;
save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');
if isRandomInit ==1
    str1 = 'RandInit';
else
    str1 = 'fixedInit';
end

if isNormalized ==1
    str2 = 'Normalised';
else
    str2 = 'UnNormalised'
end
timestr = clock();
%save_file_name = strcat(save_path,'trainedModel_',num2str(numActivity),'Act_',num2str(numEmotion),'Em_'...
%,num2str(size(Names,2)),'Actors_',num2str(theta_dim),'thetadim_',str1,'_',str2,'_',num2str(FPHMM_HMM_init_Iter),'+',num2str(mxIter_FPHMM),'FPHMM_Scaled_Offset_Bvh_',MissingStr,'Missing',num2str(timestr(1)),'_',num2str(timestr(2)),'_',...
%num2str(timestr(3)),'_',num2str(timestr(4)),'_',num2str(timestr(5)));
%save('-mat7-binary',strcat(save_file_name,'.mat'),'FPHMMCell');

TestFPHMM_Synthesis;
TestEmotionAccuracy_Synthesis;
%save all the variables into a file
save_file_name = strcat(save_path,num2str(numActivity),'Act_',num2str(numEmotion),'Em_',num2str(size(Names,2)),...
    'Actors_',num2str(theta_dim),'thetadim_',str1,'_',str2,'_',num2str(FPHMM_HMM_init_Iter),'+',num2str(mxIter_FPHMM),'FPHMM_Scaled_Offset_Bvh_',MissingStr,'Missing',num2str(timestr(1)),'_',num2str(timestr(2)),'_',...
num2str(timestr(3)),'_',num2str(timestr(4)),'_',num2str(timestr(5)));
    
%saveas(allfigs,save_file_name,'png');
%save('-mat7-binary',strcat(save_file_name,'.mat'));

save('-mat7-binary',strcat(save_file_name,'.mat'),'FPHMMCell');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_MissingSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_TestSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_TrainSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_ValSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_MissingSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_MissingSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_MissingSet_unknownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TestSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TestSet_unknownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TrainSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TrainSet_unknownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_ValSet_knownEm','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_ValSet_unknownEm','-append');
save('-mat-binary',strcat(save_file_name,'.mat'),'prdt*','-append');
save('-mat-binary',strcat(save_file_name,'.mat'),'theta_dim','-append');
save('-mat7-binary',strcat(save_file_name,'.mat'),'meanpose_TrainingSet','-append');
