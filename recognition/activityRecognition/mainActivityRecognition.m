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
isNormalized = 1;
%%==== variables definitions ===== %%
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
% activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};
% activityCell = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
activityCell = {'Simple Walk','Walk with smth in the Hands'};
% Names = {'Brian','Elie','Florian','Hu'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica'};
Names = {'Brian'};
% Names = {'Brian','Elie','Florian','Hu','Janina','Jessica','Maria','Muriel','Robert','Sally','Samih','Tatiana'}
%Robert: only few sequences
numActivity = length(activityCell);
numEmotion = length(emotionCell);

%%prepare dataset for training HMM and FPHMM %%
allDataCell = cell(numActivity,numEmotion);
allData = [];
[allDataCell, allData] = preproData_AcRg(activityCell,emotionCell,Names);

if isPCA
    dim = 16;
    [allDataCell, allData] = PCA_allData(allDataCell,allData,dim);
end


%%divide dataset into training and testing set.
K = 6; %num of partitions of dataset for cross validation.

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
            indTraining = currentFold.training(indFold);
    %         indTesting = currentFold.test(indFold);
            tmpTrainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
    %         testingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
        end
    end
    K_TrainingSet{indFold,1} = tmpTrainingSet;
    

end

%% Training HMM
indFold = 1;
K_CV_HMMCell = cell(K,1);
for indFold = 1:K
fprintf('IndFolde =%d',indFold);
%%prepare training set and testing set%%
% trainingSet = cell(numActivity,numEmotion);
% testingSet = cell(numActivity,numEmotion);
% parfor indAct = 1:numActivity
%     for indEm = 1:numEmotion
%         currentFold = KFolders{indAct,indEm};
%         indTraining = currentFold.training(indFold);
% %         indTesting = currentFold.test(indFold);
%         trainingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTraining,:);
% %         testingSet{indAct,indEm} = allDataCell{indAct,indEm}(indTesting,:);
%     end
% end
trainingSet = K_TrainingSet{indFold,1};
%%training conventional HMM for each activity and emotion pair%%
numStates = 8;%8
numMix = 1;
max_iter = 10;
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

%%save all data here

K_CV_HMMCell{indFold,1} = HMMCell;

end

%% training FPHMM
K_CV_FPHMMCell = cell(K,1);

for indFold = 1:K

trainingSet = K_TrainingSet{indFold,1};
numStates = 8;%8
numMix = 1;
% max_iter = 10;
mxIter_FPHMM = 4;
FPHMM_HMM_init_Iter = 3;    
%%counting sample numbers
%count the sequence number of each activity
totalNumTraining = zeros(numActivity,1);
parfor indAct = 1:numActivity
    for indEm = 1: numEmotion
        totalNumTraining(indAct,1) = totalNumTraining(indAct,1) + size(trainingSet{indAct,indEm},1);
    end    
end
%%training a FPHMM for each activity %%
%define dimension of theta
theta_dim = 2;
contextualVector = cell(numEmotion,1);% save thetas values
contextualVector{1,1} = [0.8;0.2];
contextualVector{2,1} = [0.6;0.4];
contextualVector{3,1} = [0.4;0.6];
contextualVector{4,1} = [0.2;0.8];
contextualVector{5,1} = [-0.2;-0.8];
contextualVector{6,1} = [-0.4;-0.6];
contextualVector{7,1} = [-0.6;-0.4];
contextualVector{8,1} = [-0.8;-0.2];

% contextualVector{1,1} = [0.8477;-0.3622];
% contextualVector{2,1} = [0.0712;-0.1882];
% contextualVector{3,1} = [0.7215;-0.2533];
% contextualVector{4,1} = [0.8563;1];
% contextualVector{5,1} = [0.4747;-1];
% contextualVector{6,1} = [1;0.2450];
% contextualVector{7,1} = [-1;-0.8709];
% contextualVector{8,1} = [-0.6100;-0.4065];

FPHMMCell = cell(numActivity,1);

