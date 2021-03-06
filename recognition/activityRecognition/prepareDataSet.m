%prepare data
path0 = getenv('FPHMM_PATH')
addpath(genpath(strcat(path0,'fullyParameterizedHMM\Project\recognition\activityRecognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\Project')))
addpath(genpath(strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001/')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/HMM')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMstats')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/KPMtools')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall/netlab3.3')));
%%predefined variables
%left2rightHMMtopology = 0;
%isPCA = 1;
%%==== variables definitions ===== %%
% emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
%emotionCell = {'Anger','Shame','Joy','Sadness'};

% activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
% activityCell = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
%activityCell = {'Being Seated','Sitting Down','Simple Walk','Walk with smth in the Hands'};
%Names = {'Brian','Elie'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica'};
% Names = {'Brian'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
%Robert: only few sequences
numActivity = length(activityCell)
numEmotion = length(emotionCell)
which pca.m
%%prepare dataset for training HMM and FPHMM %%
allDataCell = cell(numActivity,numEmotion);
allData = [];
[allDataCell, allData] = preproData_AcRg(activityCell,emotionCell,Names);
%save('-mat7-binary','data.mat','allDataCell','allData');
%disp('save data finish');
printf('size of allDataCell is [%d,%d]\n',size(allDataCell,1),size(allDataCell,2));
printf('size of allData is [%d,%d]\n',size(allData,1),size(allData,2));
if isPCA
    dim = 16;
    [allDataCell, allData] = PCA_allData(allDataCell,allData,dim);
end


%%divide dataset into training and testing set.
%K = 6; %num of partitions of dataset for cross validation.

%for the sequences of each activity and each motion, we divide them into k
% folders.By recombiantion,we can achieve k-folder cross-validation
KFolders = cell(numActivity,numEmotion);
parfor indAct = 1:numActivity
    for indEm = 1:numEmotion
        KFolders{indAct,indEm} = cvpartition(size(allDataCell{indAct,indEm},1),'kfold',K);        
    end
end

%prepare training set
K_TrainingSet = cell(K,1);
for indFold = 1:K
    tmpTrainingSet = cell(numActivity,numEmotion);
    parfor indAct = 1:numActivity
        for indEm = 1:numEmotion
            currentFold = KFolders{indAct,indEm};
            indTraining = training(currentFold,indFold);
    %       indTesting = currentFold.test(indFold);
            tmpTrainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
    %         testingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
        end
    end
    K_TrainingSet{indFold,1} = tmpTrainingSet;
    

end
K_TestingSet = cell(K,1);
for indFold =1:K
    tmpTestingSet = cell(numActivity,numEmotion);
    parfor indAct = 1:numActivity
        for indEm = 1:numEmotion
            currentFold = KFolders{indAct,indEm};
            indTesting = test(currentFold,indFold);
            tmpTestingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
        end
    end
    K_TestingSet{indFold,1} = tmpTestingSet;
end
