%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main script for model of single-molecule fluorescence microscopy        %  
% corrosion experiment. This script contains inputs for physical and      %
% model parameters and calls corrosion model and diffusion model scripts. %
% Saves data and movies to specified folder. To run corrosion and         %
% diffusion simultaneously, set corrT and diffT to 1, corrdT and diffdT   %
% to the same value, and use loops to specify how many time steps to run. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
tic
%% Set dimensional parameters
px = 500; %number of pixels in each dimension
pxsize = 10; %pixel size in nm
linked = false; %true will run corrosion and diffusion concurrently/simealteaneaously, 
                %false will run corrosion first then diffusion in each overall loop
if linked == false %input desired values 
    diffT = 3000; %number of time steps for diffusion script
    diffdT = 0.02; %length of time step for diffusion in seconds
    corrT = 1800; %number of time steps for corrosion script
    corrdT = 1; %length of corrosion time step in seconds
elseif linked == true
    dT = 0.2; %dT for each loop in seconds. 
    %do not change anything else in this elseif statement
    diffdT = dT;
    corrdT = dT;
    diffT = 1;
    corrT = 1;
end
startTime = 0; 
numLoops = 1; %number of full corrosion and diffusion loops. 
              %if linked = true this is the total time steps of the simulation

%% set corrosion parameters
runCorrosion = false; %true will run corrosion script in each loop, false will not
if runCorrosion == true
    Pin = 5e-11; %probability of initiation per second per nm^2
    PinUncer = 2; %percent uncertainty in Pin 
    Pgr = 0.0005 ; %growth probability per nearest neighbor per second
    %excl = 10; %exclusion zone for pits, the time constant of the exponential representing the exclusion zone probability
                %not currently in use (9/10/2020)
else
    pitrad = 15; %radius of static pit in nm
end
%cathLoc will be used to define a 2D gaussian probability distribution 
%   for the locaion of the cathodic reaction outside a pit
cathLocMax = 500; %maximum possible distance for cathodic reaction in nm
cathSigma = 10; %standard deciation for cathloc gaussian in nm
cathLoc = zeros(cathLocMax/pxsize); %cathode location probability matrix
for i=1:cathLocMax/pxsize
    for j = 1:cathLocMax/pxsize
        cathLoc(i,j) = Gauss2D(i,j,ceil(cathLocMax/pxsize/2), ceil(cathLocMax/pxsize/2),cathSigma/pxsize,[]);
    end
end
%% set dye parameters
runDyes = true; %true will run diffusion in every loop, false will not
if runDyes == true
    Conc=20e-9; %Dye concentration in moles/L
    D=1e8; % Diffusion constant D (in nm^2/s)
    sensMax = 100; %maximum distance in nm at which a dye can react with the cathode
    sensSigma = 1; %standard deviation for the dye sensitivity distribution in nm
    dye = 'Resazurin'; %which dye is being used ('Resazurin' or 'FD1')
    ironProb = 1; %prob that Fe ion detecting dye (like 'FD1') will turn on if over pit
end
turnOnLocs = [];

%% Set file properties
saveMovie = true; %true saves a movie of the CA
saveData = true; %true saves data related to corrosion growth, number of pits, dye turn ons, and number of dyes in view (and more)
plotTurnOns = false; %true will add x's to corrosion movie for turn on events
frameRate = 10; %frames/second
folder = 'C:\Users\User\Documents\MessengerCorrosionSim\CorrosionSim_20201112\SimulationResults'; %folder location where data should be saved
filename = 'FileNameHere';

%% set up folder
if saveData == true
    [Path, filename] = SetUpFolder(folder, filename); 
else
    Path = '';
end

%% initialize data
CA = [];
if linked == true
    if runCorrosion == true
    corrosionTrackerTotal = [];
    pitLocsTotal = [];
    end
    if runDyes == true
    turnOnLocsTotal = [];
    dyeTrackerTotal = [];
    onLocsTotal = [];
    end
