%Modified by WANG Qi for Emilya dataset in 11,Oct,2015

close all
clear all
clc

path0 = '/Users/qiwang/Documents/matlab projects/';
addpath(genpath(strcat(path0,'fullyParameterizedHMM\HMMall')));
addpath(genpath(strcat(path0,'fullyParameterizedHMM\ContextualModel')));

%% ==== prepare the dataset ===== %%
%Being Seated
% dataSetPath = 'D:\Work2012\PostDocWork\fullyParameterizedHMM\Project\CODES';
% fileName = char('/Ag1BS1_BrianAngleAxisData.mat','/Ag1BS2_BrianAngleAxisData.mat',...
%     '/Sd1BS1_BrianAngleAxisData.mat','/Sd1BS2_BrianAngleAxisData.mat',...
%     '/Jy1BS1_BrianAngleAxisData.mat','/Jy1BS2_BrianAngleAxisData.mat',...
%     '/PF2BS1_BrianAngleAxisData.mat','/PF2BS2_BrianAngleAxisData.mat');

% % Simple Walk
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Simple Walk';
% fileName = char('/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat','/Anger/Brian/Ag1SW2_BrianAngleAxisData.mat',...
%     '/Anxiety/Brian/Ax1SW1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1SW2_BrianAngleAxisData.mat', ...
%     '/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat','/Joy/Brian/Jy1SW2_BrianAngleAxisData.mat', ...
%     '/Neutral/Brian/Nt1SW1_BrianAngleAxisData.mat','/Neutral/Brian/Nt1SW2_BrianAngleAxisData.mat', ...
%     '/Panic Fear/Brian/PF1SW1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF1SW2_BrianAngleAxisData.mat');

% Move Books
dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Move Books';
fileName = char('/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
    '/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
    '/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
    '/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
    '/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat', ...
    '/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat', ...
    '/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat',...
    '/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat',...
    '/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
    '/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
    '/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
    '/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
    '/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat', ...
    '/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat', ...
    '/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat', ...
    '/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat', ...
    '/Panic Fear/Brian/PF2MB1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2MB2_BrianAngleAxisData.mat',...
    '/Panic Fear/Brian/PF2MB1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2MB2_BrianAngleAxisData.mat',...
    '/Panic Fear/Brian/PF2MB1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2MB2_BrianAngleAxisData.mat',...
    '/Panic Fear/Brian/PF2MB1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2MB2_BrianAngleAxisData.mat');


% %Sitting Down
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Sitting Down';
% fileName = char('/Anger/Brian/Ag1SD1_BrianAngleAxisData.mat','/Anger/Brian/Ag1SD2_BrianAngleAxisData.mat',...
%     '/Anger/Brian/Ag1SD3_BrianAngleAxisData.mat','/Anger/Brian/Ag1SD4_BrianAngleAxisData.mat',...
%     '/Anger/Brian/Ag2SD1_BrianAngleAxisData.mat','/Anger/Brian/Ag2SD2_BrianAngleAxisData.mat',...
%     '/Anger/Brian/Ag2SD3_BrianAngleAxisData.mat','/Anger/Brian/Ag2SD4_BrianAngleAxisData.mat',...
%     '/Anxiety/Brian/Ax1SD1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1SD2_BrianAngleAxisData.mat', ...
%     '/Anxiety/Brian/Ax1SD3_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1SD4_BrianAngleAxisData.mat', ...
%     '/Anxiety/Brian/Ax2SD1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax2SD2_BrianAngleAxisData.mat', ...
%     '/Anxiety/Brian/Ax2SD3_BrianAngleAxisData.mat','/Anxiety/Brian/Ax2SD4_BrianAngleAxisData.mat', ...
%     '/Joy/Brian/Jy1SD1_BrianAngleAxisData.mat','/Joy/Brian/Jy1SD2_BrianAngleAxisData.mat', ...
%     '/Joy/Brian/Jy1SD3_BrianAngleAxisData.mat','/Joy/Brian/Jy1SD4_BrianAngleAxisData.mat', ...
%     '/Joy/Brian/Jy2SD1_BrianAngleAxisData.mat','/Joy/Brian/Jy2SD2_BrianAngleAxisData.mat', ...
%     '/Joy/Brian/Jy2SD3_BrianAngleAxisData.mat','/Joy/Brian/Jy2SD4_BrianAngleAxisData.mat', ...
%     '/Neutral/Brian/Nt1SD1_Brian1AngleAxisData.mat','/Neutral/Brian/Nt1SD2_Brian1AngleAxisData.mat', ...
%     '/Neutral/Brian/Nt1SD3_Brian1AngleAxisData.mat','/Neutral/Brian/Nt2SD1_BrianAngleAxisData.mat', ...
%     '/Neutral/Brian/Nt1SD1_Brian2AngleAxisData.mat','/Neutral/Brian/Nt2SD2_BrianAngleAxisData.mat', ...
%     '/Neutral/Brian/Nt2SD3_BrianAngleAxisData.mat','/Neutral/Brian/Nt2SD4_BrianAngleAxisData.mat', ...
%     '/Panic Fear/Brian/PF2SD1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2SD2_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF2SD3_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2SD4_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF3SD1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF3SD2_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF3SD3_BrianAngleAxisData.mat','/Panic Fear/Brian/PF3SD4_BrianAngleAxisData.mat');

