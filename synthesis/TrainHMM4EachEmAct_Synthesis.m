HMMCell = cell(numActivity,numEmotion);
parfor indAct =1:numActivity
    for indEm =1:numEmotion
        if ~iscell(TrainDataSet{indAct,indEm})
            continue;
        end
        HMMCell{indAct,indEm} = cell(6,1);
        [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
            trainingConventionHMM(TrainDataSet{indAct,indEm},numStates,numMix,max_iter,left2rightHMMtopology);
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
%print accuracy
disp('Congratulations!!finish HMM!!');

