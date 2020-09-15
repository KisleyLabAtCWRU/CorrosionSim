function [Grid] = CreateCirclePit(gridSize, pitRadius)
%create a square CA of length gridSize with a circular pit in the center of
%radius pitRadius

Grid = ones(gridSize);
centerLoc = round(gridSize/2);
for i=1:gridSize
    for j =1:gridSize
        if sqrt(abs(i-centerLoc)^2 + abs(j-centerLoc)^2) <= pitRadius
            Grid(i,j) = 2;
        end
    end
end
end