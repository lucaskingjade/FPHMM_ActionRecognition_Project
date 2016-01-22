function [ prdtlabel, maxloglik] = recognitionEmotion_HMM( dataCell,HMMCell)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
labels = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
if (iscell(dataCell)==1)
    tmpdata = dataCell;
else
    tmpdata= {dataCell};
end
numHMMs = size(HMMCell,1);
loglik = cell(numHMMs,1);
errors = cell(numHMMs,1);
gammaSet = cell(numHMMs,1);
alphaSet = cell(numHMMs,1);
betaSet = cell(numHMMs,1);
obslikSet = cell(numHMMs,1);
newloglik = -inf;
maxloglik = -inf;

for i = 1:numHMMs
    prior1 = HMMCell{i,2,1};
    transmat1 = HMMCell{i,3,1};
    mu1 = HMMCell{i,4,1};
    Sigma1 = HMMCell{i,5,1};
    mixmat1 = HMMCell{i,6,1};
    [loglik{i,1}, errors{i,1}, gammaSet{i,1}, alphaSet{i,1}, betaSet{i,1}, obslikSet{i,1}] = ...
        mhmm_logprob(tmpdata, prior1, transmat1, mu1, Sigma1, mixmat1);
    loglik{i,1}
    newloglik = max(maxloglik,loglik{i,1})
    if(newloglik ~= maxloglik)
        prdtlabel = labels{1,i};
    end
    maxloglik = newloglik;
    
end

end


