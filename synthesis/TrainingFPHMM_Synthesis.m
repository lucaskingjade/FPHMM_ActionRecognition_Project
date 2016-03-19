
%% training FPHMM
% max_iter = 10;
%%counting sample numbers
%count the sequence number of each activity
totalNumTraining = zeros(numActivity,1);
parfor indAct = 1:numActivity
    for indEm = 1: numEmotion
        if ~iscell(TrainDataSet{indAct,indEm})
            continue;
        end
        totalNumTraining(indAct,1) = totalNumTraining(indAct,1) + size(TrainDataSet{indAct,indEm},1);
    end    
end
%%
%%training a FPHMM for each activity %%
%define dimension of theta
initTheta =contextualVector;

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
                if ~iscell(TrainDataSet{indAct,indEm})
                    continue;
                end
                curNumFl = size(TrainDataSet{indAct,indEm},1);
                for indFl =1:curNumFl
                    index = index +1;
                    curEmotion = TrainDataSet{indAct,indEm}{indFl,2};
                    t = size(TrainDataSet{indAct,indEm}{indFl,1},2);
                    tmpVector = getContexutalVector(curEmotion,tmpContexutalVector,emotionCell);%get thetas value
                    thetas = repmat(tmpVector,1,t);
                    thetasSet{index,1} = thetas;
                    data{index,1} = TrainDataSet{indAct,indEm}{indFl,1};
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
%             clear data0
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
                if ~iscell(TrainDataSet{indAct,indEm})
                    continue;
                end
                curNumFl = size(TrainDataSet{indAct,indEm},1);
                for indFl =1:curNumFl
                    index = index +1;
                    curEmotion = TrainDataSet{indAct,indEm}{indFl,2};
                    t = size(TrainDataSet{indAct,indEm}{indFl,1},2);
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
%         hmmParameterSet = struct('prior1', priorCell{indAct,1}, 'transmat1', transmatCell{indAct,1}, 'mu1', muCell{indAct,1}, 'Sigma1', SigmaCell{indAct,1}, 'mixmat1', mixmatCell{indAct,1});
        %whether we can change the function computeWmatrix to a nested
        %function
%         [LL, priorCell{indAct,1},transmatCell{indAct,1},muCell{indAct,1},SigmaCell{indAct,1}, mixmatCell{indAct,1}, WCell{indAct,1}, zSetCell{indAct,1}] = ...
%             computeWmatrix(dataCell{indAct,1},thetasSet,gammaCell{indAct,1},hmmParameterSet,'transitionLeft2Right', left2rightHMMtopology,'verbose', 1);
%% unfold the function computeWmatrix to scripts
        
% function [ LL, prior1, transmat1, commonMean, Sigma1, mixmat1,wSet, zSet] = computeWmatrix( dataCell{indAct,1},thetasSet, gammaCell{indAct,1}, hmmParameterSet, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% [transitionLeft2Right, verbose] = ...
%         process_options(varargin, 'transitionLeft2Right', 0,'verbose', 1);

%     prior1 = hmmParameterSet.prior1;
%     transmat1 = hmmParameterSet.transmat1;
%     mu1 = hmmParameterSet.mu1;
%     Sigma1 = hmmParameterSet.Sigma1;
%     mixmat1 = hmmParameterSet.mixmat1;
%     commonMean = mu1;%mu won't vary
    loglik = 0;
    LL = [];    
%     [zSet,wSet Sigma1] = pHMM_commonMeanVector(data, thetasSet, gammaSet, mu1);
% function [ zSet,wSet, Sigma1 ] = pHMM_commonMeanVector( data, thetasSet, gammaSet, mu1 )
tmpnex = length(dataCell{indAct,1});
tmpQ = size(gammaCell{indAct,1}{1,1},1);
%== build a set for training contextual HMM
cellSet2CHMM = cell(3,tmpQ,tmpnex); 
%=3 means: observation, contextual parameters, gamma (state occupany probability)
for ex = 1:tmpnex
    for q = 1:tmpQ
        cellSet2CHMM{1,q,ex} = dataCell{indAct,1}{ex,1};
        cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};];
        cellSet2CHMM{3,q,ex} = gammaCell{indAct,1}{ex,1}(q,:);
    end
