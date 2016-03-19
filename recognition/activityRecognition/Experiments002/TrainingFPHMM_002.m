
%% training FPHMM
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
if isPrepareData  ==0
	load('dataSet_001_TrainingTest.mat');
end
%% 
%save the initialized thetas
initTheta = cell(K,1);
for i = 1:K
	initTheta{i,1} = contextualVector;
end

K_CV_FPHMMCell = cell(K,1);

for indFold = 1:K
fprintf('indFold = %d\n',indFold);
trainingSet = K_TrainingSet{indFold,1};
%%counting sample numbers
%count the sequence number of each activity
totalNumTraining = zeros(numActivity,1);
for indAct = 1:numActivity
    for indEm = 1: numEmotion
        totalNumTraining(indAct,1) = totalNumTraining(indAct,1) + size(trainingSet{indAct,indEm},1);
    end    
end
contextualVector = initTheta{indFold,1};

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
converged = zeros(numActivity,1);
thetasIterationCell = cell(mxIter_FPHMM,numEmotion);

while (indIteration <= mxIter_FPHMM) &&  ~(sum(converged)==numActivity+1)
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
                    tmpVector = getContexutalVector(curEmotion,tmpContexutalVector,emotionCell);%get thetas value
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
                    tmpVector = getContexutalVector(curEmotion,tmpContexutalVector,emotionCell);%get thetas value
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
            tmpconverged = em_converged(loglik(indAct,1), previous_loglik(indAct,1),1e-4);
            previous_loglik(indAct,1) = loglik(indAct,1);
            

        
        end%if indIteration ==1
        
        %compute W for each activity
        thetasIterationCell(indIteration,:) = contextualVector(:,1);
        disp('compute W for each activity');
        fprintf('Iteration %d: compute W for activity %d\n',indIteration,indAct);
        hmmParameterSet = struct('prior1', priorCell{indAct,1}, 'transmat1', transmatCell{indAct,1}, 'mu1', muCell{indAct,1}, 'Sigma1', SigmaCell{indAct,1}, 'mixmat1', mixmatCell{indAct,1});

        [LL, priorCell{indAct,1},transmatCell{indAct,1},muCell{indAct,1},SigmaCell{indAct,1}, mixmatCell{indAct,1}, WCell{indAct,1}, zSetCell{indAct,1}] = ...
            computeWmatrix(dataCell{indAct,1},thetasSet,gammaCell{indAct,1},hmmParameterSet,'transitionLeft2Right', left2rightHMMtopology,'verbose', 1);
        %update gamma
        contextualSignal = struct('contextualMean', 1, 'zSet', zSetCell(indAct,1), 'thetasSet', {thetasSet}, 'transitionLeft2Right',left2rightHMMtopology);
        [ loglik(indAct,1), errors, gammaCell{indAct,1}, transmatCell{indAct,1}] = hmm_logprob_pHMM( dataCell{indAct,1}, priorCell{indAct,1}, transmatCell{indAct,1}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1}, contextualSignal );
        fprintf(1, 'W, iteration %d, loglik = %f\n', indIteration, loglik(indAct,1));
        converged(indAct,1) = em_converged(loglik(indAct,1), previous_loglik(indAct,1),1e-4);
        previous_loglik(indAct,1) = loglik(indAct,1);
        
        
        if indIteration == mxIter_FPHMM || converged(indAct,1)
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
    
    if indIteration == mxIter_FPHMM || (sum(converged)==numActivity) 
        if (sum(converged) == numActivity)
            disp('converged.');
        else
            disp('reach to max iteration.')
        end
%         break;!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
		%add constrains here for some selected emotion
		%if some one emotion is fixed, then normalization wont be done in the next.
		for indEm =1:numEmotion
			if isFixed(indEm)==1;
				contextualVector{indEm,1} = initTheta{indFold,1}{indEm,1};
			    fprintf('the %dth theta are constrained\n',indEm);
				fprintf('%s:[',emotionCell{indEm});
				for ii = 1:theta_dim
				  fprintf('%.4f,',contextualVector{indEm,1}(ii));
				end
				fprintf(']\n');
			end			
	
		end	
	