priorCell = cell(numActivity,1);
gammaCell = cell(numActivity,1);
WCell = cell(numActivity,1);
SigmaCell = cell(numActivity,1);
muCell = cell(numActivity,1);
transmatCell = cell(numActivity,1);
mixmatCell = cell(numActivity,1);
zSetCell = cell(numActivity,1);
dataCell = cell(numActivity,1);
previous_loglik = repmat(-inf,[numActivity,1]);
loglik = zeros(numActivity,1);
indIteration = 1;
converged = 0;
thetasIterationCell = cell(numActivity,numEmotion);

while (indIteration <= mxIter_FPHMM) &&  ~converged
    fprintf('Iteration %d :compute W ...\n',indIteration);
    for indAct = 1:numActivity
        fprintf('indAct is %d',indAct);
        if indIteration == 1
            %initialize all parameters
            disp('Initialize all parameters for each FPHMM or each Activity in the first iteration');
            tmpContexutalVector = contextualVector;
            nex = totalNumTraining(indAct,1);
            data = cell(nex,1);
            data0 = [];
            thetasSet = cell(nex,1);
            index = 0;
            
            for indEm = 1:numEmotion
                curNumFl = size(trainingSet{indAct,indEm},1);
                for indFl =1:curNumFl
                    index = index +1;
                    curEmotion = trainingSet{indAct,indEm}{indFl,2};
                    t = size(trainingSet{indAct,indEm}{indFl,1},2);
                    tmpVector = getContexutalVector(curEmotion,tmpContexutalVector);%get thetas value
                    thetas = repmat(tmpVector,1,t);
                    thetasSet{index,1} = thetas;
                    data{index,1} = trainingSet{indAct,indEm}{indFl,1};
                    data0 = [data0,data{index,1}];
                end
            end
            

            Q = numStates;%state number
            M =numMix;%number of mixtures
            O = size(data0,1);%dimension of observation data
            cov_type = 'full';% type of covariance matrix
           
            prior0 = normalise(rand(Q,1));
            if left2rightHMMtopology ==0
                transmat0 = mk_stochastic(rand(Q,Q));
            else
                disp('!!!!!!!!!!Warning: using Left2Right HMM!!!!!!!!');
                transmat0 = diag(0.5.*ones(Q,1))+[[zeros(Q-1,1) diag(0.5.*ones(Q-1,1))];zeros(1,Q)];
            end

            [mu0, Sigma0] = mixgauss_init(Q*M, data0, cov_type);%initialized mean(mu) and covariance(sigma)  
            mu0 = reshape(mu0, [O Q M]);
            Sigma0 = reshape(Sigma0, [O O Q M]);
            mixmat0 = mk_stochastic(rand(Q,M));
            mixmat0 = normalise(mixmat0,2);% initialized transmit probability matrix

            %%training a conventional HMM%%
            disp('train a conventional HMM')
