function [ prdtlabel, prdLabelInd,maxloglik ] = recognitionActivity_HMM( dataCell,HMMCell,indexEm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
emLabels = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
% actLabels = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
actLabels = {'Simple Walk','Walk with smth in the Hands'};
numEmotion = length(emLabels);
numActivity = length(actLabels);
if (numActivity ~= size(HMMCell,1))
    disp('!!!!!!!!error happened in function recognitionActivity_HMM at line 9!!!!!!');
end

if indexEm ~=0
    s = indexEm;
else
    s = 1:numEmotion;
end

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
    
    for indEm = s
        indEm
        indAct
        prior1 = HMMCell{indAct,indEm}{2,1};
        transmat1 = HMMCell{indAct,indEm}{3,1};
        mu1 = HMMCell{indAct,indEm}{4,1};
        Sigma1 = HMMCell{indAct,indEm}{5,1};
        mixmat1 = HMMCell{indAct,indEm}{6,1};
        [loglik{indAct,1}, errors{indAct,1}, gammaSet{indAct,1}, alphaSet{indAct,1}, betaSet{indAct,1}, obslikSet{indAct,1}] = ...
            mhmm_logprob(tmpdata, prior1, transmat1, mu1, Sigma1, mixmat1);
        loglik{indAct,1}
        newloglik = max(maxloglik,loglik{indAct,1})
        
        if(newloglik ~= maxloglik)
            prdtlabel = actLabels{1,indAct};
            prdLabelInd = indAct;
        end
        
        maxloglik = newloglik;
    end
    
end



end