end
disp('begin use C++ to compute W\n')
tic
tempContextualHMM = getElements4CalculateWofCommonMeanParametricHMM(cellSet2CHMM, muCell{indAct,1});
toc
disp('finishi computation of W\n')
%%??why we don't update prior,transmat,???
%%get Z
WCell{indAct,1} = cell(Q,1);
zSetCell{indAct,1} = cell(Q,1);
for q = 1:Q
    o_omega = tempContextualHMM{q,1};
    omega_omega = tempContextualHMM{q,2};
    WCell{indAct,1}{q,1} = o_omega*(omega_omega^(-1));
    zSetCell{indAct,1}{q,1} = [WCell{indAct,1}{q,1} muCell{indAct,1}(:,q)]; %% it will be used to update sigam
end
%update Sigma of Parametric CHMM

% SigmaCell{indAct,1} = updateSigmaOfParametricHMM( dataCell{indAct,1}, thetasSet, gammaCell{indAct,1}, zSetCell{indAct,1} );
%% unfold the function updateSigmaOfParametricHMM
% function [ Sigma1 ] = updateSigmaOfParametricHMM( data, thetasSet, gammaSet, zSet )
%= re-estimate SIGMA (covariance matrix)
% prepare dataset to re estimate SIGMA
% mex getSigma4ParametricHMM.cpp

tmpnex = length(dataCell{indAct,1});
tmpQ = size(gammaCell{indAct,1}{1,1},1);

cellSet2SigmaCHMM = cell(3,tmpQ,tmpnex); 
%=3 means: observation, contextual parameters, gamma (state occupany probability)
for ex = 1:tmpnex
    for q = 1:tmpQ
        cellSet2SigmaCHMM{1,q,ex} = dataCell{indAct,1}{ex,1};
        cellSet2SigmaCHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
        cellSet2SigmaCHMM{3,q,ex} = gammaCell{indAct,1}{ex,1}(q,:);
    end
end
disp('begin to update Sigma\n');
tic
tmpsigmaCell=getSigma4ParametricHMM(cellSet2SigmaCHMM, zSetCell{indAct,1});
toc
disp('finish updating Sigma\n')
for q = 1:tmpQ
    SigmaCell{indAct,1}(:,:,q,1) = tmpsigmaCell{q,1};
end


% end




%%

%  
%     contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet}, 'transitionLeft2Right',transitionLeft2Right);
%     [ loglik, errors, gammaSet, transmat1] = hmm_logprob_pHMM( dataCell{indAct,1}, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
%     LL = [LL loglik];


        
       
        
        %@#$T&T@#&*$T&*@#$&*^@#&$*(@^#$&*^@#$&*^@#*&$^(*&@#^$*&@#
        %RYEWURYIEW&@#*($&*#@&$*(@#&$*(#&@(*$&(*#@&$(*#@&*($&#(@*&$*(&#@
        %$#&@($&*(#@&$*(#@&$*(&#@*($&(*@#&$*(#@&$*(@&#*$&(*@#&$*(&@#*($&(@#$&
        
        %% 
        
        
        %update gamma
        disp('begin to update gamma')
        contextualSignal = struct('contextualMean', 1, 'zSet', zSetCell(indAct,1), 'thetasSet', {thetasSet}, 'transitionLeft2Right',left2rightHMMtopology);
        tic
        [ loglik(indAct,1), errors, gammaCell{indAct,1}, transmatCell{indAct,1}] = hmm_logprob_pHMM( dataCell{indAct,1}, priorCell{indAct,1}, transmatCell{indAct,1}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1}, contextualSignal );
        toc
        %% unfold the function hmm_logprob_pHMM
