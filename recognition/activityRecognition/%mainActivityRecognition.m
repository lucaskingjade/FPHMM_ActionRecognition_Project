%%%This experiment is distributed for comparing the performance of HMM and
%%%FPHMM on activity recognition by Qi WANG at 05/11/2015. 
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
%% ==== variables definitions ===== %%
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
% activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
activityCell = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
Names = {'Brian','Elie','Florian','Hu','Janina','Jessica'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
%Robert: only few sequences
numActivity = length(activityCell);
numEmotion = length(emotionCell);

%% prepare dataset for training HMM and FPHMM %%
allDataCell = cell(numActivity,numEmotion);
allData = [];
[allDataCell, allData] = preproData_AcRg(activityCell,emotionCell,Names);
if isPCA
    dim = 16;
    [allDataCell, allData] = PCA_allData(allDataCell,allData,dim);
end


%% divide dataset into training and testing set.
K = 6; %num of partitions of dataset for cross validation.

%for the sequences of each activity and each motion, we divide them into k
% folders.By recombiantion,we can achieve k-folder cross-validation
KFolders = cell(numActivity,numEmotion);
parfor indAct = 1:numActivity
    for indEm = 1:numEmotion
        KFolders{indAct,indEm} = cvpartition(size(allDataCell{indAct,indEm},1),'kfold',K);        
    end
end

indFold = 1;


K_CV_HMMCell = cell(K,1);
K_CV_FPHMMCell = cell(K,1);
for indFold = 1:K
%% prepare training set and testing set%%
trainingSet = cell(numActivity,numEmotion);
% testingSet = cell(numActivity,numEmotion);
for indAct = 1:numActivity
    for indEm = 1:numEmotion
        currentFold = KFolders{indAct,indEm};
        indTraining = currentFold.training(indFold);
%         indTesting = currentFold.test(indFold);
        trainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
%         testingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
    end
end
%% training conventional HMM for each activity and emotion pair%%
numStates = 8;
numMix = 1;
max_iter = 10;
mxIter_FPHMM = 5;
HMMCell = cell(numActivity,numEmotion);

parfor indAct =1:numActivity
    for indEm = 1:numEmotion
        HMMCell{indAct,indEm} = cell(6,1);
        [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
            trainingConventionHMM(trainingSet{indAct,indEm},numStates,numMix,max_iter,left2rightHMMtopology);
        HMMCell{indAct,indEm}{1,1} = LL;
        HMMCell{indAct,indEm}{2,1} = prior1;
        HMMCell{indAct,indEm}{3,1} = transmat1;
        HMMCell{indAct,indEm}{4,1} = mu1;
        HMMCell{indAct,indEm}{5,1} = Sigma1;
        HMMCell{indAct,indEm}{6,1} = mixmat1;
    end   

    % [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(testData, prior1, transmat1, mu1, Sigma1, mixmat1);
end

%% save all data here

K_CV_HMMCell{indFold,1} = HMMCell;



%% counting sample numbers
%count the sequence number of each activity
totalNumTraining = zeros(numActivity,1);
parfor indAct = 1:numActivity
    for indEm = 1: numEmotion
        totalNumTraining(indAct,1) = totalNumTraining(indAct,1) + size(trainingSet{indAct,indEm},1);
    end    
end
%% training a FPHMM for each activity %%
contextualVector = cell(8,1);
contextualVector{1,1} = rand(2,1);
contextualVector{2,1} = rand(2,1);
contextualVector{3,1} = rand(2,1);
contextualVector{4,1} = rand(2,1);
contextualVector{5,1} = rand(2,1);
contextualVector{6,1} = rand(2,1);
contextualVector{7,1} = rand(2,1);
contextualVector{8,1} = rand(2,1);

FPHMMCell = cell(numActivity,1);
parfor indAct = 1:numActivity
    fprintf('intActivity is %d',indAct);
    tmpContexutalVector = contextualVector;
    nex = totalNumTraining(indAct,1);
    data = cell(nex,1);
    data0 = [];
    thetasSet = cell(nex,1);
    index = 0;
    numOfSeq4Emotion = zeros(numEmotion,1);%num of sequences of each emotion.
    for indEm = 1:numEmotion
        curNumFl = size(trainingSet{indAct,indEm},1);
        for indFl =1:curNumFl
            index = index +1;
            curEmotion = trainingSet{indAct,indEm}{indFl,2};
            t = size(trainingSet{indAct,indEm}{indFl,1},2);
            tmpVector = getContexutalVector(curEmotion,tmpContexutalVector);
            thetas = repmat(tmpVector,1,t);
            thetasSet{index,1} = thetas;
            data{index,1} = trainingSet{indAct,indEm}{indFl,1};
            numOfSeq4Emotion(indEm,1) = numOfSeq4Emotion(indEm,1) + 1; 
            data0 = [data0,data{index,1}];
        end
    end
    
    Q = numStates;
    M =numMix;
    O = size(data0,1);
    cov_type = 'full';
    %initial parameters of FPHMM
    prior0 = normalise(rand(Q,1));
    
    if left2rightHMMtopology ==0
        transmat0 = mk_stochastic(rand(Q,Q));
    else
        disp('!!!!!!!!!!Warning: using Left2Right HMM!!!!!!!!');
        transmat0 = diag(0.5.*ones(Q,1))+[[zeros(Q-1,1) diag(0.5.*ones(Q-1,1))];zeros(1,Q)];
    end
    
    [mu0, Sigma0] = mixgauss_init(Q*M, data0, cov_type);
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    mixmat0 = normalise(mixmat0,2);
    
    %%training a conventional HMM%%
    disp('train a conventional HMM')
    iter = max_iter;
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
        mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', iter);
    [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
    disp('train a FPHMM');
    hmmParameterSet = struct('prior1', prior1, 'transmat1', transmat1, 'mu1', mu1, 'Sigma1', Sigma1, 'mixmat1', mixmat1);
    %modified by wangqi at 27/11/2015: add a input parameter, numOfSeq4Emotion
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1, zSet,thetasSet,tmpContexutalVector] = phmm_em(data, numOfSeq4Emotion,thetasSet, gammaSet, hmmParameterSet, 'transitionLeft2Right', left2rightHMMtopology, 'max_iter', mxIter_FPHMM, 'thresh', 1e-4, 'verbose', 1);
    disp('final learned theta:');
    for indThetas = 1: size(tmpContexutalVector,1)
        fprintf('\n theta %d:\n',indThetas);
        disp(tmpContexutalVector{indThetas,1});
    
    end
    
    contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet});
    %save all the parameters of trained FPHMM model
    disp('saving FPHMM parameters... ... ...');
    FPHMMCell{indAct,1} = cell(7,1);
    FPHMMCell{indAct,1}{1,1} = prior1;
    FPHMMCell{indAct,1}{2,1} = transmat1;
    FPHMMCell{indAct,1}{3,1} = mu1;
    FPHMMCell{indAct,1}{4,1} = Sigma1;
    FPHMMCell{indAct,1}{5,1} = mixmat1;
    FPHMMCell{indAct,1}{6,1} = contextualSignal;
    FPHMMCell{indAct,1}{7,1} = tmpContexutalVector;
%     fprintf('IndAct =%d',indAct);
    
end

%% save FPHMM for each fold

K_CV_FPHMMCell{indFold,1} = FPHMMCell;
fprintf('IndFolde =%d',indFold);

end

























