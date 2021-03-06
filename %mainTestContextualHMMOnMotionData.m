%Modified by WANG Qi for Emilya dataset in 11,Oct,2015

close all
clear all
clc

path0 = '/Users/qiwang/Documents/matlab projects/';
addpath(genpath(strcat(path0,'fullyParameterizedHMM/HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM/ContextualModel')));

%% ==== prepare the dataset ===== %%
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Being Seated'
% fileName = char('/Anger/Brian/Ag1BS1_BrianAngleAxisData.mat','/Anger/Brian/Ag1BS2_BrianAngleAxisData.mat',...
%     '/Sadness/Brian/Sd1BS1_BrianAngleAxisData.mat','/Sadness/Brian/Sd1BS2_BrianAngleAxisData.mat',...
%     '/Joy/Brian/Jy1BS1_BrianAngleAxisData.mat','/Joy/Brian/Jy1BS2_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF2BS1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2BS2_BrianAngleAxisData.mat');

% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Simple Walk';
% fileName = char('/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat','/Anger/Brian/Ag1SW2_BrianAngleAxisData.mat',...
%     '/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat','/Joy/Brian/Jy1SW2_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF1SW1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF1SW2_BrianAngleAxisData.mat');
dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction';
fileName = char('/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
                '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
                '/Simple Walk/Sadness/Brian/Sd1SW1_BrianAngleAxisData.mat',...
                '/Simple Walk/Sadness/Brian/Sd1SW1_BrianAngleAxisData.mat',...    
                '/Simple Walk/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat',...
                '/Simple Walk/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat',...    
                '/Throw/Anger/Brian/Ag1Th1_BrianAngleAxisData.mat',...
                '/Throw/Anger/Brian/Ag1Th1_BrianAngleAxisData.mat',...
                '/Throw/Sadness/Brian/Sd1Th1_BrianAngleAxisData.mat',...
                '/Throw/Sadness/Brian/Sd1Th1_BrianAngleAxisData.mat',... 
                '/Throw/Joy/Brian/Jy1Th1_BrianAngleAxisData.mat',...
                '/Throw/Joy/Brian/Jy1Th1_BrianAngleAxisData.mat',...
                '/Move Books/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat',...
                '/Move Books/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat',...    
                '/Move Books/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat',...
                '/Move Books/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat');

            
            %                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat',...
%                 '/Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat');
                

% fileName = char('/Anger/Brian/Ag1BS1_BrianAngleAxisData.mat',8);
if 1
   nex = size(fileName,1);
%  nex = 1;
  M = 1;
  Q = 10;
else
  O = 8;          %Number of coefficients in a vector 
  T = 420;         %Number of vectors in a sequence 
  nex = 1;        %Number of sequences 
  M = 1;          %Number of mixtures 
  Q = 4;          %Number of states 
end
% w = [2;1;2;3];
% u_bar = [1;2;1;2];
% dimCV = size(thetas, 1);
% dimOb = size(data,1);
% w = zeros(dimOb, dimCV);
% u_bar = zeros(dimOb,1);
% T=0;
% totalT=0;
% for i = 1:nex
%     [anglesData,origin,O,t] = importMotionData(strcat(dataSetPath,fileName(i,:)));
%     totalT =totalT+ t;
% end
data0 = []; 
data = cell(nex,1);
thetasSet = cell(nex,1);
for i = 1:nex
    [anglesData,origin,O,t] = importMotionData(strcat(dataSetPath,fileName(i,:)));
    cov_type = 'full';
    
    
    if (i == 1||i== 2)
% %             tmpVector = [1;rand(1,1);rand(1,1);rand(1,1)];
%             tmpVector = [exp(1);exp(rand(1,1)*0.5);exp(rand(1,1)*0.5);exp(rand(1,1)*0.5)];
%             tmpVector = tmpVector./sum(tmpVector); 
            tmpVector = [1+rand;1+rand];
            thetas = repmat(tmpVector,1,t);
            
    elseif (i== 3||i== 4)
%               tmpVector = [rand(1,1);1;rand(1,1);rand(1,1)];
%             tmpVector = [exp(rand(1,1)*0.5);exp(1);exp(rand(1,1)*0.5);exp(rand(1,1)*0.5)];
%             tmpVector = tmpVector./sum(tmpVector);
            tmpVector = [1+rand;2+rand];
            thetas = repmat(tmpVector,1,t);
 
    elseif (i==5||i== 6)
%             tmpVector = [rand(1,1);rand(1,1);1;rand(1,1)];
%             tmpVector = [exp(rand(1,1))*0.5;exp(rand(1,1)*0.5);exp(1);exp(rand(1,1)*0.5)];
%             tmpVector = tmpVector./sum(tmpVector);
            tmpVector = [1+rand;3+rand];
            thetas = repmat(tmpVector,1,t);
 
         
     elseif (i==7||i== 8)
% %               tmpVector = [rand(1,1);rand(1,1);rand(1,1);1];
% %             tmpVector = [exp(rand(1,1)*0.5);exp(rand(1,1)*0.5);exp(rand(1,1)*0.5);exp(1)];
% %             tmpVector = tmpVector./sum(tmpVector);
            tmpVector = [2+rand;1+rand];
            thetas = repmat(tmpVector,1,t);
    elseif (i==9||i== 10)
            tmpVector = [2+rand;2+rand];
            thetas = repmat(tmpVector,1,t);        
         
    elseif (i==11 ||i== 12)
            tmpVector = [2+rand;3+rand];
            thetas = repmat(tmpVector,1,t);  
    elseif (i==13||i== 14)
            tmpVector = [3+rand;1+rand];
            thetas = repmat(tmpVector,1,t);  
    elseif (i==15||i== 16)
            tmpVector = [3+rand;2+rand];
            thetas = repmat(tmpVector,1,t);  
    end
    thetasSet{i,1} = thetas;
    data{i,1} = anglesData+rand(size(anglesData));
    data0 = [data0,data{i,1}];
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

[loglik, errors, gammaSet,alphaSet,betaSet,obslikSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
%= gammaSet = cell(ncases,1); each case is a gamma(i,t)
%= gamma(i,t) = p(Q(t)=i | y(1:t))
likStateSet = {nex,1};
for i = 1:nex
    tempOb = obslikSet{i,1};
    [maxValue, maxLikState] = max(tempOb, [],1);
    likStateSet{i,1} = [maxValue; maxLikState];
end

%% ===== train contextual HMM ====== %%
%== prepare dataset for training contextual HMM

%== build a set for training contextual HMM
cellSet2CHMM = cell(3,Q,nex); 
%=3 means: observation, contextual parameters, gamma (state occupany probability)
for ex = 1:nex
    for q = 1:Q
        cellSet2CHMM{1,q,ex} = data{ex,1};
        cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
        cellSet2CHMM{3,q,ex} = gammaSet{ex,1}(q,:);
        if(cellSet2CHMM{3,q,ex} == gammaSet{ex,1}(q,:))
            continue
        else
            sprintf('%d\n',cellSet2CHMM{3,q,ex});
            sprintf('%d\n',gammaSet{ex,1}(q,:));
            break
        end
        
    end
end
% for ex = 1:nex
%     for q = 1:Q
%         if(cellSet2CHMM{3,q,ex} == gammaSet{nex,1}(q,:))
%             continue
%         else
%             sprintf('%d\n',cellSet2CHMM{3,q,ex});
%             sprintf('%d\n',gammaSet{nex,1}(q,:));
%             break
%         end
%     end
% end
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
sdaf
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


