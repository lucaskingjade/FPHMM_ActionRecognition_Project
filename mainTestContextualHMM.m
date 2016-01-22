close all
clear all
clc

path0 = '/Users/qiwang/Downloads/';
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));

%% ==== prepare the dataset ===== %%
if 1
  O = 4;
  T = 10;
  nex = 50;
  M = 1;
  Q = 3;
else
  O = 8;          %Number of coefficients in a vector 
  T = 420;         %Number of vectors in a sequence 
  nex = 1;        %Number of sequences 
  M = 1;          %Number of mixtures 
  Q = 6;          %Number of states 
end
cov_type = 'full';%??diag

data0 = zeros(O,T,nex);
data = cell(nex,1);%???????feature dimension,?:frame number
thetasSet = cell(nex,1);%????:??????? dim
w = [2;1;2;3];
u_bar = [1;2;1;2];
for i = 1:nex
    thetas = 2.*randn(1,T);
    thetasSet{i,1} = thetas;
    data{i,1} = w*thetas + repmat(u_bar, 1, T);
    data{i,1} = data{i,1} + 0.2.*randn(size(data{i,1}));
    data0(:,:,i) = data{i,1};
end
% thetas = randn(2,T,nex);

% initial guess of parameters
prior0 = normalise(rand(Q,1)); 
transmat0 = mk_stochastic(rand(Q,Q));

if 0
  Sigma0 = repmat(eye(O), [1 1 Q M]);
  % Initialize each mean to a random data point
  indices = randperm(T*nex);
  mu0 = reshape(data(:,indices(1:(Q*M))), [O Q M]);
  mixmat0 = mk_stochastic(rand(Q,M));
else
  [mu0, Sigma0] = mixgauss_init(Q*M, data0, cov_type);
  mu0 = reshape(mu0, [O Q M]);
  Sigma0 = reshape(Sigma0, [O O Q M]);
  mixmat0 = mk_stochastic(rand(Q,M));
end

%% ===== train conventional HMM ====== %%
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 5);

[loglik, errors, gammaSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
%= gammaSet = cell(ncases,1); each case is a gamma(i,t)
%= gamma(i,t) = p(Q(t)=i | y(1:t))

%% ===== train contextual HMM ====== %%
%== prepare dataset for training contextual HMM

%== build a set for training contextual HMM
cellSet2CHMM = cell(3,Q,nex); 
%=3 means: observation, contextual parameters, gamma (state occupany probability)
for ex = 1:nex
    for q = 1:Q
        cellSet2CHMM{1,q,ex} = data{ex,1};
        cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
        cellSet2CHMM{3,q,ex} = gammaSet{nex,1}(q,:);
    end
end
tempContextualHMM=getElements4CalculateZofMeanParametricHMM(cellSet2CHMM);
%= tempContextualHMM is cell: stateNum * 2; 
%= For each state (row), 1st element is O_OMEGA; 2nd is OMEGA_OMEGA.

%= get Z
zSet = cell(Q,1);
for q = 1:Q
    o_omega = tempContextualHMM{q,1};
    omega_omega = tempContextualHMM{q,2};
    z = o_omega*(omega_omega^(-1));
    zSet{q,1} = z;
end

%= re-estimate SIGMA (covariance matrix)
% prepare dataset to re estimate SIGMA
% mex getSigma4ParametricHMM.cpp
sigmaCell=getSigma4ParametricHMM(cellSet2CHMM, zSet);

for q = 1:Q
    Sigma1(:,:,q,1) = sigmaCell{q,1};
end

%= definition a control signal, which contains all the contextual
%= information
contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet});
[ loglik, errors, gammaSet ] = contextualhmm_logprob( data, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
fprintf(1, 'contextual HMM, loglik = %f\n', loglik);


%= matlab version to re estimate sigma
% sigmaSet = cell(Q,1);
% for q = 1:Q
%     sigma = zeros(O,O);
%     sumGamma = 0;
%     for ex = 1:nex
%         sample = cellSet2CHMM{1,q,ex};
%         T = size(sample,2);
%         for t = 1:T
%             tempOb = sample(:,t);
%             tempZ = zSet{q,1};
%             tempOmega = cellSet2CHMM{2,q,ex}(:,t);
%             tempMu = tempZ*tempOmega;
%             tempObSubMu = (tempOb - tempMu);
%             tempSigma = tempObSubMu*(tempObSubMu');
%             tempGamma = cellSet2CHMM{3,q,ex}(t);
%             tempSigma = tempSigma.*tempGamma;
%             sigma = sigma + tempSigma;
%             sumGamma = sumGamma + tempGamma;
%         end
%     end
%     sigma = sigma./sumGamma;
%     sigmaSet{q,1} = sigma;
% end
%= it has been checked: sigmaCell = sigmaSet


