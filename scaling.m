function [ output_matrix, maxVector,minVector] = scaling( input_matrix, dimInx)
%SCALING Summary of this function goes here
%   Detailed explanation goes here
if nargin ==2
    
    if(dimInx == 1)
        tmpInput = input_matrix';
    else
        tmpInput = input_matrix;
    end
    meanCol = mean(tmpInput,2);
    %subtract the mean
    if 0
        tmpOutput = tmpInput - repmat(meanCol,1,size(tmpInput,2));
    else
        tmpOutput = tmpInput;
    end
    maxCol = max(tmpOutput,[],2);
    minCol = min(tmpOutput,[],2);
    %scaling tmpInput to the range from -1 to 1
    tmpOutput = (tmpOutput - repmat(minCol,1,size(tmpInput,2)))./(repmat((maxCol-minCol),1,size(tmpOutput,2)));
    if (dimInx == 1)
        output_matrix = tmpOutput';
    else
        output_matrix = tmpOutput;
    end
if nargout == 3 
    maxVector = maxCol;
    minVector = minCol;
end
end

