function [ prdtEmLabel,prdtEmInd,maxloglik ] = recognitionEmotion_HMM_Synthesis( dataCell,HMMCell,indAct,...
        emotionCell,actLabels )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if isempty(actLabels)
	actLabels = {'Simple Walk','Walk with smth in the Hands'};
end
numEmotion = size(HMMCell,2);
numActivity = size(HMMCell,1);
if (numActivity ~= size(HMMCell,1))
    disp('!!!!!!!!error happened in function recognitionActivity_HMM at line 9!!!!!!');
end

if indAct ~=0
    s = indAct;
else
    s = 1:numActivity;
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

for indAct = s
    
    for indEm = 1:numEmotion
	if ~iscell(HMMCell{indAct,indEm})
		continue;
	end
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
		       
 		if newloglik ==-inf
			prdtEmLabel = 'unknown';
			prdtEmInd = numEmotion+1;
		end
        if(newloglik ~= maxloglik)
            prdtEmLabel = emotionCell{1,indEm};
            prdtEmInd = indEm;
        end
        
        maxloglik = newloglik;
    end
    
end


end

