function [ outData ] = addDynamicFeatures_Synthesis( Data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if 0
fprintf('the dim of frame in data is %d\n',size(Data,1));
M = size(Data,1);%number of dimensions of data
T = size(Data,2);
tmpData1 = [];

for i = 1:T
    
    tmpData1 = [tmpData1;Data(:,i)];
    
end

 W = NewWcreated(T,M);
 if size(W,2)~= size(tmpData1,1)
    error('size of W and tmpData dont match for inner product\n');
 end
 tic;
 tmpData2 = W*tmpData1;
 toc;
 outData = zeros(M*3,T);
 front =0;
 back =0;
 for i = 1:T
    front =  back+1;
    back = back+3*M;
    outData(:,i) = tmpData2(front:back,1);
 
 end
else
    T = size(Data,2);
    DeltaMatrix = zeros(size(Data));
    Delta_DeltaMatrix = zeros(size(Data));
    for indFrame = 1:T
        if indFrame ==1
            DeltaMatrix(:,indFrame) = Data(:,indFrame+1) -Data(:,indFrame);
            
        elseif indFrame ==T
            DeltaMatrix(:,indFrame) = Data(:,indFrame) -Data(:,indFrame-1);
        else
            DeltaMatrix(:,indFrame) = 0.5*(Data(:,indFrame+1) -Data(:,indFrame-1));
            Delta_DeltaMatrix(:,indFrame) = Data(:,indFrame-1) -2*Data(:,indFrame)+Data(:,indFrame+1);
        end
    end
    outData = [Data;DeltaMatrix;Delta_DeltaMatrix];
    
   
    

end
end

