%fluorescent dyes coming back in. Will be in two parts. The percentage of
%dyes that come in from the sides (ie within the imaging plane) will be
%determined by the percentage of dyes that are flourescent in frame in the
%previous time step. The percentage of on dyes coming in from the bulk (via
%the hit rate) will be based on the number of dyes that have escaped to the
%bulk - adjusted to account for all sample surface area and tracked with a
%counter

%will need a total volume of liquid, a total surface area of sample, will
%need to be adjusted for flow

function [dyeProps, LN] = MoveDyesNormalOnDyesBackIn(dyePropsOld, dimA,HitRate,UncerHR,px,pxsize, StepSize, Conc, PercOn)
%This function removes, moves, and adds dyes for one timestep and returns
%an array containing the x and y coordinates of the dyes,
%their amplitudes, and a label of what number dye they are. 
%Uses normal distribution of step sizes

Vol = 18e-6; %volume of flow chamber is 18 uL
Area = pi*(13e-3)^2; %diameter of flow chamber is 13mm

persistent labelNumber %this will keep a tally of the total number of dyes that have been in the frame at any point
if isempty(labelNumber)
    labelNumber = 0;
end

persistent BulkOnDyes %this variable keeps track of the number of on dyes that have entered the bulk solution across the whole experiment
if isempty(BulkOnDyes)
    BulkOnDyes = 0;
end

if ~isempty(dyePropsOld) 
    m = dyePropsOld(:,1); %row position
    n = dyePropsOld(:,2); %column position
    A = dyePropsOld(:,3); %amplitude
    N = dyePropsOld(:,4); %label number
else %if there is not already a dyeProps matrix (ie at first diffusion run)
    m = [];
    n = [];
    A = [];
    N = [];
end

%Random number of molecules that need to removed within the given uncertainity 
HR1=randi([round(HitRate-HitRate*UncerHR), round(HitRate+HitRate*UncerHR)]);
    for j = 1:HR1  % Deleting dye molecules that leave the frame
        if size(m,1) > 1   % Only delete molecules, if there are any
            deldye=randi([1, size(m,1)]);
            m(deldye)=[];
            n(deldye)=[];
            for k = 1:size(deldye,2)
                if A(deldye(k)) >= 0.8
                    BulkOnDyes = BulkOnDyes + 1; %add deleted on dyes to counter
                end
            end
            A(deldye)=[];
            N(deldye) = [];
        else
            deldye = NaN;
        end
    end

%mshift=randn(size(m,1),1)+StepSize; % Generates the distance to be moved by each dye
%nshift=randn(size(m,1),1)+StepSize;
%mdir=randi([0,1],1,size(m,1)); % Generate the direction in which to move for each dye
%ndir=randi([0,1],1,size(m,1));
rshift = randn(size(m,1),1) + StepSize; %generates distance to be moved
dir = 2*pi.*rand(size(m,1),1); %generate angle/direction of movement
mshift = rshift.*sin(dir);
nshift = rshift.*cos(dir);


delDye1 = [];
for j = 1:size(m,1) % Moves the remaining molecules
        m(j)=m(j)+mshift(j);
        n(j)=n(j)+nshift(j);

        if m(j) > px || m(j)< 1 %delete dyes that have moved out of the frame
            delDye1 = [delDye1, j];
        elseif n(j) > px || n(j)< 1
            delDye1 = [delDye1, j];
        end
end

m(delDye1,:) = []; %delete dyes that have moved out of frame
n(delDye1,:) = [];
A(delDye1,:) = [];
N(delDye1,:) = [];
%Random number of molecules that need to added within the given uncertainity
HR2=randi([round(HitRate-HitRate*UncerHR), round(HitRate+HitRate*UncerHR)]);
HREdges = length(delDye1);
NewEdges = [randi(px, HREdges, 1), randi(px, HREdges,1)];
a = randi(2, HREdges,1);
for j = 1:HREdges
    while NewEdges(j,a(j)) > StepSize+1 && NewEdges(j,a(j)) < px-StepSize
        NewEdges(j,a(j)) = randi(px);
    end
end
m0 = NewEdges(:,1);
n0 = NewEdges(:,2);

m1 = ((px-1).*rand(HR2,1)+1); %Creating random coordinates for new dye molecules Hitting the imaging plane
n1 = ((px-1).*rand(HR2,1)+1);  % m1 is for abscissa (x) and n1 is for ordinate (y)
OnDyesIn = round(BulkOnDyes*Area/(px*pxsize*1e-9)^2/(Conc*6.022e23*Vol) * HR2); %choose a number of random dyes on this list to be on - based on the BulkOnDyes*SurfArea/ROI/(TotalVolumeDyes*Conc) * HR
A1 = dimA*ones(HR2,1);
if OnDyesIn > 0
    A1(1:OnDyesIn) = 1; %since coordinates are already random I don't need to randomly pick from list which dyes will be on
end
BulkOnDyes = BulkOnDyes - OnDyesIn;
A0 = dimA*ones(size(m0));
OnDyesFromSides = round(length(A0)*PercOn); %choose number of dyes coming in from edges based on percentage of on to off dyes in frame in previous timestamp (this will need to be input to function)
A0(1:OnDyesFromSides) = 1;

N1 = zeros(HR2+HREdges,1);
for q=1:HR2+HREdges
    N1(q) = labelNumber;
    labelNumber = labelNumber+1;
end

LN = labelNumber;
m=cat(1,m,m1, m0); % Combining new and old molecules coordinates
n=cat(1,n,n1, n0);
A = cat(1,A,A1, A0);
N = cat(1, N, N1);

dyeProps = [m,n,A,N];
end