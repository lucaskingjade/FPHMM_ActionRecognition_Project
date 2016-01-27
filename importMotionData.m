%Created by WANG Qi for importing and preprocessing motion data from the
%.mat files in Emilya dataset on 11,Oct,2015
function [result,origin,dim,timeStep ] = importMotionData( filePath,number)
%IMPORTMOTIONDATA Summary of this function goes here
%   Detailed explanation goes here
x=load(filePath,'-mat');
name = fieldnames(x);
data = x.(name{1});
dataShape = size(data);
% newData = zeros(dataShape(1),1);
%process data into angles coordinates
% newData(:,1) = data(:,65).*data(:,66);
% newData(:,2) = data(:,65).*data(:,67);
% newData(:,1) = data(:,65).*data(:,68);
newData = zeros(dataShape(1),92*3/4);
j = 1:4:92;
i = 1:3:(3*92/4);
newData(:,i) = data(:,j).*data(:,j+1);
newData(:,i+1) = data(:,j).*data(:,j+2);
newData(:,i+2) = data(:,j).*data(:,j+3);
origin = newData;
% %resample
% sampledData = zeros(fix(size(newData,1)),size(newData,2));
% for i =1:fix(size(newData,1))
%     
%     sampledData(i,:) = newData(10*i,:);
% end
newData = scaling(newData,1);
% newData = normr(newData);
if (nargin == 2 && number<= size(newData,2) )
    %use PCA
    [eigenValue,eigenMatrix]=pca(newData,number);
    display(eigenValue)
    sprintf('eigenValue size is %d',size(eigenValue))
    sprintf('reducedData size is %d',size(eigenMatrix))
    reducedData = eigenMatrix'*newData';
    display(size(reducedData));
    result = reducedData;
else
    result = newData';
    
end
shape = size(result);
dim = shape(1);
timeStep = shape(2);


end

