function NN = SumMooreNeighborhood(data, loc, value)
%number of cells in state 'value' in Moore neighborhood around [loc] in 
% matrix 'data'. Periodic bouondary conditions are encoded
nbrhd = zeros(3,3);
[sM,sN] = size(data);
for i=1:3
    for j=1:3
        m = PeriodicBound(loc(1)+(i-2),sM);
        n = PeriodicBound(loc(2)+(j-2),sN);
        nbrhd(i,j) = data(m,n);
    end
end
State = zeros(1,8);
State(1) = (nbrhd(1,1)==value);
State(2) = (nbrhd(1,2)==value);
State(3) = (nbrhd(2,1)==value);
State(4) = (nbrhd(1,3)==value);
State(5) = (nbrhd(3,1)==value);
State(6) = (nbrhd(3,2)==value);
State(7) = (nbrhd(2,3)==value);
State(8) = (nbrhd(3,3)==value);
NN = sum(State);
end