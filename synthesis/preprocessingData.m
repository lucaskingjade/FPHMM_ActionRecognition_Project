%prepare data

numActivity = length(activityCell);
numEmotion = length(emotionCell);

%%prepare dataset for training HMM and FPHMM %%
allDataCell = cell(numActivity,numEmotion);
allData = [];
[allDataCell, allData] = preproData_AcRg(activityCell,emotionCell,Names);

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
disp('remove Missing Pairs\n');
[ DataCell,MissingDataSet ] = removeMissingPairs( allDataCell,emotionCell,activityCell,MissingPairs );
%Split DataCell into training,validation and test sets.
disp('divide DataSet into Test,Val and Training\n');
[tmpDataCell,TestDataSet] =divideDataSet(DataCell,K_test);
[TrainDataSet,ValDataSet] =divideDataSet(tmpDataCell,K_Val);
%flatten all datasets into matrices
TrainDataMatrix = flattenDataSample(TrainDataSet);
MissingDataMatrix = flattenDataSample(MissingDataSet) ;
TestDataMatrix = flattenDataSample(TestDataSet);
ValDataMatrix = flattenDataSample(ValDataSet);

%scaling datasets
disp('scale the datasets');
[TrainDataMatrix_Scaled, maxVector,minVector] = scaling( TrainDataMatrix, 2);
MissingDataMatrix_Scaled = scaling_GivenScalers( MissingDataMatrix, maxVector,minVector,2);
TestDataMatrix_Scaled = scaling_GivenScalers( TestDataMatrix,maxVector,minVector,2);
ValDataMatrix_Scaled = scaling_GivenScalers( ValDataMatrix, maxVector,minVector,2);

%PCA
if isPCA
    dim = 16;
	display('do pca\n');
    [TrainDataSet, TrainDataMatrix_PCA,eigenValue,eigenMatrix] = PCA_TrainingSet(TrainDataSet,TrainDataMatrix_Scaled,dim);
    [MissingDataSet, MissingDataMatrix_PCA] = PCA_GivenEigenMatrix(MissingDataSet,MissingDataMatrix_Scaled,eigenMatrix);
    [TestDataSet, TestDataMatrix_PCA] = PCA_GivenEigenMatrix(TestDataSet,TestDataMatrix_Scaled,eigenMatrix);
    [ValDataSet, ValDataMatrix_PCA] = PCA_GivenEigenMatrix(ValDataSet,ValDataMatrix_Scaled,eigenMatrix);
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
disp('finish prepraring dataset!');
%% save data variables 
%save('DataSet.mat','TrainDataSet');
%save('DataSet.mat','TrainDataMatrix_PCA','-append');
%save('DataSet.mat','MissingDataSet','-append');
%save('DataSet.mat','MissingDataMatrix_PCA','-append');
%save('DataSet.mat','TestDataSet','-append');
%save('DataSet.mat','TestDataMatrix_PCA','-append');
%save('DataSet.mat','TrainDataSet_HMM','-append');
%save('DataSet.mat','ValDataSet','-append');
%save('DataSet.mat','ValDataMatrix_PCA','-append');
%save('DataSet.mat','eigenValue','-append');
%save('DataSet.mat','eigenMatrix','-append');
%save('DataSet.mat','maxVector','-append');
%save('DataSet.mat','minVector','-append');
%save('DataSet.mat','MissingPairs','-append');
%save('DataSet.mat','Names','-append');
%save('DataSet.mat','activityCell','-append');
%save('DataSet.mat','emotionCell','-append');
%save('DataSet.mat','left2rightHMMtopology','-append');
%save('DataSet.mat','isPCA','-append');
%save('DataSet.mat','dim','-append');
%save('DataSet.mat','numActivity','-append');
%save('DataSet.mat','numEmotion','-append');


