%created by WANG Qi for standardize motion angle data on 11,Oct,2015
function [standardizedData] = standardization(Data,axis)
if (axis ~= 1)
    tmpData = Data';
else
    tmpData = Data;
end
meanVector = mean(tmpData,2);
varianceVector = var(tmpData,0,2);
i = 1:1:size(tmpData,2);
standardizedData(:,i) = (tmpData(:,i) - meanVector)./varianceVector;
size(Data)

if(axis ~= 1)
    standardizedData = standardizedData';
end




end

