function [cathLoc1] = AdjCathLoc(M1, N1, dyeLoc, CA, cathLoc)
%adjust the cathode location probability density function to remove
%probability over pits and redistribute over rest of function. At the
%moment it does not redistribute in a properly weighted fashion (9/10/2020)
%[M1, N1] is location of nearest pit edge. dyeLoc is location of dye, CA is
%the corrosion lattice, cathLoc is the un-adjusted probability matrix.
%returns adjusted probability matrix

px = size(CA,1);
M = dyeLoc(1) + M1;
N = dyeLoc(2) + N1; %absolute coordinates of nearest pit (r, c)
cathLoc1 = cathLoc;
cathCounter = 0; %number of cells over pit
cathRem = 0; %total probability removed 
[cm, cn] = size(cathLoc1);
for q = 1:cm
    for p = 1:cn
        M2 = M-ceil(cm/2)+q; 
        N2 = N-ceil(cn/2)+p;
        M2 = PeriodicBound(M2, px);
        N2 = PeriodicBound(N2,px);
        if CA(M2,N2) == 2
            cathRem = cathRem + cathLoc1(q,p); %tally of total probability removed
            cathLoc1(q,p) = 0;
            %sprintf('%d %d set to zero at CA %d %d', q,p, M2, N2)
            cathCounter = cathCounter+1; %will be used to fix normalization
        end
    end
end
Ad = cathRem/(cm*cn - cathCounter); %how much to add to each cell
for u = 1:cm
    for v = 1:cn
        if cathLoc1 ~=0
            cathLoc1 = cathLoc1+ Ad; %renormalize (this is a very crude way of doing this, it should be weighted
         end
    end
end
end