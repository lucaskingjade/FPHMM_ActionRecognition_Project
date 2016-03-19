%This is experiment script to test the convergence of thetas

close all
clear all
clc

ExperimentName = 'Experiments009';

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

isPrepareData = 1;% 1 prepare data; 0:load old data
K = 5;
left2rightHMMtopology = 0;
numStates = 8;%8
numMix = 1;
mxIter_FPHMM = 35;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FPHMM_HMM_init_Iter = 25;  %!!!!!!!!!!!!!!!!!!!!!!!!!!
isNormalized = 0;
theta_dim = 1;%!!!!!!!!!!!!!!!!!
isRandomInit = 1;
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Being Seated','Sitting Down'};
Names = {'Brian','Elie','Florian','Hu'}

isPCA = 1;
prepareData_Train_Val_Test;
disp('begin to save variables...\n');
%save K_TrainingSet,K_TestingSet,CrossValDataSet and test;
savename = strcat('DataSet_',num2str(size(emotionCell,2)),'Em_',num2str(size(activityCell,2)),'Act_',num2str(size(Names,2)),'Actor_0.3Test_0.7Train_5Folds.mat');
save('-mat7-binary',savename,'K_TrainingSet');
save('-mat7-binary',savename,'K_TestingSet','-append');
save('-mat7-binary',savename,'CrossValDataSet','-append');
save('-mat7-binary',savename,'testDataSet','-append');


