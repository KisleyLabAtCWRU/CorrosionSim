%create figures of time spent in frame by dyes, on locations scatters,
%fluorescence heat maps, and histograms of distances from corrosion
%locations

%% select folders for analysis
%this was written to analyze data from 4 folders, each for a different
%diffusion coefficient, it can be adapted to do more or less
folderBase = 'C:\Users\Hannah\Documents\CWRU\2020_SeniorProject\Fall 2020\CorrosionModelVer5_Files\SimulationResults\';
folderName = '17-Nov-2020_DiffusionCoefficientFlow_';
diffusionCoefficient = {'1e3', '1e6_1', '1e7_1', '1e8_1'};
pxsize = 10;
CA = load(strcat(folderBase,folderName, diffusionCoefficient{1},  '\', folderName, diffusionCoefficient{1},  '_CA1')); 
%assumes this was for a static corrosion layer, that was the same for each
%trial. If not the case, load the CA for each folder and be sure it is used
%in the appropriate places
%% load info for average time spent
Time3 = load(strcat(folderBase,folderName, diffusionCoefficient{1},'\',folderName,diffusionCoefficient{1},'-_TimeData.mat'));
Time6 = load(strcat(folderBase,folderName, diffusionCoefficient{2},'\',folderName,diffusionCoefficient{2},'-_TimeData.mat'));
Time7 = load(strcat(folderBase,folderName, diffusionCoefficient{3},'\',folderName,diffusionCoefficient{3},'_TimeData.mat'));
Time8 = load(strcat(folderBase,folderName, diffusionCoefficient{4},'\',folderName,diffusionCoefficient{4},'_TimeData.mat'));


AllDists3 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{1},'\',folderName,diffusionCoefficient{1},'-_AllDists'));
AllDists6 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{2},'\',folderName,diffusionCoefficient{2},'-_AllDists'));
AllDists7 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{3},'\',folderName,diffusionCoefficient{3},'_AllDists'));
AllDists8 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{4},'\',folderName,diffusionCoefficient{4},'_AllDists'));

turnOnDists3 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{1},'\',folderName,diffusionCoefficient{1},'-_turnOnDists'));
turnOnDists6 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{2},'\',folderName,diffusionCoefficient{2},'-_turnOnDists'));
turnOnDists7 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{3},'\',folderName,diffusionCoefficient{3},'_turnOnDists'));
turnOnDists8 = dlmread(strcat(folderBase,folderName, diffusionCoefficient{4},'\',folderName,diffusionCoefficient{4},'_turnOnDists'));

onLocs3 = load(strcat(folderBase,folderName, diffusionCoefficient{1},'\',folderName,diffusionCoefficient{1},'_onLocs'));
onLocs6 = load(strcat(folderBase,folderName, diffusionCoefficient{2},'\',folderName,diffusionCoefficient{2},'_onLocs'));
onLocs7 = load(strcat(folderBase,folderName, diffusionCoefficient{3},'\',folderName,diffusionCoefficient{3},'_onLocs'));
onLocs8 = load(strcat(folderBase,folderName, diffusionCoefficient{4},'\',folderName,diffusionCoefficient{4},'_onLocs'));

timeSpent = [Time3.timeSpent, Time6.timeSpent, Time7.timeSpent, Time8.timeSpent];
timeSpentOn = [Time3.onTimeSpent, Time6.onTimeSpent, Time7.onTimeSpent, Time8.onTimeSpent];

D = [1e3, 1e6, 1e7, 1e8];

%% average time spent figure
fig1 = figure
scatter(D, timeSpentOn*0.05, 75,'x', 'LineWidth', 1.5)
hold on
scatter(D, timeSpent*0.05, 75 , 'LineWidth', 1.5)
yline(0.05)
legend('Turned-on Dyes', 'All Dyes', 'Time Step Length')
grid MINOR
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
%ylim([0,0.5])
xlabel('Diffusion Coefficient (nm^2/s)')
ylabel('Average Time Spent in Frame')
ylabel('Average Time Spent in Frame (s)')
box on
hold off

%% fluorescent location scatter figures
%(if CA is different for different trials be sure to adjust that here)
FluorescentLocsFigure(CA, onLocs3)
FluorescentLocsFigure(CA, onLocs6)
FluorescentLocsFigure(CA, onLocs7)
FluorescentLocsFigure(CA, onLocs8)

%% Heat maps
%clims sets min and max values on colobars, will be in log scale
px = 500;
sigmax = 5; %width of gaussian around each dye
clims = [10, 5e6];
HeatMap(onLocs3, px, sigmax, clims)
HeatMap(onLocs6, px, sigmax, clims)
HeatMap(onLocs7, px, sigmax, clims)
HeatMap(onLocs8, px, sigmax, clims)

%% stacked histogram
%this creates histograms in one figure to compare fluorescent distances
%between diffusion coefficients. A gray shaded box shows cathode location
%standard deviation

cathLocStd = 100; %in nm
gr = 0.5; %shade of gray for box

fig0 = figure
t = tiledlayout(4,1)
ax1 = nexttile;
[T3, edges3] = NormalizedHistogram(AllDists3);
cla
drawShadedRectangle([0,cathLocStd],[0,1.2], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], 'vertical')
                                    %height of gray box will need to be
                                    %manually adjusted for each
hold on
histogram('BinEdges', edges3*pxsize, 'BinCounts', T3, 'Normalization', 'count', 'FaceColor', [0, 0.4470, 0.7410])
hold off
title('D = 10^3 nm^2/s', 'FontSize',  13, 'FontName', 'Calibri')
xlim([0,3750])
%set(gca, 'Yscale', 'log')
box on

ax2 = nexttile;
[T6, edges6] = NormalizedHistogram(AllDists6);
cla
drawShadedRectangle([0,cathLocStd],[0,10], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], 'vertical')
hold on
histogram('BinEdges', edges6*pxsize, 'BinCounts', T6, 'Normalization', 'count', 'FaceColor',[0.8500, 0.3250, 0.0980])
hold off
title('D = 10^6 nm^2/s', 'FontSize',  13, 'FontName', 'Calibri')
xlim([0,3750])
%set(gca, 'Yscale', 'log')
box on

ax3 = nexttile;
[T7, edges7] = NormalizedHistogram(AllDists7);
cla
drawShadedRectangle([0,cathLocStd],[0, 50], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], 'vertical')
hold on
histogram('BinEdges', edges7*pxsize, 'BinCounts', T7, 'Normalization', 'count', 'FaceColor',[0.4940, 0.1840, 0.5560])
hold off
title('D = 10^7 nm^2/s', 'FontSize',  13, 'FontName', 'Calibri')
xlim([0,3750])
%set(gca, 'Yscale', 'log')
box on

ax4 = nexttile;
[T8, edges8] = NormalizedHistogram(AllDists8);
cla
drawShadedRectangle([0,cathLocStd],[0,50], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], [gr, gr, gr], 'vertical')
hold on
histogram('BinEdges', edges8*pxsize, 'BinCounts', T8, 'Normalization', 'count', 'FaceColor',[0.9290, 0.6940, 0.1250])
hold off
title('D = 10^8 nm^2/s', 'FontSize', 13, 'FontName', 'Calibri')
xlim([0,3750])
%set(gca, 'Yscale', 'log')
box on

t.Padding = 'none';
t.TileSpacing = 'none';
linkaxes([ax1, ax2, ax3, ax4], 'x')
xlabel(t, 'Distance from corroded area (nm)', 'FontSize', 15, 'FontName', 'Calibri')
ylabel(t, 'Number of "turned-on" dyes', 'FontSize', 15, 'FontName', 'Calibri')

