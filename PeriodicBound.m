function v = PeriodicBound(a,l)
% periodic boundary conditions for location a in a lattice of length l
v = zeros(size(a));
for i = 1:length(a)
    if a(i)<1
        v(i) = l+a(i);
    elseif a(i)>l
        v(i) = a(i)-l;
    else
        v(i) = a(i);
    end
end