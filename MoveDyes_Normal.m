function [dyeProps, LN] = MoveDyes_Normal(dyePropsOld, dimA,HitRate,UncerHR,px,StepSize)
%This function removes, moves, and adds dyes for one timestep and returns
%an array containing the x and y coordinates of the dyes,
%their amplitudes, and a label of what number dye they are. 
%Uses normal distribution of step sizes

persistent labelNumber %this will keep a tally of the total number of dyes that have been in the frame at any point
if isempty(labelNumber)
    labelNumber = 0;
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
HR2=randi([round(HitRate-HitRate*UncerHR), round(HitRate+HitRate*UncerHR)])+length(delDye1); %to account for two dimensional coming into and out of field of view

m1 = (px-1).*rand(HR2,1)+1;%Creating random coordinates for new dye molecules Hitting the imaging plane
n1 = (px-1).*rand(HR2,1)+1;  % m1 is for abscissa (x) and n1 is for ordinate (y)
A1 = dimA*ones(HR2,1);
N1 = zeros(HR2,1);
for q=1:HR2
    N1(q) = labelNumber;
    labelNumber = labelNumber+1;
end

LN = labelNumber;
m=cat(1,m,m1); % Combining new and old molecules coordinates
n=cat(1,n,n1);
A = cat(1,A,A1);
N = cat(1, N, N1);

dyeProps = [m,n,A,N];
end