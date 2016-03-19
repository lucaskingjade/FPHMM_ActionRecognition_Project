%This is experiment script to test the convergence of thetas

close all
clear all
clc

ExperimentName = 'Experiments004';

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
theta_dim = 7;%!!!!!!!!!!!!!!!!!
isRandomInit = 1;
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Simple Walk'};
Names = {'Brian','Elie','Florian','Hu'};

isPCA = 1;
if isPrepareData ==1
	prepareDataSet;
end

K =5;
contextualVector = cell(numEmotion,1);% save thetas values
contextualVector{1,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{2,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{3,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{4,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{5,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{6,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{7,1} = [rand;rand;rand;rand;rand;rand;rand];
contextualVector{8,1} = [rand;rand;rand;rand;rand;rand;rand];
%isFixed = [0 0 0 1 0 0 0 0];

TrainingFPHMM;
TestEmotionAccuracy;
TestFPHMM;
plotthelearningProcess;



