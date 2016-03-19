function [ outputdata ] = replaceZeroElement( data )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
[tmprow,tmpcol] = find(~data);


%replace this element with the neighbour element.
for i=1:3:length(tmprow)
    for j =1:3:length(tmpcol)
        indrow = tmprow(i);
        indcol = tmpcol(j);
        if data(indrow,indcol)==0 && indcol~=1 
           for m = indcol-1:-1:1 
               if data(indrow,m) ~= 0 && data(indrow+1,m)~=0 && data(indrow+2,m)~=0
                   data(indrow,indcol) = data(indrow,m);
                   data(indrow+1,indcol) = data(indrow+1,m);
                   data(indrow+2,indcol) = data(indrow+2,m);
               end
           end

        end
    end
end



outputdata = data;
end

