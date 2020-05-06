%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program simulates the movement of dye molecules in a        %
%  corrosive environment.                                           %
%                                                                   %
%  Pay attention to the comments when changing the current          %
%  default numbers. Currently only Normal Distribution random       %
%  walk is complete                                                 %
%                                                                   %
%  Main outputs are the variable "frame", "Sample", "sz" and "A"    %
%  are saved in the workspace. These variables are also saved to    %
%  the disk.                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%% Frame Parameters

dimA=0.2; %Amplitude of the non-fluorescent molecules
% r=20; %Number of walkers   ~~~ Not Used in this Version ~~~
Conc=5e-9; %Dye concentration in Moles/L
px=500; %Image size in Pixels
pxsize=100; %Pixel Size in nm
sigmax=5; %width of the guassian in pixelsx
nsteps=2500; %Number of steps

%% Corrosion Pit Parameters
A1=1; %Pit depth in arb dimensions   
pr=20; %Max number of pits (Scale Parameter)
psize=10; %Average size of the pits in pixels (Shape Parameter)
Thres=0.2; %Threshold value for activating the dye


%% Diffusion Parameters
dT=0.02; % Time between steps in seconds
D=4e8; % Diffusion constant D (in nm^2/s based on 100 nm pixel size, 0.01 s/frame)
StepSize=sqrt(2*D*dT)/pxsize; %average step size in pixels

Type=1; % 1 = Normal Distribution for walking distances
        % 2 = Poisson Distribution for walking distances
        % 3 = Binomial Distribution for walking distances
        
%% Parameters For calculating Hitting Rate - from https://doi.org/10.3762%2Fbjnano.9.74)
surfA=(px*pxsize*1e-9)^2; %Sample surface area in m2

HitRate=surfA*Conc*sqrt(D*1e-18/(pi*dT))/2*6.023e23*dT; %Hitting Rate in # of molecules/dT

UncerHR=0.1; % Uncertainity in hitting rate, represented in %


% This HitRate represents the number of molecules hitting the surface of
% the glass in each step and also the number of molecules leaving.
% We can also use this to figure out the initial number of
% molecules present in the imaging plane.

Numb=0.1; %Initial number of molecules present in the frame, multiple of Hitrate!
r1=round(HitRate*(1+Numb));



%% Code specific parameters

Display = true; % true will display the images of walkers, false will not.
                % Displaying images of walkers on slower machines or large
                % variables might crash matlab.
                
SaveFile = false; % true will save the output frames as a matfile.

% Defining the filename to be used

if Type == 1
    Filename = sprintf('%d-DiffusionConstant_%d-steps_Normal.mat',D,nsteps);
elseif Type == 2
    Filename = sprintf('%d-nM-Concentration_%d-steps_Poisson.mat',Conc*1e9,nsteps);
elseif Type == 3
    Filename = sprintf('%d-nM-Concentration_%d-steps_Binomial.mat',Conc*1e9,nsteps);
end

%% Running the Code

[sample]=PitsFrame(A1,pr,px,psize,nsteps,Display); % Creating pits

if Type == 1
    [frame,sz,A]=NormalWalkers4(dimA,Thres,r1,HitRate,UncerHR,px,sigmax,nsteps,StepSize,Display,sample);
elseif Type == 2
    [frame]=PoissonWalkers4(A,r1,HitRate,px,sigmax,nsteps,StepSize,Display);
elseif Type == 3
    [frame]=BinomialWalkers4(A,r1,HitRate,px,sigmax,nsteps,StepSize,Display);
else
    fprintf('Distribution type is invalid, please check \n')
end

if SaveFile == true
    save(Filename.frame, 'frame', 'sample', 'sz', 'A', '-v7.3') %Saving the variable to disk
else
end