% fileName = char('/Anger/Brian/Ag1BS1_BrianAngleAxisData.mat','/Anger/Brian/Ag1BS2_BrianAngleAxisData.mat',...
%     '/Sadness/Brian/Sd1BS1_BrianAngleAxisData.mat','/Sadness/Brian/Sd1BS2_BrianAngleAxisData.mat',...
%     '/Joy/Brian/Jy1BS1_BrianAngleAxisData.mat','/Joy/Brian/Jy1BS2_BrianAngleAxisData.mat',...
%     '/Panic Fear/Brian/PF2BS1_BrianAngleAxisData.mat','/Panic Fear/Brian/PF2BS2_BrianAngleAxisData.mat',...
%     '/Anxiety/Brian/Ax1BS1_BrianAngleAxisData.mat','/Anxiety/Brian/Ax1BS2_BrianAngleAxisData.mat');



% %five styles of actions: Simple Walk,Move Books,Sitting Down,Lift,Knocking
% %on the Door
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/';
% fileName = char('Simple Walk/Anxiety/Brian/Ax1SW1_BrianAngleAxisData.mat','Simple Walk/Anxiety/Brian/Ax1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat','Simple Walk/Joy/Brian/Jy1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Neutral/Brian/Nt1SW1_BrianAngleAxisData.mat','Simple Walk/Neutral/Brian/Nt1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Panic Fear/Brian/PF1SW1_BrianAngleAxisData.mat','Simple Walk/Panic Fear/Brian/PF1SW2_BrianAngleAxisData.mat',...
%     'Move Books/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','Move Books/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
%     'Move Books/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','Move Books/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat',...
%     'Move Books/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','Move Books/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
%     'Move Books/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','Move Books/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat', ...
%     'Sitting Down/Anger/Brian/Ag1SD1_BrianAngleAxisData.mat','Sitting Down/Anger/Brian/Ag1SD2_BrianAngleAxisData.mat',...
%     'Sitting Down/Anger/Brian/Ag2SD1_BrianAngleAxisData.mat','Sitting Down/Anger/Brian/Ag2SD2_BrianAngleAxisData.mat',...
%     'Sitting Down/Anxiety/Brian/Ax1SD1_BrianAngleAxisData.mat','Sitting Down/Anxiety/Brian/Ax1SD2_BrianAngleAxisData.mat', ...
%     'Sitting Down/Anxiety/Brian/Ax2SD1_BrianAngleAxisData.mat','Sitting Down/Anxiety/Brian/Ax2SD2_BrianAngleAxisData.mat', ...
%     'Lift/Anger/Brian/Ag1Lf1_BrianAngleAxisData.mat','Lift/Anger/Brian/Ag1Lf2_BrianAngleAxisData.mat',...
%     'Lift/Anxiety/Brian/Ax1Lf1_BrianAngleAxisData.mat','Lift/Anxiety/Brian/Ax1Lf2_BrianAngleAxisData.mat',...
%     'Lift/Joy/Brian/Jy1Lf1_BrianAngleAxisData.mat','Lift/Joy/Brian/Jy1Lf2_BrianAngleAxisData.mat',...
%     'Lift/Neutral/Brian/Nt1Lf1_BrianAngleAxisData.mat','Lift/Neutral/Brian/Nt1Lf2_BrianAngleAxisData.mat',...
%     'Knocking on the Door/Anger/Brian/Ag1KD1_BrianAngleAxisData.mat','Knocking on the Door/Anger/Brian/Ag1KD2_BrianAngleAxisData.mat',...
%     'Knocking on the Door/Anxiety/Brian/Ax1KD1_BrianAngleAxisData.mat','Knocking on the Door/Anxiety/Brian/Ax1KD2_BrianAngleAxisData.mat',...
%     'Knocking on the Door/Joy/Brian/Jy1KD1_BrianAngleAxisData.mat','Knocking on the Door/Joy/Brian/Jy1KD2_BrianAngleAxisData.mat',...
%     'Knocking on the Door/Neutral/Brian/Nt1KD1_BrianAngleAxisData.mat','Knocking on the Door/Neutral/Brian/Nt1KD2_BrianAngleAxisData.mat');

