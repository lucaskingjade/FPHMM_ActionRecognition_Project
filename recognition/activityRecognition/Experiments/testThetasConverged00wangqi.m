%This is experiment script to test the convergence of thetas

close all
clear all
clc
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
isPrepareData = 1;% 1 prepare data; 0:load old data
K = 5;
left2rightHMMtopology = 0;
numStates = 8;%8
numMix = 1;
mxIter_FPHMM = 2;
FPHMM_HMM_init_Iter = 1;  %!!!!!!!!!!!!!!!!!!!!!!!!!!
isNormalized = 0;
theta_dim = 2;
isRandomInit = 1;
emotionCell = {'Anger','Anxiety'};
activityCell = {'Simple Walk','Walk with smth in the Hands'};
Names = {'Elie'};

isPCA = 1;
if isPrepareData ==1
	prepareDataSet;
end

K =5;
contextualVector = cell(numEmotion,1);% save thetas values
contextualVector{1,1} = [rand;rand];
contextualVector{2,1} = [rand;rand];

TrainingFPHMM;
TestEmotionAccuracy;
TestFPHMM;
plotthelearningProcess;



