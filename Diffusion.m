%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Simulation of diffusion of fluorescent dyes in imaging plane of        %  
%  fluorescent microscope including a hit rate from bulk solution to      %  
%  imaging plane                                                          %  
%  Linked to a simulation of corrosion. Dyes will turn on with different  %
%  mechanisms depending on whether they reactin at cathode or anode of    %
%  corrosion reaction                                                     %  
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dyeTracker, turnOnLocs, diffusionMovie, diffusionFig, onLocs, dyeProps,  labelNumber] = Diffusion(startTime, T, dT, px, pxsize, Conc, D, sensMax, sensSigma, CA, cathLoc, frameRate, dye, ironProb, diffusionMovie, diffusionFig, linked)
%% set dye parameters
dimA=0.1; %Amplitude of the non-fluorescent molecules
sigmax=5; %width of the dye guassian in movie in pixels
StepSize=sqrt(2*2*D*dT)/pxsize; %RMSD = sqrt(MSD) = sqrt(2*n*D*T) where n is number of dimensions, in pixels
surfA=(px*pxsize*1e-9)^2; %Sample surface area in m2
HitRate=(1000)*surfA*Conc*sqrt(D*1e-18/(pi*dT))/2*6.023e23*dT; %Hitting Rate in # of molecules/dT (factor of 1000 to get from L to m^3
UncerHR=0.1; % Uncertainity in hitting rate, represented as percentage
Numb=0.1; %Initial number of molecules present in the frame, multiple of Hitrate %???
r1=round(HitRate*(1+Numb)); %initial number of dyes in frame
    %neither Numb or r1 are currently in use

%if r1~=0
%    m = randi([1 px],r1,1); %Creating random coordinates for dye molecules
%    n = randi([1 px],r1,1); % m is for abscissa (x) and n is for ordinate (y)
%    A = ones(size(m))*dimA;
%    dyeProps = [m,n,A,N];
%else
%    dyeProps = [];
%end
[dyeProps, ~] = MoveDyesNormalOnDyesBackIn([], dimA, HitRate, UncerHR, px, pxsize, StepSize, Conc, 0); %create initial dye positions
dyeSens = zeros(sensMax/pxsize); %create dye sensitivity 2D gaussian
for i = 1:sensMax/pxsize
    for j = 1:sensMax/pxsize
        dyeSens(i,j) = Gauss2D(i,j,ceil(sensMax/pxsize/2),ceil(sensMax/pxsize/2), sensSigma/pxsize,1);
    end
end          
dyeOn = zeros(1000,3); %matrix for saving turn on locations and times, needs to be longer than the amount of turn on events we predict will occur
dyeCounter = 1;
dyeTracker = zeros(T,2); %First column is dyes that are on in each frame, second is total dyes in each frame
onLocs = []; % cell array that will save matrix of ALL fluorescent dye locs at each time

%% run rules
for t=1:T
    disp(t)
    l = 1;
    [cm, cn] = size(cathLoc);
    while l <= size(dyeProps,1)
        if dyeProps(l,3) >= 0.8
            alreadyOn = true;
        else
            alreadyOn = false;
        end
        if strcmp(dye, 'Resazurin') == 1 %if using resazurin which turns on at cathode
            if CA(round(dyeProps(l,1)), round(dyeProps(l,2))) == 1 %finds nearest pit edge if not over pit
                [dist, M1, N1] = (NearestNNVariableNeighborhood(CA, [dyeProps(l,1),dyeProps(l,2)], 2, ((cn+sensMax/pxsize)/2)-1)); %distance to nearest pit
            elseif CA(round(dyeProps(l,1)), round(dyeProps(l,2))) == 2 %finds nearest pit edge if over pit
                [dist, M1, N1] = (NearestNNVariableNeighborhood(CA, [dyeProps(l,1),dyeProps(l,2)], 1, ((cn+sensMax/pxsize)/2)-1)); %distance to nearest pit
            end
            if ~isnan(M1)
                
                cathLoc1 = AdjCathLoc(M1, N1,(dyeProps(l,1:2)), CA, cathLoc); %adjust cathLoc distribution to set prob 0 over pit
                C1 = conv2(cathLoc1, dyeSens);
                C = C1/max(max(C1));
                zeroInd = ceil(cm/2)+floor(sensMax/pxsize/2);
                Prob = C(zeroInd-M1,zeroInd-N1); %the index of the pit with respect to the dye
                                        %is [M1, N1] so the index of dye with
                                        %respect to pit is [-M1, -N1] and we
                                        %will use that to determine where in
                                        %conv we go
            else 
                Prob = 0;
            end
        else %dye that detects iron ions, turns on with prob ironProb when above pit
            if CA(round(dyeProps(l,1)), round(dyeProps(l,2))) == 2
                Prob = ironProb;
            else
                Prob =0;
            end
        end
        Rdye = rand;
        if Rdye<Prob && alreadyOn == false %&& CA(dyeProps(l,1), dyeProps(l,2)) ~= 2
            dyeProps(l,3) = 1; %dye turns on
            dyeOn(dyeCounter, 1) = dyeProps(l,1); dyeOn(dyeCounter, 2) = dyeProps(l,2);
            dyeOn(dyeCounter, 3) = t*dT;
            dyeCounter = dyeCounter+1;
        end
        l = l+1;
    end   
    dyeTracker(t,1) = length(find(dyeProps(:,3) >= 0.8));
    dyeTracker(t,2) = size(dyeProps,1);
    PerOn = dyeTracker(t,1)/dyeTracker(t,2);
    %if linked == false
    %diffusionMovie=CreateFrameDiffusion(dyeProps,px,sigmax,diffusionMovie, diffusionFig, startTime, dT, frameRate,CA, 'true'); %Creates the moved frame
    %end
    offInds = find(dyeProps(:,3)<=0.4);
    S1 = size(dyeProps,1);
    onDyes = zeros(S1, 5);
    onDyes(:, 1:4) = dyeProps;
    onDyes(:,5) = t;
    onDyes(offInds,:) = []; %delete not turned on dyes in the onDyes matrix
    onLocs = [onLocs;onDyes];
    [dyeProps, labelNumber] = MoveDyesNormalOnDyesBackIn(dyeProps, dimA,HitRate,UncerHR,px, pxsize, StepSize, Conc, PerOn);
end

%% create datasets and save files
Dinds = nonzeros(dyeOn);
turnOnLocs = reshape(Dinds, length(Dinds)/3,3); %the locations and times at which a dye turns on
turnOnLocs(:,3) = turnOnLocs(:,3) - dT;
end