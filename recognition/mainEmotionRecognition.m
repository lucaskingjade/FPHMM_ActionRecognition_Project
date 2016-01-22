close all
clear all
clc
path0 = '/Users/qiwang/Documents/matlab projects/';
addpath(genpath(strcat(path0,'recognition')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));%import dataset

left2rightHMMtopology = 0;
%% ==== prepare the data for conventional HMM Recognition===== %%
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
actionStyle = 'Simple Walk';
Names = {'Brian'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
%Robert: only few sequences

prdtLabelCell_HMM = cell(size(Names,2),1);
prdtLabelCell_FPHMM = cell(size(Names,2),1);
numCorLabCell_HMM = zeros(size(Names,2),size(emotionCell,2));
numSeqCell_HMM = zeros(size(Names,2),size(emotionCell,2));
numCorLabCell_FPHMM = zeros(size(Names,2),size(emotionCell,2));
numSeqCell_FPHMM = zeros(size(Names,2),size(emotionCell,2));

for indexName = 1:size(Names,2)

%     userName = {'Brian'};
    userName = Names(1,indexName);
    numEmotion = size(emotionCell,2);
    allDataCell = cell(numEmotion,1);
    [allDataCell,allData]= preprocessingData(actionStyle,emotionCell,userName);

    %==divide data into training data and testing data
    [trainingSet,testingSet] = divideDataset(allDataCell,0.8);

    %% ==create one HMM for each emotion== %%
    numStates = 4;
    numMix = 1;
    max_iter = 10;
%     numHMMs = size(trainingSet,1);
%     HMMCell = cell(numHMMs,6,1);
% 
%     for i =1:numHMMs
%         [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
%             trainingConventionHMM(trainingSet{i,1},numStates,numMix,max_iter);
%         HMMCell{i,1,1} = LL;
%         HMMCell{i,2,1} = prior1;
%         HMMCell{i,3,1} = transmat1;
%         HMMCell{i,4,1} = mu1;
%         HMMCell{i,5,1} = Sigma1;
%         HMMCell{i,6,1} = mixmat1;
% 
%         % [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(testData, prior1, transmat1, mu1, Sigma1, mixmat1);
%     end
%     %% ===Testing:determine the emotion of sequences
%     %%compute loglik ,and compare which HMM achieve largest loglik on the
%     %%traning sequence.
%     %%recognition emotions given test motion data.
%     numTestSize = size(testingSet,1);
%     prdtLabelCell_HMM{indexName,1} = cell(size(testingSet)); %inferred emotion label for each test sequence.
% 
%     for i = 1:numTestSize
%         prdtLabelCell_HMM{indexName,1}{i,1} = cell(size(testingSet{i,1})); 
%         for j = 1:size(testingSet{i,1},1)
%             [prdtLabel,maxLoglik]=recognitionEmotion_HMM(testingSet{i,1}{j,1},HMMCell);
%             prdtLabelCell_HMM{indexName,1}{i,1}{j,1} = prdtLabel;
%             prdtLabelCell_HMM{indexName,1}{i,1}{j,2} = maxLoglik;
%         end
%     %compute the probability of test observation given parameters of HMM.
% 
%     end


    %% ===train FPHMM===%%
    %trainingSet,testingSet
    totalNumTraining = 0;
    numEmotion = size(trainingSet,1);
    for i = 1: numEmotion
        totalNumTraining = totalNumTraining + size(trainingSet{i,1},1);
    end
    nex = totalNumTraining;
    data = cell(nex,1);
    data0 = [];
    thetasSet = cell(nex,1);
    index = 0;
    for i = 1:numEmotion
        numFile = size(trainingSet{i,1},1);
        for j = 1:numFile
            index = index +1;
            emotion = trainingSet{i,1}{j,2};
            t = size(trainingSet{i,1}{j,1},2);
            tmpVector = getContexutalVector(emotion);
            thetas = repmat(tmpVector,1,t);
            thetasSet{index,1} = thetas;
            data{index,1} = trainingSet{i,1}{j,1};
            data0 = [data0,data{index,1}];

        end

    end
    %% 
    Q = numStates;
    M = numMix;
    O = size(data0,1);
    cov_type = 'full';
    %initial parameters of FPHMM
    prior0 = normalise(rand(Q,1));
%     transmat0 = mk_stochastic(rand(Q,Q));
    if left2rightHMMtopology == 0
        transmat0 = mk_stochastic(rand(Q,Q));
    elseif  left2rightHMMtopology == 1
        transmat0 = diag(0.5.*ones(Q,1))+[[zeros(Q-1,1) diag(0.5.*ones(Q-1,1))];zeros(1,Q)];
    end
    
    [mu0, Sigma0] = mixgauss_init(Q*M, data0, cov_type);
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = mk_stochastic(rand(Q,M));
    mixmat0 = normalise(mixmat0,2);

    %%training a conventional HMM%%
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
        mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 10);
    [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
dasfsa
%     %== build a set for training contextual HMM
%     cellSet2CHMM = cell(3,Q,nex); 
%     %=3 means: observation, contextual parameters, gamma (state occupany probability)
%     for ex = 1:nex
%         for q = 1:Q
%             cellSet2CHMM{1,q,ex} = data{ex,1};
%             cellSet2CHMM{2,q,ex} = [thetasSet{ex,1}];
%             cellSet2CHMM{3,q,ex} = gammaSet{ex,1}(q,:);
%         end
%     end
% 
%     tempContextualHMM = getElements4CalculateWofCommonMeanParametricHMM(cellSet2CHMM, mu1);
%     %= get Z
%     wCommenValueSet = cell(Q,1);
%     zSet = cell(Q,1);
% 
%     for q = 1:Q
%         o_omega = tempContextualHMM{q,1};
%         omega_omega = tempContextualHMM{q,2};
%     %     q
%     %     det(omega_omega)
%         wCommenValueSet{q,1} = o_omega*(omega_omega^(-1));
%         zSet{q,1} = [wCommenValueSet{q,1} mu1(:,q)];
%     end
%     cellSet2SigmaCHMM = cell(3,Q,nex); 
%     %=3 means: observation, contextual parameters, gamma (state occupany probability)
%     for ex = 1:nex
%         for q = 1:Q
%             cellSet2SigmaCHMM{1,q,ex} = data{ex,1};
%             cellSet2SigmaCHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
%             cellSet2SigmaCHMM{3,q,ex} = gammaSet{ex,1}(q,:);
%         end
%     end
% 
% 
%     sigmaCell=getSigma4ParametricHMM(cellSet2SigmaCHMM, zSet);
% 
%     for q = 1:Q
%         Sigma1(:,:,q,1) = sigmaCell{q,1};
%     end
% 
%     %= definition a control signal, which contains all the contextual
%     %= information

%     %% compute loglik of FPHMM with respect to training data
%     contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet});
%     [ loglik, errors, gammaSet,obslikSet] = contextualhmm_logprob( data, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
%     likStateSet_contextual = {nex,1};
%     for i = 1:nex
%         tempOb = obslikSet{i,1};
%         [maxValue, maxLikState] = max(tempOb,[],1);
%         likStateSet_contextual{i,1} = [maxValue; maxLikState];
%     end
% 
%     fprintf(1, 'contextual HMM, loglik = %f\n', loglik);

%% modify
    hmmParameterSet = struct('prior1', prior1, 'transmat1', transmat1, 'mu1', mu1, 'Sigma1', Sigma1, 'mixmat1', mixmat1);
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1, zSet] = phmm_em(data, thetasSet, gammaSet, hmmParameterSet, 'transitionLeft2Right', left2rightHMMtopology, 'max_iter', 1, 'thresh', 1e-4, 'verbose', 1);
    contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet});

