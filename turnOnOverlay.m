function [fig] = turnOnOverlay(CA, turnOnLocs)
%creates figure of corrosion lattice with turn on events overlaid as red
%xs

L = size(CA,1);
[xp,yp] = circle(L/2,L/2, 10);

CA(35:40, 25:75) = 0;
clim = [0, 3];
map = [1 1 1
       0.5 0.5 0.5  
       0 0 0];
fig = figure
imagesc(CA, clim)
set(gcf,'Colormap',map);
axis image
hold on
if ~isempty(turnOnLocs)
    scatter(turnOnLocs(:,2), turnOnLocs(:,1), 50, 'red', 'x')
end
plot(L/2+xp,L/2+yp, 'color', 'red', 'LineWidth', 1)
text(25, 20, '500 nm', 'FontSize', 12, 'Color', 'white')
hold off
end