function [ prdtlabel, prdLabelInd,maxloglik ] = recognitionActivity_HMM_Synthesis( dataCell,HMMCell,activityCell )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numActivity = length(HMMCell);

if (iscell(dataCell)==1)
    tmpdata = dataCell;
else
    tmpdata= {dataCell};
end

loglik = cell(numActivity,1);
errors = cell(numActivity,1);
gammaSet = cell(numActivity,1);
alphaSet = cell(numActivity,1);
betaSet = cell(numActivity,1);
obslikSet = cell(numActivity,1);
newloglik = -inf;
maxloglik = -inf;

for indAct = 1:numActivity
    
        prior1 = HMMCell{indAct,1}{2,1};
        transmat1 = HMMCell{indAct,1}{3,1};
        mu1 = HMMCell{indAct,1}{4,1};
        Sigma1 = HMMCell{indAct,1}{5,1};
        mixmat1 = HMMCell{indAct,1}{6,1};
        [loglik{indAct,1}, errors{indAct,1}, gammaSet{indAct,1}, alphaSet{indAct,1}, betaSet{indAct,1}, obslikSet{indAct,1}] = ...
            mhmm_logprob(tmpdata, prior1, transmat1, mu1, Sigma1, mixmat1);
        
        newloglik = max(maxloglik,loglik{indAct,1});
        
        if(newloglik ~= maxloglik)
            prdtlabel = activityCell{1,indAct};
            prdLabelInd = indAct;
        end
        
        maxloglik = newloglik;
    
end



end

