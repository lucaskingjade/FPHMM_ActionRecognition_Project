

indAct = 1:numActivity;
argin1 = indAct;
argin2 = repmat({numEmotion},size(argin1));
argin3 = repmat({trainingSet},size(argin1));
totalNumTraining = parcellfun (nproc, par_fun_calculTrainNum,[indAct,numEmotion,trainingSet], "UniformOutput", true)


function [totalNumTraining] = par_fun_calculTrainNum(indAct,numEmotion,trainingSet)
	totalNumTraining = 0;
	for indEm = 1: numEmotion
		totalNumTraining = totalNumTraining + size(trainingSet{indAct,indEm},1);
	end
end
