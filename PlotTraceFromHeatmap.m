%plots trace of heatmap for current figure with gray shaded box
%representing cathode region
fig = gcf;
dataobjs = findobj(fig, '-property', 'Cdata');
D = dataobjs.CData;
xprofile = D(250,:);
yprofile = D(:,250);
location = [1:500]*10;
figure
hold on
drawShadedRectangle([2400,2600],[0,7e6], [0.5, 0.5, 0.5], [0.5,0.5,0.5], [0.5,0.5,0.5], [0.5,0.5,0.5], 'vertical')
%will need to adjust height of gray box manually, location is the middle
%200 nm (because it is 100nm radius)
plot(location, xprofile, 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 1.5)
%color is set to match color on histograms
grid
xlabel('Location (nm)', 'FontSize', 14)
ylabel('Fluorescence (AU)', 'FontSize',14)
title('D = 10^7 nm^2/s', 'FontSize', 14)
%change name accordingly