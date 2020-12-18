function [a,b] = LocateNNs(data, loc, value)
%Search Moore neighborhood for type 'value' and return ABSOLUTE indices for
%all instances

nbrhd = zeros(3);
[sM,sN] = size(data);
for i=1:3
    for j=1:3
        m = PeriodicBound(loc(1)+(i-2),sM);
        n = PeriodicBound(loc(2)+(j-2),sN);
        nbrhd(i,j) = data(m,n);
    end
end
nbrhd(2,2) = NaN; %don't want to take into account the current cell
[a1,b1] = ind2sub([3,3],find(nbrhd==value)); %find indices for all places that are 'value'
a = PeriodicBound(loc(1)+a1-2, sM);
b = PeriodicBound(loc(2)+b1-2, sN);
end