%             iter = max_iter;
            [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
                mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', FPHMM_HMM_init_Iter);
            [loglik(indAct,1), errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
            previous_loglik(indAct,1) = loglik(indAct,1);
            disp('initialization finishing, saving all the initialized parameters...')

            priorCell{indAct,1} = prior1;
            SigmaCell{indAct,1} = Sigma1;
            gammaCell{indAct,1} = gammaSet;
            muCell{indAct,1} = mu1;
            transmatCell{indAct,1} = transmat1;
            mixmatCell{indAct,1} = mixmat1;
            dataCell{indAct,1} = data;
        else
            %
            priorCell{indAct,1} = priorCell{indAct,1};
            SigmaCell{indAct,1} = SigmaCell{indAct,1};
            gammaCell{indAct,1} = gammaCell{indAct,1};
            muCell{indAct,1} = muCell{indAct,1};
            transmatCell{indAct,1} = transmatCell{indAct,1};
            mixmatCell{indAct,1} = mixmatCell{indAct,1};
            dataCell{indAct,1} = dataCell{indAct,1};
            
            
            nex = totalNumTraining(indAct,1);
            tmpContexutalVector = contextualVector;
            thetasSet = cell(nex,1);
            index = 0;
            for indEm = 1:numEmotion
                curNumFl = size(trainingSet{indAct,indEm},1);
                for indFl =1:curNumFl
                    index = index +1;
                    curEmotion = trainingSet{indAct,indEm}{indFl,2};
                    t = size(trainingSet{indAct,indEm}{indFl,1},2);
                    tmpVector = getContexutalVector(curEmotion,tmpContexutalVector);%get thetas value
                    thetas = repmat(tmpVector,1,t);
                    thetasSet{index,1} = thetas;
                end
            end
            
            %update Sigma
            SigmaCell{indAct,1} = updateSigmaOfParametricHMM( dataCell{indAct,1}, thetasSet, gammaCell{indAct,1}, zSetCell{indAct,1} );
            %update gamma
            contextualSignal = struct('contextualMean', 1, 'zSet', zSetCell(indAct,1), 'thetasSet', {thetasSet}, 'transitionLeft2Right',left2rightHMMtopology);
            [ loglik(indAct,1), errors, gammaCell{indAct,1}, transmatCell{indAct,1}] = hmm_logprob_pHMM( dataCell{indAct,1}, priorCell{indAct,1}, transmatCell{indAct,1}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1}, contextualSignal );
            fprintf(1, 'thetas, iteration %d, loglik = %f\n', indIteration, loglik(indAct,1));
            converged = em_converged(loglik(indAct,1), previous_loglik(indAct,1),1e-4);
            previous_loglik(indAct,1) = loglik(indAct,1);
            

        
        end%if indIteration ==1
        
        %compute W for each activity
        disp('compute W for each activity');
        fprintf('Iteration %d: compute W for activity %d\n',indIteration,indAct);
        hmmParameterSet = struct('prior1', priorCell{indAct,1}, 'transmat1', transmatCell{indAct,1}, 'mu1', muCell{indAct,1}, 'Sigma1', SigmaCell{indAct,1}, 'mixmat1', mixmatCell{indAct,1});

        [LL, priorCell{indAct,1},transmatCell{indAct,1},muCell{indAct,1},SigmaCell{indAct,1}, mixmatCell{indAct,1}, WCell{indAct,1}, zSetCell{indAct,1}] = ...
            computeWmatrix(dataCell{indAct,1},thetasSet,gammaCell{indAct,1},hmmParameterSet,'transitionLeft2Right', left2rightHMMtopology,'verbose', 1);
        %update gamma
        contextualSignal = struct('contextualMean', 1, 'zSet', zSetCell(indAct,1), 'thetasSet', {thetasSet}, 'transitionLeft2Right',left2rightHMMtopology);
        [ loglik(indAct,1), errors, gammaCell{indAct,1}, transmatCell{indAct,1}] = hmm_logprob_pHMM( dataCell{indAct,1}, priorCell{indAct,1}, transmatCell{indAct,1}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1}, contextualSignal );
        fprintf(1, 'W, iteration %d, loglik = %f\n', indIteration, loglik(indAct,1));
        converged = em_converged(loglik(indAct,1), previous_loglik(indAct,1),1e-4);
        previous_loglik(indAct,1) = loglik(indAct,1);
        
        
        if indIteration == mxIter_FPHMM || converged
            contextualSignal = struct('contextualMean', 1, 'zSet', zSetCell(indAct,1), 'thetasSet', {thetasSet});
            %save all the parameters of trained FPHMM model
            disp('saving FPHMM parameters... ... ...');
            FPHMMCell{indAct,1} = cell(8,1);
            FPHMMCell{indAct,1}{1,1} = priorCell{indAct,1};
            FPHMMCell{indAct,1}{2,1} = transmatCell{indAct,1};
            FPHMMCell{indAct,1}{3,1} = muCell{indAct,1};
            FPHMMCell{indAct,1}{4,1} = SigmaCell{indAct,1};
            FPHMMCell{indAct,1}{5,1} = mixmatCell{indAct,1};
            FPHMMCell{indAct,1}{6,1} = contextualSignal;
            FPHMMCell{indAct,1}{7,1} = contextualVector;
            FPHMMCell{indAct,1}{8,1} = thetasIterationCell;
        end
       
    end%indAct
    
    if indIteration == mxIter_FPHMM || converged 
        if converged
            disp('converged.');
        else
            disp('reach to max iteration.')
        end
        break;
    end
    
    Q = numStates;
    %compute theta vector for each emotion
    fprintf('Iteration %d: compute thetas\n',indIteration);
    index_front = zeros(numActivity,1);
    index_back = zeros(numActivity,1);
    for indEm = 1:numEmotion

        tmpThetasTerm1 = zeros(theta_dim,theta_dim);
        tmpThetasTerm2 = zeros(theta_dim,1);
        parfor indAct = 1:numActivity
            tmpData = trainingSet{indAct,indEm}(:,1); % compute data
            curNumFiles = size(tmpData,1)
            index_front(indAct,1) = index_back(indAct,1)+ 1;
            index_back(indAct,1) = index_back(indAct,1) + curNumFiles;
            gammaSetOfOneEmotion = gammaCell{indAct,1}(index_front(indAct,1):index_back(indAct,1),1);
            cellSet2CHMM = cell(2,Q,curNumFiles);
            size(gammaSetOfOneEmotion)
            for ex = 1:curNumFiles
                for q = 1:numStates
                    cellSet2CHMM{1,q,ex} = tmpData{ex,1};
                    %=cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
                    cellSet2CHMM{2,q,ex} = gammaSetOfOneEmotion{ex,1}(q,:);
                end
            end
            wSet = WCell{indAct,1};
            commonMean = muCell{indAct,1};
            Sigma = SigmaCell{indAct,1};
            invOfSigma = cell(size(Sigma,3),1);
            for i = 1:size(Sigma,3)
                invOfSigma{i,1} = inv(Sigma(:,:,i,1)); 
            end
            disp('copmute theta with C ++')
            thetasCell = getElements4CalculateThetaofCommonMeanParametricHMM(cellSet2CHMM,wSet,commonMean,invOfSigma);
            tmpThetasTerm1 = tmpThetasTerm1 + thetasCell{1,1};
            tmpThetasTerm2 = tmpThetasTerm2 + thetasCell{2,1};
        end%indAct

        %saving learned thetas
        contextualVector{indEm,1} = tmpThetasTerm1^-1 * tmpThetasTerm2;
        thetasIterationCell{indIteration,indEm} = contextualVector{indEm,1};
    end%indEm
    %normalize thetas
    thetasMat = zeros(theta_dim, numEmotion);
    for indEm = 1:numEmotion
        thetasMat(:,indEm) = contextualVector{indEm,1};
    end
    
    if isNormalized == 1
        for index = 1:theta_dim
            thetasMat(index,:) = normalize_var(thetasMat(index,:),-1,1);
        end
    end
    for indEm =1:numEmotion
        contextualVector{indEm,1} = thetasMat(:,indEm);
    end
    if isNormalized ==1
        fprintf('Iteration%d : Theta(Normalized): \n',indIteration);
    else
        fprintf('Iteration%d : Theta(Unnormalized): \n',indIteration);
    end
    for indEm =1:numEmotion
    fprintf('%s:[%.4f,%.4f]\n',emotionCell{indEm},contextualVector{indEm,1}(1),contextualVector{indEm,1}(2));
%     fprintf('%s:[%.4f]\n',emotionCell{indEm},contextualVector{indEm,1}(1));
    end
    
    %plot theta in a figure
    figure;
    scatter(thetasMat(1,:),thetasMat(2,:));
    title(['Fold ',num2str(indFold),', Iteration is ',num2str(indIteration),' thetas Values']);
    axis([-1.5,1.5,-1.5,1.5]);
    for indEm = 1:numEmotion
        str = emotionCell{indEm};
        x0 = contextualVector{indEm,1}(1)+0.03;
        y0 = contextualVector{indEm,1}(2);
        text(x0,y0,str,'HorizontalAlignment','left','FontSize',12,'Color','Blue');
    end
    
indIteration = indIteration + 1;    
end%indIteration


%%save FPHMM for each fold

K_CV_FPHMMCell{indFold,1} = FPHMMCell;


end


























