function [ outputdata,outrow ] = rmNANrow( data,rowIndex)
%UNTITLED3 Summary of this function goes here
%This funtion will detect the NaN rows and rm them from a Matrix.
if nargin ==1
    nanMat = isnan(data);
    [tmprow,tmpcol] = find(nanMat);
    row = unique(tmprow);
elseif nargin ==2
    row = rowIndex; 
end
for i =1:length(row)
data(row(i)-i+1,:) = [];
end
outputdata = data;
outrow = row;

end

