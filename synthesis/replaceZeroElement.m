function [ outputdata ] = replaceZeroElement( data,currentFileName )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
[tmprow,tmpcol] = find(~data);
%replace this element with the neighbour element.
for i=1:length(tmprow)
    indrow = tmprow(i);
    indcol = tmpcol(i);
    if mod(indrow-1,3)~=0
        continue;
    end
    if (indrow+2)>69
        sprintf('index out of bounds,the file name is %s',currentFileName);
    end
    if data(indrow,indcol)==0 && indcol~=1 
       for m = indcol-1:-1:1
           if (data(indrow,m) ~= 0) && (data(indrow+1,m)~=0) && (data(indrow+2,m)~=0)
               data(indrow,indcol) = data(indrow,m);
               data(indrow+1,indcol) = data(indrow+1,m);
               data(indrow+2,indcol) = data(indrow+2,m);
               break;
           end
       end
    elseif indcol ==1
        disp('!!!!!!some where the first element is equal to 0!!!!!!')       
    end
    
end

outputdata = data;
end