% %use Simple Walk at Joy and Neutral
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/';
% fileName = char('Simple Walk/Joy/Brian/Jy1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Joy/Brian/Jy1SW4_BrianAngleAxisData.mat', ...
%     'Simple Walk/Neutral/Brian/Nt1SW2_BrianAngleAxisData.mat',...
%     'Simple Walk/Neutral/Brian/Nt1SW4_BrianAngleAxisData.mat');

% %two style and five emotions.
% %on the Door
% dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/';
% fileName = char('Simple Walk/Anger/Brian/Ag1SW1_BrianAngleAxisData.mat','Simple Walk/Anger/Brian/Ag1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Anxiety/Brian/Ax1SW1_BrianAngleAxisData.mat','Simple Walk/Anxiety/Brian/Ax1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Joy/Brian/Jy1SW1_BrianAngleAxisData.mat','Simple Walk/Joy/Brian/Jy1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Neutral/Brian/Nt1SW1_BrianAngleAxisData.mat','Simple Walk/Neutral/Brian/Nt1SW2_BrianAngleAxisData.mat', ...
%     'Simple Walk/Panic Fear/Brian/PF1SW1_BrianAngleAxisData.mat','Simple Walk/Panic Fear/Brian/PF1SW2_BrianAngleAxisData.mat',...
%     'Move Books/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat','Move Books/Anger/Brian/Ag1MB2_BrianAngleAxisData.mat',...
%     'Move Books/Anxiety/Brian/Ax1MB1_BrianAngleAxisData.mat','Move Books/Anxiety/Brian/Ax1MB2_BrianAngleAxisData.mat',...
%     'Move Books/Joy/Brian/Jy1MB1_BrianAngleAxisData.mat','Move Books/Joy/Brian/Jy1MB2_BrianAngleAxisData.mat', ...
%     'Move Books/Neutral/Brian/Nt1MB1_BrianAngleAxisData.mat','Move Books/Neutral/Brian/Nt1MB2_BrianAngleAxisData.mat');


if 1
  nex = size(fileName,1);
  M = 1;
  Q = 20;
else
  O = 8;          %Number of coefficients in a vector 
  T = 420;         %Number of vectors in a sequence 
  nex = 1;        %Number of sequences 
  M = 1;          %Number of mixtures 
  Q = 4;          %Number of states 
end

T=0;
totalT=0;

data0 = []; 
data = cell(nex,1);
thetasSet = cell(nex,1);

for i = 1:nex
    [anglesData,origin,O,t] = importMotionData(strcat(dataSetPath,fileName(i,:)));
    %=figur
    %=plot(anglesData, '.'); hold on;
    cov_type = 'full';
