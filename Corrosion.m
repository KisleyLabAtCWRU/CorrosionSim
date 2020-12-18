%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two state, 2D corrosion cellular automaton modeling the initiation and  % 
% growth of corrosion on an iron film. Moore neighborhood of eight nearest% 
% neighbors is used. Two states are:                                      %  
%   M: Metal                                                              %  
%   C: Corroded Metal                                                     %
% Transition rules:                                                       %  
%   Pit initiation:                                                       %  
%       Pin = pit initiation probability per second                       %
%   Pit Growth:                                                           %
%       M -> C with probability Pgr*# of corroded nearest neighbors       %  
%                                                                         %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CA, corrosionTracker, pitLocs, corrosionMovie, corrosionFig] = Corrosion(T, dT, startTime, frameRate, px,pxsize,  Pin, PinUncer, Pgr, CA, turnOnLocs, plotTurnOns, corrosionMovie, corrosionFig, linked)
%% create initial array
if isempty(CA)
    CA = ones(px, px); %initial array of all metal
end
corrosionTracker = zeros(1,T); %track amount of material corroded over time
pits = zeros(px*px,3); %this will save all the site and time at which a pit initiates
pitCounter = 0; %track number of pits

%% run rules
for t=1:T
    disp(t)
    corrosionTracker(t) = length(find(CA == 2)); %record total corroded metal at time t
    if linked == false
        corrosionMovie=CreateFrameCorrosion(corrosionFig, corrosionMovie, CA, startTime, dT, frameRate, turnOnLocs, plotTurnOns);
    end
    Old = CA; %Old is the matrix at t-1
    Pin0 = rand*((Pin+PinUncer*Pin) - (Pin-PinUncer*Pin)) + (Pin-PinUncer*Pin); %random Pin value due to uncertainty
    rin = rand;
    if rin < Pin0*dT*(px*pxsize)^2
        pitCounter = pitCounter+ 1;
        pM = randi([1,px]);
        pN = randi([1,px]);
        CA(pM, pN) = 2; %pit initiations
        pits(pitCounter, 1) = pM; 
        pits(pitCounter, 2) = pN;
        pits(pitCounter, 3) = t*dT;
    end
    %now loop through only the cells that are adjacent to a corroded cell
    %to determine if they corrode
    pitIndex = find(Old == 2);
    [pitM, pitN] = ind2sub([px,px], pitIndex);
    allM = [];
    allN = [];
    for i = 1:length(pitM)
        [a,b] = LocateNNs(Old,[pitM(i), pitN(i)], 1); %locate cells that are adjacent to pit
        allM = [allM; a];
        allN = [allN; b]; %add indices to list of all edges
    end
    for j = 1:length(allM)
        if CA(allM(j), allN(j)) ~=2 %this will eliminate repeats in allM/allN
            numNN = SumMooreNeighborhood(Old, [allM(j), allN(j)], 2);
            r = rand;
            if r<Pgr*numNN
                CA(allM(j), allN(j)) = 2;
            end
        end
    end
end

%% create datasets and save files
P = nonzeros(pits);
pitLocs = reshape(P, length(P)/3,3); %the locations and times at which pit initiation occurs

end