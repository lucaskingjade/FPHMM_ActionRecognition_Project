%prepare data

close all
clear all
clc
path0 = '/Users/qiwang/Documents/matlab projects/';
addpath(genpath(strcat(path0,'fullyParameterizedHMM\Project\recognition\activityRecognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));%import dataset

%%predefined variables
left2rightHMMtopology = 0;
isPCA = 1;
%%==== variables definitions ===== %%
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
MissingPairs = {'Anger','Simple Walk';'Joy','Knocking on the Door';'Sadness','Move Books'};

%Robert: only few sequences
numActivity = length(activityCell);
numEmotion = length(emotionCell);

%%prepare dataset for training HMM and FPHMM %%
allDataCell = cell(numActivity,numEmotion);
allData = [];
[allDataCell, allData] = preproData_AcRg_Bvh(activityCell,emotionCell,Names);

%remove rows that contains nan from all data sequences
% [allData,rowIndex ]= rmZeroRow(allData);
% for indAct =1:numActivity
%     for indEm = 1:numEmotion
%         numFl = size(allDataCell{indAct,indEm},1);
%         for indFl = 1:numFl
%             allDataCell{indAct,indEm}{indFl,1} = rmZeroRow(allDataCell{indAct,indEm}{indFl,1},rowIndex);
%         end
%     end
% end

%% Preprocessing

%Remove missed data from dataset.
[ DataCell,MissingDataSet ] = removeMissingPairs( allDataCell,emotionCell,activityCell,MissingPairs );
%Split DataCell into training,validation and test sets.
[tmpDataCell,TestDataSet] =divideDataSet(DataCell,5);
[TrainDataSet,ValDataSet] =divideDataSet(tmpDataCell,10);
%flatten all datasets into matrices
TrainDataMatrix = flattenDataSample(TrainDataSet);
MissingDataMatrix = flattenDataSample(MissingDataSet) ;
TestDataMatrix = flattenDataSample(TestDataSet);
ValDataMatrix = flattenDataSample(ValDataSet);

%scaling datasets
% [TrainDataMatrix_Scaled, maxVector,minVector] = scaling( TrainDataMatrix, 2);
% MissingDataMatrix_Scaled = scaling_GivenScalers( MissingDataMatrix, maxVector,minVector,2);
% TestDataMatrix_Scaled = scaling_GivenScalers( TestDataMatrix,maxVector,minVector,2);
% ValDataMatrix_Scaled = scaling_GivenScalers( ValDataMatrix, maxVector,minVector,2);
%add delta and delta-delta of Observation Frame

% TrainDataMatrix_FirstOrder = DeltaOfFrame(TrainDataMatrix,1);
% TrainDataMatrix_SecondOrder = DeltaOfFrame(TrainDataMatrix_FirstOrder,2);
% TrainDataMatrixDelta = [TrainDataMatrix;TrainDataMatrix_FirstOrder;TrainDataMatrix_SecondOrder];
% 
% MissingDataMatrix_FirstOrder = DeltaOfFrame(MissingDataMatrix,1);
% MissingDataMatrix_SecondOrder = DeltaOfFrame(MissingDataMatrix_FirstOrder,2);
% MissingDataMatrixDelta = [MissingDataMatrix;MissingDataMatrix_FirstOrder;MissingDataMatrix_SecondOrder];
% 
% TestDataMatrix_FirstOrder = DeltaOfFrame(TestDataMatrix,1);
% TestDataMatrix_SecondOrder = DeltaOfFrame(TestDataMatrix_FirstOrder,2);
% TestDataMatrixDelta = [TestDataMatrix;TestDataMatrix_FirstOrder;TestDataMatrix_SecondOrder];
% 
% ValDataMatrix_FirstOrder = DeltaOfFrame(ValDataMatrix,1);
% ValDataMatrix_SecondOrder = DeltaOfFrame(ValDataMatrix_FirstOrder,2);
% ValDataMatrixDelta = [ValDataMatrix;ValDataMatrix_FirstOrder;ValDataMatrix_SecondOrder];


%% PCA
if isPCA
    dim = 16;
    [TrainDataSet, TrainDataMatrix_PCA,eigenValue,eigenMatrix] = PCA_TrainingSet(TrainDataSet,TrainDataMatrix,dim);
    [MissingDataSet, MissingDataMatrix_PCA] = PCA_GivenEigenMatrix(MissingDataSet,MissingDataMatrix,eigenMatrix);
    [TestDataSet, TestDataMatrix_PCA] = PCA_GivenEigenMatrix(TestDataSet,TestDataMatrix,eigenMatrix);
    [ValDataSet, ValDataMatrix_PCA] = PCA_GivenEigenMatrix(ValDataSet,ValDataMatrix,eigenMatrix);
end

%% convert the TrainDataSet to a Cell ignoring the emotion label
TrainDataSet_HMM = cell(numActivity,1);
for indAct = 1:numActivity
    TrainDataSet_HMM{indAct,1} ={};
    for indEm = 1:numEmotion
        if ~iscell(TrainDataSet{indAct,indEm})
            continue;
        end
        TrainDataSet_HMM{indAct,1} = [TrainDataSet_HMM{indAct,1};TrainDataSet{indAct,indEm}];
    end
end

%% save data variables 
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','TrainDataSet');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','TrainDataMatrix_PCA','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','MissingDataSet','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','MissingDataMatrix_PCA','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','TestDataSet','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','TestDataMatrix_PCA','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','TrainDataSet_HMM','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','ValDataSet','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','ValDataMatrix_PCA','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','eigenValue','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','eigenMatrix','-append');
% save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','maxVector','-append');
% save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','minVector','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','MissingPairs','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','Names','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','activityCell','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','emotionCell','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','left2rightHMMtopology','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','isPCA','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','dim','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','numActivity','-append');
save('DataSetUnscaledDelta_Bvh_FinalVersion.mat','numEmotion','-append');


