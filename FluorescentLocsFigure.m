function [fig] = FluorescentLocsFigure(CA, turnOnLocs)
%creates figure of corrosion lattice with turn on events or all fluorescent
% locations overlaid as circles
L = size(CA,1);
[xp,yp] = circle(L/2,L/2, 10);

CA(45:60, 25:125) = 3;
clim = [0, 3];
map = [0 0 0
       0 0 0  
       1 1 1];
fig = figure
imagesc(CA, clim)
set(gcf,'Colormap',map);
axis image
hold on
if ~isempty(turnOnLocs)
    scatter(turnOnLocs(:,2), turnOnLocs(:,1), 75, 'yellow', '.')
end
plot(L/2+xp,L/2+yp, 'color', 'red', 'LineWidth', 1)
text(25, 20, '1 \mu m', 'FontSize', 20, 'Color', 'white')
hold off
end