function [frame] = CreateFrameCorrosion(fig, movie, A, startTime, timeStep, frameRate, dyeOn, plotTurnOns)
%creates a movie frame of the corrosion simulation

[px, py] = size(A);
figure(fig)
clim = [1, 3];
map = [0 0 0  %M = black, C = gray
       0.5 0.5 0.5];
imagesc(A, clim);
set(gcf,'Colormap',map);
axis image;
set(gca,'xtick',[],'ytick',[]);
c.Ticks = [1.5 2.5];
c.TickLabels = {'M', 'C'};

if plotTurnOns == true %will plot x's for turn on events as they happen
    hold on
    if ~isempty(dyeOn)
        D = nonzeros(dyeOn);
        Turn_on_locs = reshape(D, length(D)/3,3);
        scatter(Turn_on_locs(:,2),Turn_on_locs(:,1), 50, 'red', 'x')
    end
    hold off
end

%add time marker, which will change every second of real time
persistent FrameNumCorr
if isempty(FrameNumCorr)
    FrameNumCorr = 0;
end
timeText = startTime+timeStep*(FrameNumCorr-rem(FrameNumCorr,frameRate));
text(10,px-20,string(timeText)+ ' seconds','FontSize', 14, 'color', 'white') ;
frame = [movie getframe];
FrameNumCorr = FrameNumCorr +1;
end