%create normalized histogram of distances. Divides total number of
%instances at each distance by circumference at that distance to account
%for larger areas at larger distances from center
data = D; %load the distances from the appropriate file
M = load(strcat(filename, 'MetaData.mat');
pxsize = M.pxsize;
M = max(data);
m = min(data);
edges = [m:20:M]; %each bin will span 20 cells or 200 nm (if I'm not uses 10nm cells
H = histogram(data, edges, 'Normalization', 'counts');
L = length(H.Values);
T = zeros(1,L)
for i =1:L
    T(i) = H.Values(i)/(2*pi*(edges(i+1)-edges(i))/2);
end
figure
histogram('BinEdges', edges*pxsize, 'BinCounts', T, 'Normalization', 'counts'); % this will plot with the 
                        %x axis being nanometers from pit and y axis being
                        %counts/nm circumferal distance
