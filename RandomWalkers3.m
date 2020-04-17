%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program simulates frames of random walkers. All aspects %
%  of the walking can be tuned by changing the variables below  %
%  Pay attention to the comments when changing the current      %
%  default numbers. Right now 3 kinds of random walks can be    %
%  simulated based on - Normal, Poisson & Binomial Distribution %
%                                                               %
%  Main output is the variable "frame" saved in the workspace   %
%  This variable is also saved to the disk                      % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Frame Parameters

A=1; %Amplitude of the Source
r=20; %Number of walkers   ~~~ Not Used in this Version ~~~
Conc=5e-9; %Dye concentration in Moles/L
px=500; %Image size in Pixels
pxsize=100; %Pixel Size in nm
sigmax=5; %width of the guassian in pixels
nsteps=200; %Number of steps

%% Diffusion Parameters
dT=0.01; %Time between steps in seconds
D=50e6; % Diffusion constant D (in nm^2/s based on 100 nm pixel size, 0.01 s/frame)
StepSize=sqrt(2*D*dT)/pxsize; %average step size in pixels

Type=1; % 1 = Normal Distribution for walking distances
        % 2 = Poisson Distribution for walking distances
        % 3 = Binomial Distribution for walking distances
        
%% Parameters For calculating Hitting Rate - from https://doi.org/10.3762%2Fbjnano.9.74)
surfA=(px*pxsize*1e-9)^2; %Sample surface area in m2

HitRate=round(surfA*Conc*sqrt(pi*D*1e-18/dT)/2*6.023e23*dT); %Hitting Rate in # of molecules/dT

UncerHR=0.1; % Uncertainity in hitting rate, represented in %


% This HitRate represents the number of molecules hitting the surface of
% the glass in each step and also the number of molecules leaving.
% We can also use this to figure out the initial number of
% molecules present in the imaging plane.

Numb=0.5; %Initial number of molecules present in the frame, multiple of Hitrate!
r1=round(HitRate*(1+Numb));



%% Code specific parameters

Display = false; % true will display the images of walkers, false will not.
                % Displaying images of walkers on slower machines or large
                % variables might crash matlab.
                
SaveFile = true; % true will save the output frames as a matfile.

% Defining the filename to be used

if Type == 1
    Filename = sprintf('%d-nM-Concentration_%d-steps_Normal.mat',Conc*1e9,nsteps);
elseif Type == 2
    Filename = sprintf('%d-nM-Concentration_%d-steps_Poisson.mat',Conc*1e9,nsteps);
elseif Type == 3
    Filename = sprintf('%d-nM-Concentration_%d-steps_Binomial.mat',Conc*1e9,nsteps);
end

%% Running the Code

if Type == 1
    [frame,sz]=NormalWalkers3(A,r1,HitRate,UncerHR,px,sigmax,nsteps,StepSize,Display);
elseif Type == 2
    [frame]=PoissonWalkers3(A,r1,HitRate,px,sigmax,nsteps,StepSize,Display);
elseif Type == 3
    [frame]=BinomialWalkers3(A,r1,HitRate,px,sigmax,nsteps,StepSize,Display);
else
    fprintf('Distribution type is invalid, please check \n')
end

save(Filename, 'frame') %Saving the variable to disk