%This is experiment script to test the convergence of thetas

close all
clear all
clc

ExperimentName = 'Synthesis001';

path0 = getenv('FPHMM_PATH')
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/ContextualModel')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/synthesis')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project')))
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001/')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/HMM')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMstats')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMtools')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/netlab3.3')));

addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Experiments')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName)));
left2rightHMMtopology = 0;
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
MissingPairs = {'Anger','Simple Walk';'Joy','Knocking on the Door';'Sadness','Move Books'};
K_test = 5;%control the size of test size
K_Val = 10;%control the size of validation size
isPCA = 1;
preprocessingData;
%save K_TrainingSet,K_TestingSet,CrossValDataSet and test;
savename = strcat('./DataSet_',num2str(size(emotionCell,2)),'Em_',num2str(size(activityCell,2)),'Act_',num2str(size(Names,2)),'Actor_3MissPairs_0.2Test_0.1Val_0.7Train.mat');
save('-mat7-binary',savename,'TrainDataSet');
save('-mat7-binary',savename,'TrainDataMatrix_PCA','-append');
save('-mat7-binary',savename,'MissingDataSet','-append');
save('-mat7-binary',savename,'MissingDataMatrix_PCA','-append');
save('-mat7-binary',savename,'TestDataSet','-append');
save('-mat7-binary',savename,'TestDataMatrix_PCA','-append');
save('-mat7-binary',savename,'TrainDataSet_HMM','-append');
save('-mat7-binary',savename,'ValDataSet','-append');
save('-mat7-binary',savename,'ValDataMatrix_PCA','-append');
save('-mat7-binary',savename,'eigenValue','-append');
save('-mat7-binary',savename,'eigenMatrix','-append');
save('-mat7-binary',savename,'maxVector','-append');
save('-mat7-binary',savename,'minVector','-append');
save('-mat7-binary',savename,'MissingPairs','-append');
save('-mat7-binary',savename,'Names','-append');
save('-mat7-binary',savename,'activityCell','-append');
save('-mat7-binary',savename,'emotionCell','-append');
save('-mat7-binary',savename,'left2rightHMMtopology','-append');
save('-mat7-binary',savename,'isPCA','-append');
save('-mat7-binary',savename,'dim','-append');
save('-mat7-binary',savename,'numActivity','-append');
save('-mat7-binary',savename,'numEmotion','-append');