%% testing FPHMM performance on emotion classification

    numTestSize = size(testingSet,1);
    prdtLabelCell_FPHMM{indexName,1} = cell(size(testingSet)); %inferred emotion label for each test sequence.
    FPHMMCell = cell(6,1);
    FPHMMCell{1,1} = prior1;
    FPHMMCell{2,1} = transmat1;
    FPHMMCell{3,1} = mu1;
    FPHMMCell{4,1} = Sigma1;
    FPHMMCell{5,1} = mixmat1;
    FPHMMCell{6,1} = contextualSignal;
    for i = 1:numTestSize
        prdtLabelCell_FPHMM{indexName,1}{i,1} = cell(size(testingSet{i,1})); 
        for j = 1:size(testingSet{i,1},1)
            [prdtlabel,maxloglik] = recognitionEmotion_FPHMM(testingSet{i,1}{j,1},FPHMMCell);
            prdtLabelCell_FPHMM{indexName,1}{i,1}{j,1} = prdtlabel;
            prdtLabelCell_FPHMM{indexName,1}{i,1}{j,2} = maxloglik;

        end
    end
    
    %% === output measures and plot related measures === %%
    [numCorLabCell_FPHMM(indexName,:),numSeqCell_FPHMM(indexName,:)] = countNums(prdtLabelCell_FPHMM{indexName,1},testingSet);
    [numCorLabCell_HMM(indexName,:),numSeqCell_HMM(indexName,:)] = countNums(prdtLabelCell_HMM{indexName,1},testingSet);

    
%     [precisionOneEm_FPHMM , precision_FPHMM] = precisionEstimation(prdtLabelCell_FPHMM,testingSet);
%     [precisionOneEm_HMM , precision_HMM] = precisionEstimation(prdtLabelCell_HMM,testingSet);
    % [predictionRate] = prediction_rating(prdtLabelCell_FPHMM,testingSet);
    % for i = 1:numEmotion
    %     fprintf(1, 'prediction rate of %s is %f', labels(1,i),loglipredictionRate(1,i));
    % end
end

%% compute precision %%
%HMM
numCorLbArrayAllEmotion_HMM = sum(numCorLabCell_HMM,1);
numSeqArrayAllEmotion_HMM = sum(numSeqCell_HMM,1);
precisionArray_HMM = transpose(numCorLbArrayAllEmotion_HMM./numSeqArrayAllEmotion_HMM);
precision_HMM = transpose(sum(numCorLbArrayAllEmotion_HMM)/sum(numSeqArrayAllEmotion_HMM));

%FPHMM
numCorLbArrayAllEmotion_FPHMM = sum(numCorLabCell_FPHMM,1);
numSeqArrayAllEmotion_FPHMM = sum(numSeqCell_FPHMM,1);
precisionArray_FPHMM =transpose( numCorLbArrayAllEmotion_FPHMM./numSeqArrayAllEmotion_FPHMM);
precision_FPHMM = transpose(sum(numCorLbArrayAllEmotion_FPHMM)./sum(numSeqArrayAllEmotion_FPHMM));

































