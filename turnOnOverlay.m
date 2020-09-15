function [fig] = turnOnOverlay(CA, turnOnLocs)
%creates figure of corrosion lattice with turn on events overlaid as red
%x's

clim = [1, 3];
map = [0 0 0  %M = black, C = gray
       0.5 0.5 0.5];
fig = figure
imagesc(CA, clim)
set(gcf,'Colormap',map);
axis image
hold on
scatter(turnOnLocs(:,2), turnOnLocs(:,1), 50, 'red', 'x')
hold off
end