end
%% run simulation
clear MoveDyesNormalOnDyesBackIn
for h=1:numLoops
    corrosionMovie = [];
    corrosionFig = figure
    diffusionMovie = [];
    diffusionFig = figure
    sprintf('Loop %d', h)
        clear CreateFrameDiffusion %clear the persistent variable in the CreatingFrame function
        clear CreateFrameCorrosion
    if runCorrosion == true
        sprintf('Corrosion')
        [CA, corrosionTracker, pitLocs, corrosionMovie, corrosionFig] = Corrosion(corrT, corrdT, startTime, frameRate, px, pxsize, Pin, PinUncer, Pgr, CA, turnOnLocs, plotTurnOns, corrosionMovie, corrosionFig, linked);
        if linked ~= true
            startTime = startTime + corrT*corrdT;
        end
        CorrosionRate = corrosionTracker(end-10:end)*pxsize^2*10/10*corrdT; %nm^3/s corrosion rate 
    CRate = CorrosionRate/(0.126^3*pi*4/3); %corrosion rate in atoms of iron (reactions) per second, assuming iron has atomic radius 0.126 nm
    else
        CA = CreateCirclePit(px, pitrad/pxsize); %if not running the corrosion script, create a
                                       %    static pit over which to run
                                       %    diffsion
        CRate = 1e10; %set an "infinite" value for CRate in trials where I am not running corrosion just for now
    end
    
    if runDyes == true
        sprintf('Diffusion')
        if linked == false
            clear MoveDyesNormalOnDyesBackIn
        end
        [dyeTracker, turnOnLocs, diffusionMovie, diffusionFig, onLocs, dyeProps,labelNumber] = Diffusion(startTime, diffT, diffdT, px, pxsize, Conc, D, sensMax, sensSigma, CA, cathLoc, frameRate, dye, ironProb, diffusionMovie, diffusionFig, linked, Path, filename, h, saveData, saveMovie, CRate);
        figOverlay = turnOnOverlay(CA, turnOnLocs);
        if saveData == true
            saveas(figOverlay, strcat(Path, sprintf('Overlay%d.png',h)))
        end
    end
    if runDyes == true || linked == true
        startTime = startTime + diffT*diffdT;
    end
   
    %save data for this loop if not linked, or append data to last loop if
    %linked
    if linked == false
        if saveData == true
            if runCorrosion == true
                dlmwrite(strcat(Path,filename, sprintf('_corrosionTracker%d', h)),corrosionTracker);
                dlmwrite(strcat(Path,filename, sprintf('_pitLocs%d', h)),pitLocs);
                dlmwrite(strcat(Path, filename, sprintf('_CA%d', h)), CA); 
            end
            if runDyes == true
                dlmwrite(strcat(Path, filename, sprintf('_turnOnLocs%d',h)), turnOnLocs);
                dlmwrite(strcat(Path, filename, sprintf('_dyeTracker%d',h)), dyeTracker); 
                save(strcat(Path, filename, sprintf('_OnLocations%d.mat', h)), 'onLocs');
                %clear turnOnLocs dyeTracker onLocs dyeProps
            end
            dlmwrite(strcat(Path,filename, sprintf('_CA%d',h)), CA);
        end
    elseif linked == true
        if runCorrosion == true
        corrosionTrackerTotal = [corrosionTrackerTotal; corrosionTracker];
        pitLocsTotal = [pitLocsTotal; pitLocs];
        end
        if runDyes == true
        turnOnLocsTotal = [turnOnLocsTotal; turnOnLocs];
        dyeTrackerTotal = [dyeTrackerTotal; dyeTracker];
        onLocsTotal = [onLocsTotal; onLocs];
        end
    end
        
    %save movie for this loop if its not linked
    if linked == false && saveMovie == true %creates movie file for each loop
        if runCorrosion == true
            MovieWriter(corrosionMovie,strcat(filename, sprintf('_corrosion%d',h)), frameRate, Path);
        end
        if runDyes == true
            MovieWriter(diffusionMovie,strcat(filename, sprintf('_dye%d',h)), frameRate, Path);
        end
    elseif linked == true
        if runCorrosion == true
            corrosionMovie=CreateFrameCorrosion(corrosionFig, corrosionMovie, CA, startTime, dT, frameRate, turnOnLocs, plotTurnOns);
        end
        if runDyes == true
            diffusionMovie=CreateFrameDiffusion(dyeProps,px,[], diffusionMovie, diffusionFig, startTime, dT, frameRate,CA);
        end
    end
end %end simulation

%% save data and movie for whole run if it is linked
if saveData == true && linked == true
    if runCorrosion == true
        dlmwrite(strcat(Path,filename, sprintf('_corrosionTracker')),corrosionTrackerTotal);
        dlmwrite(strcat(Path,filename, sprintf('_pitLocs')),pitLocsTotal);
    end
    if runDyes == true
        dlmwrite(strcat(Path, filename, sprintf('_turnOnLocs')), turnOnLocsTotal);
        dlmwrite(strcat(Path, filename, sprintf('_dyeTracker')), dyeTrackerTotal); 
        save(strcat(Path, filename, sprintf('OnLocations.mat')), 'onLocsTotal');
    end
    dlmwrite(strcat(Path,filename, sprintf('_CA%d',h)), CA);
end
if saveMovie == true && linked == true
    if runCorrosion == true
        MovieWriter(corrosionMovie, strcat(filename, sprintf('_corrosion')), frameRate, Path);
    end
    if runDyes == true
        MovieWriter(diffusionMovie,strcat(filename, sprintf('_dye')), frameRate, Path);
    end
end
%% Save metadata
if saveData == true || saveMovie == true
    MetaData.pixels = px;
    MetaData.pixelSize = pxsize;
    MetaData.pixelSizeUnits = 'nm';
    MetaData.numLoops = numLoops;
    if runCorrosion == true
        MetaData.corrosionTime = corrT;
        MetaData.corrosionTimeStep = corrdT;
        MetaData.corrosionTimeStepUnits = 's';
        MetaData.Pinitiation = Pin;
        MetaData.percentUncertaintyInPin = PinUncer;
        MetaData.Pgrowth = Pgr;
        %MetaData.exclusionZone = excl; (not currently using exlusion zone
        %(9/11/2020)
    else
        MetaData.Corrosion = 'No Corrosion';
        MetaData.PitRadius = pitrad;
        MetaData.PitRadiusUnits = 'nm';
    end
    if runDyes == true
        MetaData.Dye = dye;
        MetaData.diffusionTime = diffT;
        MetaData.diffusionTimeStep = diffdT;
        MetaData.diffusionTimeStepUnits = 's';
        MetaData.diffusionCoeff = D;
        MetaData.diffusionCoeffUnits = 'nm^2/s';
        MetaData.concentration = Conc;
        MetaData.concentrationUnits = 'M/L';
        MetaData.sensitivity = sensSigma;
        MetaData.sensitivityUnits = 'nm';
        MetaData.cathodeSigma = cathSigma;
        MetaData.cathodeSigmaUnits = 'nm';
    else
        MetaData.dyes = 'no dyes';
    end
    save(strcat(Path, filename,'_MetaData'),'-struct', 'MetaData');
end

%% end
toc
beep on;
beep;