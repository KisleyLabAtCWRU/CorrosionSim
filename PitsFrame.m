function [sample]=PitsFrame(A1,pr,px,psize,nsteps,Display)

% Function to generate Pits uses Weibull random generator built in Matlab.
% Updated on 5/1/2020

PitTimes2=wblrnd(nsteps/pr,nsteps/pr*0.25,1,pr); % Generate occurence times for pits based on Weibul Random Number Generator
PitTimes=zeros(1,pr); % Preassignig variable
for i = 1:pr % Generate actual pit times
    if i == 1
    PitTimes(i)=round(PitTimes2(i));
    else
    PitTimes(i)=PitTimes(i-1)+round(PitTimes2(i));
    end
end

PitSizes=wblrnd(psize,psize*0.25,1,pr); % Generate pit sizes
r1=1;
PitLocation=zeros(2,pr); % Preassigning
sample=zeros(px,px,nsteps);

for i = 1:nsteps % Generate frames for pits
    fprintf('Calculating Pits for Step Number %d \n',i)

    if ismember(i,PitTimes) == true % Only generate pit at PitTimes
    PitLocation(1,r1)=randi([1,500]); % Random location for pit
    PitLocation(2,r1)=randi([1,500]);
    [sample(:,:,i)]=CreatingPits(A1,r1,px,PitSizes,PitLocation);
    r1=r1+1;
    else
        if i == 1
        else
        sample(:,:,i)=sample(:,:,i-1); % Keeping the pits stay in frame, will need to add pit growth here
        end
    end
    
    if Display == true  % Display pits map
    imagesc([1,px-1],[1,px-1],sample(:,:,i));
    caxis([0 1.0])
    pause(1/1000);
    else
    end
    
end
    