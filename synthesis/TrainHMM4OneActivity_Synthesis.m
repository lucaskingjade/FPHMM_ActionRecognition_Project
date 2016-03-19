%% Training HMM
%%training conventional HMM for each activity and emotion pair%%
HMMCell = cell(numActivity,1);

parfor indAct =1:numActivity
        HMMCell{indAct,1} = cell(6,1);
        [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
            trainingConventionHMM(TrainDataSet_HMM{indAct,1},numStates,numMix,max_iter,left2rightHMMtopology);
        HMMCell{indAct,1}{1,1} = LL;
        HMMCell{indAct,1}{2,1} = prior1;
        HMMCell{indAct,1}{3,1} = transmat1;
        HMMCell{indAct,1}{4,1} = mu1;
        HMMCell{indAct,1}{5,1} = Sigma1;
        HMMCell{indAct,1}{6,1} = mixmat1;

    % [loglik, errors, gammaSet, alphaSet, betaSet, obslikSet] = mhmm_logprob(testData, prior1, transmat1, mu1, Sigma1, mixmat1);
end

%%save all data here
%print accuracy
disp('Congratulations!!finish HMM!!');
