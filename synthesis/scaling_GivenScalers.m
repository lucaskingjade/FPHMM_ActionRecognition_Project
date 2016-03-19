function [ output_matrix ] = scaling_GivenScalers( input_matrix, maxVector,minVector,dimInx )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
if nargin ==4
    
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
    maxCol = maxVector;
    minCol = minVector;
    %scaling tmpInput to the range from -1 to 1
    tmpOutput = (tmpOutput - repmat(minCol,1,size(tmpInput,2)))./(repmat((maxCol-minCol),1,size(tmpOutput,2)));
    if (dimInx == 1)
        output_matrix = tmpOutput';
    else
        output_matrix = tmpOutput;
    end
end
end

