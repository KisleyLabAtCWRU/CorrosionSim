%plot traces for each of 4 diffusion coefficients on same plot, and
%calculate signal to background

%enter appropriate .fig names for heatmaps
fig3 = openfig('heatmap1e3');
fig6 = openfig('heatmap1e6');
fig7 = openfig('heatmap1e7');
fig8 = openfig('heatmap1e8');
dataobjs = findobj(fig3, '-property', 'Cdata');
D3 = dataobjs.CData;
xprofile3 = D3(250,:);
dataobjs = findobj(fig6, '-property', 'Cdata');
D6 = dataobjs.CData;
xprofile6 = D6(250,:);
dataobjs = findobj(fig7, '-property', 'Cdata');
D7 = dataobjs.CData;
xprofile7 = D7(250,:);
dataobjs = findobj(fig8, '-property', 'Cdata');
D8 = dataobjs.CData;
xprofile8 = D8(250,:);
%yprofile = D(:,250);
location = [1:500]*10;

%% calculate signal to background and plot vs D
Max3 = max(max(D3));
B3 = D3;
B3(235:265,235:265) = 0;
S3 = sum(B3, 'all');
M3 = S3/(500*500-80*80);
SB3 = Max3/M3;

Max6 = max(max(D6));
B6 = D6;
B6(235:265,235:265) = 0;
S6 = sum(B6, 'all');
M6 = S6/(500*500-80*80);
SB6 = Max6/M6;

Max7 = max(max(D7));
B7 = D7;
B7(235:265,235:265) = 0;
S7 = sum(B7, 'all');
M7 = S7/(500*500-80*80);
SB7 = Max7/M7;

Max8 = max(max(D8));
B8 = D8;
B8(235:265,235:265) = 0;
S8 = sum(B8, 'all');
M8 = S8/(500*500-80*80);
SB8 = Max8/M8;

figure
plot([1e6, 1e7, 1e8], [SB6, SB7, SB8])
 set(gca, 'Xscale', 'log')

%% plot traces on single plot
figure
hold on
drawShadedRectangle([2400,2600],[0,7e6], [0.85, 0.85, 0.85], [0.85,0.85,0.85], [0.85,0.85,0.85], [0.85,0.85,0.85], 'vertical');
a = plot(location, xprofile3, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);
b = plot(location, xprofile6, 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
c = plot(location, xprofile7, 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 2);
d = plot(location, xprofile8, 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2);
grid
xlabel('Location (nm)', 'FontSize', 14)
ylabel('Fluorescence (AU)', 'FontSize',14)
%title('D = 10^3 nm^2/s', 'FontSize', 14)
legend([a,b,c,d],'D = 10^3 nm^2/s', 'D = 10^6 nm^2/s','D = 10^7 nm^2/s','D = 10^8 nm^2/s',"FontSize", 14)
box 
hold off