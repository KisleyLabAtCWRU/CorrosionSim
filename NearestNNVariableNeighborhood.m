function [dist,M,N] = NearestNNVariableNeighborhood(data, loc, value, l)
%This function will sample a square neighborhood of length*2+1 pixels
%around the central pixel at loc for cells of value 'value' and return the 
%distance and relative location of the closet one. Periodic boundary 
%conditions are encoded

nbrhd = zeros(l*2+1);
[sM,sN] = size(data);
loc1 = round(loc);
for i=1:l*2+1
    for j=1:l*2+1
        m = PeriodicBound(loc1(1)+(i-(l+1)),sM);
        n = PeriodicBound(loc1(2)+(j-(l+1)),sN);
        nbrhd(i,j) = data(m,n);
    end
end
T = find(nbrhd == value);
if ~isempty(T) %if there is an instance of value nearby
    [indM, indN]  = ind2sub([2*l+1,2*l+1], T); %turn T into row, column indices
    middleInd = l+1; %the location of interest/center location
    allDists = sqrt((middleInd - indM).^2 + (middleInd-indN).^2); %distance between location of interest and each occurance of value
    [~,vloc] = min(abs(allDists)); %array index for closes instance of value
    M1 = indM(vloc); N1 = indN(vloc); %absolute location of closest instance
    M = -1*(l+1-M1); N = -1*(l+1-N1); %relative location of closest instance
    dist = sqrt((loc1(1)+M -loc(1))^2 + (loc1(2)+N - loc(2))^2); %this makes sure the precise location of interest within the cell in question is used for distance
else
    dist = inf; %this will insure that Pin is not affected if there is no pit nearby (not currently using this property 9/11/2020)
    M= NaN; N = NaN; %these values won't matter in this case
end
end