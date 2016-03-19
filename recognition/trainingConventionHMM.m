function [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = trainingConventionHMM(trainingData,numStates,numMixtures,max_iter,left2rightHMMtopology)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%% ==== prepare the data for conventional HMM Recognition===== %%
nex = size(trainingData,1);             %Number of training samples
M = numMixtures;                          %Number of Mixtures of Gaussian distribution
Q = numStates;                         %Number of states

data0 = [];
data = trainingData;

for i = 1:nex
    data0 =[data0,data{i,1}]; 
end
cov_type = 'full';

O = size(data0,1);


%% ===initial all parameters of HMM===%%
% initial guess of parameters
prior0 = normalise(rand(Q,1));

if left2rightHMMtopology ==0
    transmat0 = mk_stochastic(rand(Q,Q));
else
    disp('!!!!!!!!!!Warning: using Left2Right HMM!!!!!!!!');
    transmat0 = diag(0.5.*ones(Q,1))+[[zeros(Q-1,1) diag(0.5.*ones(Q-1,1))];zeros(1,Q)];
end

%initial mean and covariance by mix gaussian model
[mu0, Sigma0] = mixgauss_init(Q*M, data0, cov_type);
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = mk_stochastic(rand(Q,M));

%% ===train conventional HMM===%%
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', max_iter);

