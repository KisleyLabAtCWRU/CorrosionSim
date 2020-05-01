function [movies] = CreateMovie(data, frameRate, filename, startTime, timestep, unit)
%create and save a movie of pit initiation progression
%data is a 3D matrix

%set image size, frames for movie
[szx, szy, nsteps] = size(data);
movies = [];

if strcmp(unit, 'hours')== 1
    factor = 60*60;
elseif strcmp(unit, 'seconds')== 1
    factor = 1;
elseif strcmp(unit, 'minutes')== 1
    factor = 60;
elseif strcmp(unit, 'days') == 1
    factor = 24*60*60;
else 
    error('Error, unit must be seconds, minutes, hours, or days')
end

i=1;
clim = [0, 1];
figure
while i<=nsteps
    imagesc(data(:,:,i), clim)
    set(gcf,'Colormap',hot)
    axis image
    set(gca,'xtick',[],'ytick',[])
    text(10,szy-20,string(startTime/factor+timestep*(i-1)/factor)+ ' ' + unit,'FontSize', 14, 'color', 'white')
    i=i+1;
    movies=[movies getframe];
end

writerObj = VideoWriter(strcat(filename,'.avi'));
writerObj.FrameRate = frameRate;
open(writerObj);
writeVideo(writerObj,movies);
close(writerObj);

