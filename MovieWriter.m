function [] = MovieWriter(movie, filename, frameRate, path)
%writes movie data in movie to a file 
writerObj = VideoWriter(char(string(strcat(path,filename,'.avi'))));
writerObj.FrameRate = frameRate;
open(writerObj);
writeVideo(writerObj,movie);
close(writerObj);
end