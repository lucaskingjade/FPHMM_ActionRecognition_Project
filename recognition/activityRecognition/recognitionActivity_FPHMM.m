function [ prdEmotionLabel,prdEmotionInd,prdtlabel, prdLabelInd,maxloglik ] = recognitionActivity_FPHMM( dataCell,FPHMMCell,indexEm,emLabels,actLabels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% emLabels = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};
% emLabels = {'Anger','Shame'};

% actLabels = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
% actLabels = {'Simple Walk','Walk with smth in the Hands'};
numEmotion = length(emLabels);
numActivity = length(actLabels);
if (numActivity ~= size(FPHMMCell,1))
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

newloglik = -inf;
maxloglik = -inf;

t = size(tmpdata{1,1},2);

for indAct = 1:numActivity
    prior1 = FPHMMCell{indAct,1}{1,1};
    transmat1 = FPHMMCell{indAct,1}{2,1};
    mu1 = FPHMMCell{indAct,1}{3,1};
    Sigma1 = FPHMMCell{indAct,1}{4,1};
    mixmat1 = FPHMMCell{indAct,1}{5,1};
    contextualSignal = FPHMMCell{indAct,1}{6,1};
    contextualVector = FPHMMCell{indAct,1}{7,1};
    for indEm = s
        thetas = getContexutalVector(emLabels(1,indEm),contextualVector,emLabels);
        thetasSet = repmat(thetas,1,t);
        contextualSignal.thetasSet = {thetasSet};
        [ loglik, errors, gammaSet,obslikSet] = contextualhmm_logprob( tmpdata, prior1, transmat1, mu1, Sigma1, mixmat1, contextualSignal );
        
        newloglik = max(maxloglik,loglik);
        
        if(newloglik ~= maxloglik)
            %add these two lines for compute the emotion prediction
            %accuracy
            prdEmotionLabel = emLabels{1,indEm};
            prdEmotionInd = indEm;
            prdtlabel = actLabels{1,indAct};
            prdLabelInd = indAct;
        end
        
        maxloglik = newloglik;
    end
    
end





end