%experiment of lack of one motion-emotion pair.
%     if i <=2
%         tmpVector = [1;0;1;0;0;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=4
%         tmpVector = [1;0;0;1;0;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=6
%         tmpVector = [1;0;0;0;1;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=8
%         tmpVector = [1;0;0;0;0;1;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=10
%         tmpVector = [1;0;0;0;0;0;1];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=12
%         tmpVector = [0;1;1;0;0;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=14
%         tmpVector = [0;1;0;1;0;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=16
%         tmpVector = [0;1;0;0;1;0;0];
%         thetas = repmat(tmpVector,1,t);
%     elseif i <=18
%         tmpVector = [0;1;0;0;0;1;0];
%         thetas = repmat(tmpVector,1,t);
%     end
%     thetasSet{i,1} = thetas;
%     data{i,1} = anglesData+rand(size(anglesData));
%     data0 = [data0,data{i,1}];   
%experiment of lack of one motion-emotion pair.   



    if (i == 1 || i == 2||i==3||i==4||i==5||i==6||i==7||i==8)
            tmpVector = [1;0;0;0;0];
            %=tmpVector = rand(size(tmpVector));
            thetas = repmat(tmpVector,1,t);
    elseif (i== 9 || i==10||i== 11 || i==12||i==13||i==14||i==15||i==16)
              tmpVector = [0;1;0;0;0];
%             tmpVector = [exp(rand(1,1));exp(1);exp(rand(1,1));exp(rand(1,1))];
%             tmpVector = tmpVector./sum(tmpVector);
             %=tmpVector = rand(size(tmpVector));
            thetas = repmat(tmpVector,1,t);
    elseif (i== 17 || i==18||i== 19 || i==20||i==21||i==22||i==23||i==24)
            tmpVector = [0;0;1;0;0];
            %=tmpVector = rand(size(tmpVector));
            thetas = repmat(tmpVector,1,t);
    elseif (i== 25 || i==26||i== 27 || i==28||i==29||i==30||i==31||i==32)
              tmpVector = [0;0;0;1;0];
              %=tmpVector = rand(size(tmpVector));
%             tmpVector = [exp(rand(1,1));exp(rand(1,1));exp(rand(1,1));exp(1)];
%             tmpVector = tmpVector./sum(tmpVector);
            thetas = repmat(tmpVector,1,t);
    elseif (i== 33 || i==34||i== 35 || i==36||i==37||i==38||i==39||i==40)
              tmpVector = [0;0;0;0;1];
              %=tmpVector = rand(size(tmpVector));
%             tmpVector = [exp(rand(1,1));exp(rand(1,1));exp(rand(1,1));exp(1)];
%             tmpVector = tmpVector./sum(tmpVector);
            thetas = repmat(tmpVector,1,t);
    end
    thetasSet{i,1} = thetas;
    data{i,1} = anglesData;
    data0 = [data0,data{i,1}];
    
%     if (i <=2 )
%         tmpVector = [1;0];
% 
%         thetas = repmat(tmpVector,1,t);   
%     else
%         tmpVector = [0;1];
% 
%         thetas = repmat(tmpVector,1,t);  
%         
%     
%     end
%     
%     for m =i+(i-1)*0 : i+i*0
%         
%         thetasSet{m,1} = thetas;
%         data{i,1} = anglesData; 
% %         data{m,1} = rand(size(anglesData));
%         %+ rand(size(anglesData));
%         data0 = [data0,data{m,1}];
%     end
end

%PCA for all samples
if 1
    dimPCA = 4;
    O=dimPCA;
    [eigenValue,eigenMatrix]=pca(data0',dimPCA);
    display(eigenValue);
    sprintf('eigenValue size is %d',size(eigenValue));
    sprintf('reducedData size is %d',size(eigenMatrix));
    data0 = eigenMatrix'*data0;
    display(size(data0));
    
    %replace elements in data1 with those in data0
    front = 0;
    back = 0;
    for i = 1:nex
        front =back + 1;
        back = front + size(data{i,1},2)-1;
        size(data{i,1},2)
        data{i,1} = data0(:,front:back);
    end
end
% thetas = randn(2,T,nex);

% initial guess of parameters
prior0 = normalise(rand(Q,1));

transmat0 = mk_stochastic(rand(Q,Q));
% transmat0 = diag(0.5.*ones(Q,1))+[[zeros(Q-1,1) diag(0.5.*ones(Q-1,1))];zeros(1,Q)];

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
mixmat0 = normalise(mixmat0,2);
%% ===== train conventional HMM ====== %%
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 5);

[loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(data, prior1, transmat1, mu1, Sigma1, mixmat1);
%= gammaSet = cell(ncases,1); each case is a gamma(i,t)
%= gamma(i,t) = p(Q(t)=i | y(1:t))
likStateSet = {nex,1};
for i = 1:nex
    tempOb = obslikSet{i,1};
    [maxValue, maxLikState] = max(tempOb,[],1);
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
        %= cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
        cellSet2CHMM{2,q,ex} = [thetasSet{ex,1}];
        cellSet2CHMM{3,q,ex} = gammaSet{ex,1}(q,:);
    end
end

tempContextualHMM = getElements4CalculateWofCommonMeanParametricHMM(cellSet2CHMM, mu1);
%= tempContextualHMM=getElements4CalculateZofMeanParametricHMM(cellSet2CHMM);
%= tempContextualHMM is cell: stateNum * 2; 
%= For each state (row), 1st element is O_OMEGA; 2nd is OMEGA_OMEGA.
%gggg
%= get Z
wCommenValueSet = cell(Q,1);
zSet = cell(Q,1);

for q = 1:Q
    o_omega = tempContextualHMM{q,1};
    omega_omega = tempContextualHMM{q,2};
%     q
%     det(omega_omega)
    wCommenValueSet{q,1} = o_omega*(omega_omega^(-1));
    zSet{q,1} = [wCommenValueSet{q,1} mu1(:,q)];
end
cellSet2SigmaCHMM = cell(3,Q,nex); 
%=3 means: observation, contextual parameters, gamma (state occupany probability)
for ex = 1:nex
    for q = 1:Q
        cellSet2SigmaCHMM{1,q,ex} = data{ex,1};
        cellSet2SigmaCHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
        cellSet2SigmaCHMM{3,q,ex} = gammaSet{ex,1}(q,:);
    end
end


sigmaCell=getSigma4ParametricHMM(cellSet2SigmaCHMM, zSet);

for q = 1:Q
    Sigma1(:,:,q,1) = sigmaCell{q,1};
end

%= definition a control signal, which contains all the contextual
%= information
contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet});
[ loglik, errors, gammaSet,obslikSet] = contextualhmm_logprob( data, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
likStateSet_contextual = {nex,1};
for i = 1:nex
    tempOb = obslikSet{i,1};
    [maxValue, maxLikState] = max(tempOb,[],1);
    likStateSet_contextual{i,1} = [maxValue; maxLikState];
end

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


