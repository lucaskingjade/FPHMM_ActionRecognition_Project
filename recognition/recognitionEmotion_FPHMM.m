function [ prdtlabel, maxloglik] = recognitionEmotion_FPHMM(dataCell, FPHMMCell)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
labels = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};

if (iscell(dataCell)==1)
    tmpdata = dataCell;
else
    tmpdata= {dataCell};
end
prior1 = FPHMMCell{1,1};
transmat1 = FPHMMCell{2,1};
mu1 = FPHMMCell{3,1};
Sigma1 = FPHMMCell{4,1};
mixmat1 = FPHMMCell{5,1};
contextualSignal = FPHMMCell{6,1};
numEmotion= size(labels,2);
t = size(tmpdata{1,1},2);

newloglik = -inf;
maxloglik = -inf;
for i = 1:numEmotion
    thetas = getContexutalVector(labels(1,i));
    thetasSet = repmat(thetas,1,t);
    contextualSignal.thetasSet = {thetasSet};
    [ loglik, errors, gammaSet,obslikSet] = contextualhmm_logprob( tmpdata, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
    newloglik = max(maxloglik,loglik);
    if(newloglik ~= maxloglik)
        prdtlabel = labels{1,i};
    end
    maxloglik = newloglik;
end

end

