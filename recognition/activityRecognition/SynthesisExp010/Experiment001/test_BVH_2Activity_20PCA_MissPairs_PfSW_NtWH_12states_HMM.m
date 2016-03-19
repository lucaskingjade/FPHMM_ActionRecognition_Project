%This is experiment script to test the convergence of thetas

close all
clear all
clc

ExperimentName ='SynthesisExp010';
subExperiment = 'Experiment001';

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
numStates = 12;
numMix = 1;
max_iter = 25;

emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Simple Walk','Walk with smth in the Hands'};
MissingPairs = {'Panic Fear','Simple Walk';'Neutral','Walk with smth in the Hands'};
Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
TestProportion = 0.3;
TrainingProportion = 0.7;

TestProportion = 0.3;
TrainingPropotion = 0.7;

numEmotion = size(emotionCell,2);
numActivity = size(activityCell,2);
numActor = size(Names,2);
numMissPair = size(MissingPairs,1);

MissingStr ='PfSW_NtWH_RmFirst3Dims_Unscaled_';
LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PfSW_NtWH.mat'


load(LoadDataName);

TrainHMM4OneActivity_Synthesis
TestHMM4OneActivity_Synthesis
%save all the variables into a file
save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');
timestr = clock();
save_file_name = strcat(save_path,num2str(numActivity),'Act_',num2str(numEmotion),'Em_',num2str(size(Names,2)),...
    'Actors_',num2str(numStates),'States_HMM_',MissingStr,num2str(timestr(1)),'_',num2str(timestr(2)),'_',...
num2str(timestr(3)),'_',num2str(timestr(4)),'_',num2str(timestr(5)));
    
%saveas(allfigs,save_file_name,'png');
save('-mat7-binary',strcat(save_file_name,'.mat'));

