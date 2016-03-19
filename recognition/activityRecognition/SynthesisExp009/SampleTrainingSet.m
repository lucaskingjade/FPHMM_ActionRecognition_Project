%%randomly sample from training set into a smaller training set
tmpfileNamesList = dir('../DataSet/DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_*_Smaller.mat');
numDataFl = length(tmpfileNamesList)

for indDataFl =1:numDataFl
	disp('Begin to load file\n');
	tmpfileNamesList(indDataFl).name
    load(strcat('../DataSet/',tmpfileNamesList(indDataFl).name),'TrainDataSet');
    load(strcat('../DataSet/',tmpfileNamesList(indDataFl).name),'numActivity');
    load(strcat('../DataSet/',tmpfileNamesList(indDataFl).name),'numEmotion');
	%load(strcat('../DataSet/',tmpfileNamesList(indDataFl).name))

    tmpTrainDataSet = TrainDataSet;
    for indAct =1:numActivity
        for indEm =1:numEmotion
            if ~iscell(TrainDataSet{indAct,indEm})
                continue;
            end
            numFl = size(TrainDataSet{indAct,indEm},1);
            numTrain = round(numFl*0.25);
            p = randperm(numFl,numTrain);
			size(p);
            tmpTrainDataSet{indAct,indEm} = TrainDataSet{indAct,indEm}(p,:);
			size(tmpTrainDataSet{indAct,indEm})
        end
    end
    TrainDataSet = tmpTrainDataSet;
    save('-mat7-binary',strcat('../DataSet/',tmpfileNamesList(indDataFl).name),'TrainDataSet','-append');
	disp('Finish on loop\n');
end
