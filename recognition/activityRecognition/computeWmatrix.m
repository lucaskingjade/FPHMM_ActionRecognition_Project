function [ LL, prior1, transmat1, commonMean, Sigma1, mixmat1,wSet, zSet] = computeWmatrix( data,thetasSet, gammaSet, hmmParameterSet, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[transitionLeft2Right, verbose] = ...
        process_options(varargin, 'transitionLeft2Right', 0,'verbose', 1);

    prior1 = hmmParameterSet.prior1;
    transmat1 = hmmParameterSet.transmat1;
    mu1 = hmmParameterSet.mu1;
    Sigma1 = hmmParameterSet.Sigma1;
    mixmat1 = hmmParameterSet.mixmat1;
    
    commonMean = mu1;%mu won't vary
    
%     previous_loglik = -inf;
    loglik = 0;
%     converged = 0;
%     num_iter = 1;
    LL = [];
    
%     while (num_iter <= max_iter) & ~converged
    
    [zSet,wSet Sigma1] = pHMM_commonMeanVector(data, thetasSet, gammaSet, mu1);

    contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet}, 'transitionLeft2Right',transitionLeft2Right);
    [ loglik, errors, gammaSet, transmat1] = hmm_logprob_pHMM( data, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
%     if verbose, fprintf(1, 'loglik = %f\n', loglik); end

%     invOfSigma = cell(size(Sigma1,3),1);
%     for i = 1:size(Sigma1,3)
%     invOfSigma{i,1} = inv(Sigma1(:,:,i,1)); 
%     end
    %compute theta vector
%     disp('compute thetas...');
%     [thetasSet, thetas_learned_cell, Sigma1] = pHMM_computeThetasSet(data,numOfSeq4Emotion,thetasSet,wSet,zSet,gammaSet,commonMean,invOfSigma);

%     contextualSignal = struct('contextualMean', 1, 'zSet', {zSet}, 'thetasSet', {thetasSet}, 'transitionLeft2Right',transitionLeft2Right);
%     [ loglik, errors, gammaSet, transmat1] = hmm_logprob_pHMM( data, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
% 
%     if verbose, fprintf(1, 'iteration %d, loglik = %f\n', num_iter, loglik); end
% 
%     num_iter =  num_iter + 1;
%     converged = em_converged(loglik, previous_loglik, thresh);
%     previous_loglik = loglik;
    LL = [LL loglik];

%     end
    

end