%         if indEm == 4
%             contextualVector{indEm,1} = [0.5;0.5;0.5];
%         end
    end%indEm
    %normalize thetas
    thetasMat = zeros(theta_dim, numEmotion);
    for indEm = 1:numEmotion
        thetasMat(:,indEm) = contextualVector{indEm,1};
    end
    
    if isNormalized == 1 && sum(isFixed)==0 
        for index = 1:theta_dim
            thetasMat(index,:) = normalize_var(thetasMat(index,:),-1,1);
        end
    end
    for indEm =1:numEmotion
        contextualVector{indEm,1} = thetasMat(:,indEm);
    end
    if isNormalized ==1&& sum(isFixed)==0
        fprintf('Iteration%d : Theta(Normalized): \n',indIteration);
    else
        fprintf('Iteration%d : Theta(Unnormalized): \n',indIteration);
    end
    for indEm =1:numEmotion
        fprintf('%s:[',emotionCell{indEm});
        for ii = 1:theta_dim
          fprintf('%.4f,',contextualVector{indEm,1}(ii));
        end
        fprintf(']\n');
%     fprintf('%s:[%.4f,%.4f,%.4f]\n',emotionCell{indEm},contextualVector{indEm,1}(1),contextualVector{indEm,1}(2),contextualVector{indEm,1}(3));
%     fprintf('%s:[%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f]\n',emotionCell{indEm},contextualVector{indEm,1}(1),contextualVector{indEm,1}(2),contextualVector{indEm,1}(3),...
%         contextualVector{indEm,1}(4),contextualVector{indEm,1}(5),contextualVector{indEm,1}(6),contextualVector{indEm,1}(7),contextualVector{indEm,1}(8));

%     fprintf('%s:[%.4f]\n',emotionCell{indEm},contextualVector{indEm,1}(1));
    end
    
    %plot theta in a figure
%     if theta_dim == 2
%         figure;
%         scatter(thetasMat(1,:),thetasMat(2,:));
%         title(['Fold ',num2str(indFold),', Iteration is ',num2str(indIteration),' thetas Values']);
%         axis([-1.5,1.5,-1.5,1.5]);
%         for indEm = 1:numEmotion
%             str = emotionCell{indEm};
%             x0 = contextualVector{indEm,1}(1)+0.03;
%             y0 = contextualVector{indEm,1}(2);
%             text(x0,y0,str,'HorizontalAlignment','left','FontSize',12,'Color','Blue');
%         end
%     end
    
indIteration = indIteration + 1;    
end%indIteration


%%save FPHMM for each fold

K_CV_FPHMMCell{indFold,1} = FPHMMCell;


end

%%test FPHMM
%TestFPHMM
disp('FPHMM');
save('-mat7-binary','K_CV.mat','K_CV_FPHMMCell');


%fprintf('%.2f%%\n',CV_Accuracy_FPHMM_knownEm(1,10)*100);
%fprintf('%.2f%%\n',CV_Variance_FPHMM_knownEm(1,1)*100);

%fprintf('%.2f%%\n',CV_Accuracy_FPHMM_unknownEm(1,10)*100);
%fprintf('%.2f%%\n',CV_Variance_FPHMM_unknownEm(1,1)*100);

%fprintf('%d+%d iteration FPHMM',FPHMM_HMM_init_Iter,mxIter_FPHMM);
% disp('save all variables....')
% save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/Classifiers/data001/');
% save_file_name = strcat(save_path,'data001_LearnThetas_',num2str(numActivity),'Act_',num2str(numEmotion),'Em_',num2str(numStates),'St_',num2str(K),'CV_',num2str(FPHMM_HMM_init_Iter),'+',num2str(mxIter_FPHMM),'FPHMM_Classifier_AllVariables.mat');
% save(save_file_name);
% disp('Finish saving!')
% disp('Dont forget to record the result into Numbers')