%         tic
% 
% %= consider variable mean
% contextualMean = 1;
% transitionLeft2Right = left2rightHMMtopology;
% M = size(mixmatCell{indAct,1},2);
% tmpQ = length(priorCell{indAct,1});
% if size(mixmatCell{indAct,1},1) ~= tmpQ % trap old syntax
%   error('mixmat should be QxM')
% end
% % if ~iscell(dataCell{indAct,1})
% %   dataCell{indAct,1} = num2cell(dataCell{indAct,1}, [1 2]); % each elt of the 3rd dim gets its own cell
% % end
% ncases = length(dataCell{indAct,1});
% %= by Yu
% gammaCell{indAct,1} = cell(ncases,1);
% exp_num_trans = zeros(tmpQ,tmpQ);
% 
% loglik(indAct,1) = 0;
% errors = [];
% for m=1:ncases
%     if contextualMean == 0
%         obslik = mixgauss_prob(dataCell{indAct,1}{m}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1});
%     else
%         %= getContextualMean();
%         %= [d Q T M] = size(mu);
%         [d, T] = size(dataCell{indAct,1}{m});
%         M = 1;% hypothese
%         muCell{indAct,1} = zeros(d, tmpQ, T, M);
%         omega = [thetasSet{m,1};ones(1,size(thetasSet{m,1},2))];
%         for t = 1:T
%             for q = 1:Q
%                 tempZ =  zSetCell{indAct,1}{q,1};
%                 tempOmega = omega(:,t);
%                 muCell{indAct,1}(:, q, t, M) = tempZ*tempOmega;
%             end
%         end
%         obslik = contextualMean_mixgauss_prob(dataCell{indAct,1}{m}, muCell{indAct,1}, SigmaCell{indAct,1}, mixmatCell{indAct,1});
%     end
%     if transitionLeft2Right == 0
%         [alpha, beta, gamma, ll, xi_summed] = fwdback(priorCell{indAct,1}, transmatCell{indAct,1}, obslik);%, 'fwd_only', 0);
%     else
%         [alpha, beta, gamma, ll, xi_summed] = fwdback_left2right(priorCell{indAct,1}, transmatCell{indAct,1}, obslik);%, 'fwd_only', 0);
%     end
%   if ll==-inf
%     errors = [errors m];
%   end
%   loglik(indAct,1) = loglik(indAct,1) + ll;
%   gammaCell{indAct,1}{m,1} = gamma;
%   exp_num_trans = exp_num_trans + xi_summed; 
% end
% transmatCell{indAct,1} = mk_stochastic(exp_num_trans);
% % end
%         
%         
%         
%         
%         
%         toc
        %@#&$*(&#$(*@#&$*(@#&*$(#@&($*&#(*@&$(*@#&$(*&@#(*$&(*@#&$(*@&#$(
        %@#$&%*(#&@%(*&#@*(%&*(#$&(*&$#(*@#&$*(&#@*$&(*@#&$(*@#&(*$#@&(*$
        
        %% 
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
            if ~iscell(TrainDataSet{indAct,indEm})
                continue;
            end
            tmpData = TrainDataSet{indAct,indEm}(:,1); % compute data
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
%             disp('copmute theta with C ++')
            thetasCell = getElements4CalculateThetaofCommonMeanParametricHMM(cellSet2CHMM,wSet,commonMean,invOfSigma);
            tmpThetasTerm1 = tmpThetasTerm1 + thetasCell{1,1};
            tmpThetasTerm2 = tmpThetasTerm2 + thetasCell{2,1};
        end%indAct
%         clear gammaSetOfOneEmotion;
%         clear tmpData;
        %saving learned thetas
        contextualVector{indEm,1} = tmpThetasTerm1^-1 * tmpThetasTerm2;
%         if indEm == 4
%             contextualVector{indEm,1} = [0.5;0.5;0.5];
%         end
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
