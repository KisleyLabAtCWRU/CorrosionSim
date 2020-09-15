%Find distance from pit of all turned-on dyes save in onLocs
[a,b] = size(onLocs);
counter = 1;
for i=1:b
    A = onLocs{i};
    [c,d] = size(A);
    for j=1:c
        m = A(j,1);
        n = A(j,2);
        [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 2, 500);
        D(counter) = dist;
        counter = counter+1;
    end
end