function [thetasSet, thetas_learned_cell,Sigma1] = pHMM_computeThetasSet(data,numOfSeq4Emotion,thetasSet,wSet,zSet,gammaSet,commonMean,invOfSigma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if size(numOfSeq4Emotion,1) ~= 8
    disp('the dim of variable numOfSeq4Emotion isnt correct');
end

if size(thetasSet,1) ~= size(data,1)
    disp('size of thetasSet doesnt match with size of data');
end

front = 0;
back = 0;
Q = size(invOfSigma,3);
if (Q==8)
    disp('right')
end

% define thetas cell
thetas_learned_cell = cell(size(numOfSeq4Emotion,1),1);
for indEm = 1:size(numOfSeq4Emotion,1)
    front = back + 1;
    back = front + numOfSeq4Emotion(indEm) - 1;
    dataOfOneEmotion = data(front:back,1);
    gammaSetOfOneEmotion = gammaSet(front:back,1);
    tmpthetasSet = thetasSet(front:back,1);    
    cellSet2CHMM = cell(2,Q,numOfSeq4Emotion(indEm));
    for ex = 1:numOfSeq4Emotion(indEm)
        for q = 1:Q
            cellSet2CHMM{1,q,ex} = dataOfOneEmotion{ex,1};
            %=cellSet2CHMM{2,q,ex} = [thetasSet{ex,1};ones(1,size(thetasSet{ex,1},2))];
            cellSet2CHMM{2,q,ex} = gammaSetOfOneEmotion{ex,1}(q,:);
        end
    end
    
    thetasCell = getElements4CalculateThetaofCommonMeanParametricHMM(cellSet2CHMM,wSet,commonMean,invOfSigma);
    
    tmpThetasTerm1 = thetasCell{1,1};
    tmpThetasTerm2 = thetasCell{2,1};
    % replace elements of thetasSet
    thetaVector = ((tmpThetasTerm1)^-1)*tmpThetasTerm2;
    
%     disp('the original thetaVector is ');
%     tmpthetasSet{1,1}(:,1);
%     disp('thetaVector is :');
    thetas_learned_cell{indEm,1} = thetaVector;
    
    for i =front:back
        t = size(thetasSet{i,1},2); 
        thetasSet{i,1} = repmat(thetaVector,1,t);
    end
    
    
end

Sigma1 = updateSigmaOfParametricHMM( data, thetasSet, gammaSet, zSet );




end

