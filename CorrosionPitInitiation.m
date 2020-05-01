%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program simulates corrosion pit initiation based on a   %
%  Weibull distribution of initiation time as in Valor et. al   %
%  All times are in days. The sample is represented as a 3D     %
%  matrix in which the first two dimensions represent each      %
%  location on the sample and the third dimension represents    %
%  each locations state at each time step where 0 =not corroded %
%  and 1 = corroded.                                            %
%                                                               %
%  Main output is the avi movie file and histogram image        %
%  Based on Valor et al. doi:10.1016/j.corsci.2006.05.049       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input = 2; %input for choosing dataset
          % 1 = Aziz - hours
          % 2 = Strutt - seconds
          % 3 = Melchers - days
          
[a, b, unit, factor, histUnit] = chooseDataset(input);
px = 500;
timestep = 0.005*factor; %specified in dataset unit and converted to seconds with factor
nsteps = 101;
startTime = 0*factor; %speficied in dataset unit and converted to seconds with factor

Display = false; %true will display sample progression as part of pitInitiation function 
                 %   (for troubleshooting)
makeMovie = true; %true will create and save video file
makeHist = false; %if true will create and save histogram of initiation times

frameRate = 5;
filename = 'Strutt';
histFileName = string(filename) + '_hist.png';

[sample, tk] = pitInitiation(a, b, px, timestep, nsteps, startTime, Display);

if makeMovie == true
    [movies] = CreateMovie(sample, frameRate, filename, startTime, timestep, unit);
end

if makeHist == true
    [H] = createHist(tk, histUnit, histFileName);
end




