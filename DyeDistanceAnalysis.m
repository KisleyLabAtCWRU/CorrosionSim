%Find distance from pit of all turned-on dyes save in onLocs
%if onLocs was loaded from a file it needs to be onLocs.onLocs, if it's
%from a trial just run it should just be onLocs
[a,b] = size(onLocs);
counter = 1;
clear D
for i=1:a
    m = onLocs(i,1);
    n = onLocs(i,2);
    [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 2, 200);
    D(counter) = dist;
    counter = counter+1;
end