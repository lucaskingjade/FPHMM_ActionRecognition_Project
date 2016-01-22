dataSetPath = '/Users/qiwang/Documents/Emilya_Database/All_Mat_Files/AllAction_segments/PerAction/Move Books';
fileName = char('/Anger/Brian/Ag1MB1_BrianAngleAxisData.mat');
[anglesData,origin,O,t] = importMotionData(strcat(dataSetPath,fileName));
disp('adfsa')
disp('size of origin data')
sampleNum = size(origin,1);
dim = size(origin,2);
dimPCA = 4;
[eigenValue,eigenMatrix]=pca(anglesData',dimPCA);
display(eigenValue);
size(eigenValue)
size(eigenMatrix)
anglesData = eigenMatrix'*anglesData;
display(size(anglesData));
%recover motion data from anglesData
tmpData = eigenMatrix*anglesData;
%recover from scaled data
size(tmpData)
%subtract the mean
meanCol = mean(origin',2);
tmpOutput = origin' - repmat(meanCol,1,size(origin',2));
maxCol = max(tmpOutput,[],2);
minCol = min(tmpOutput,[],2);
%scaling tmpInput to the range from -1 to 1
recoverdData = tmpData.*(repmat((maxCol-minCol),1,size(tmpOutput,2)))+repmat(minCol,1,size(tmpOutput,2))+repmat(meanCol,1,size(origin',2));

%
