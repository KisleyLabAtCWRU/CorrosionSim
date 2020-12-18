function [CA] = Colloid(N,R, px, pxsize);
%create initial lattice for N colloids of radius R nm in the
%imaging plane. Lattice is px pixels in each dimension and each pixel is
%pxsize nm in dimension

%for use in non-complete colloid version of model

CA = zeros(px,px);
rad = R/pxsize;
centerLoc = round(px/2);
for i=1:px
    for j =1:px
        if sqrt(abs(i-centerLoc)^2 + abs(j-centerLoc)^2) <= rad
            CA(i,j) = 1;
        end
    end
end
for i=1:px
    for j =1:px
        if sqrt(abs(i-centerLoc)^2 + abs(j-centerLoc)^2) <= rad-1
            CA(i,j) = 0.5;
        end
    end
end
end