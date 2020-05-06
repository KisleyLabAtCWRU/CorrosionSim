function [frame,sz,A]=NormalWalkers4(dimA,Thres,r1,HitRate,UncerHR,px,sigmax,nsteps,StepSize,Display,sample)


m = randi([1 px],1,r1); %Creating random coordinates for dye molecules
n = randi([1 px],1,r1); % m is for abscissa (x) and n is for ordinate (y)

frame=zeros(px,px,nsteps); % Preassigning
sz=zeros(1,nsteps);

for i = 1:nsteps
    
    fprintf('Step Number %d \n',i)
    
    % Random number of molecules that need to removed within the
    % given uncertainity    
    HR1=randi([round(HitRate-HitRate*UncerHR), round(HitRate+HitRate*UncerHR)]);
        
    for j = 1:HR1  % Deleting dye molecules that leave the frame
        if size(m,2) > 1   % Only delete molecules, if there are any
        deldye=randi([1, size(m,2)]);
        m(deldye)=[];
        n(deldye)=[];
        if i==1
        else
        A(i,deldye)=NaN;
        end
        else
        end
    end
    
    mshift=randn(size(m,2),1)+StepSize; % Generates the distance to be moved
    nshift=randn(size(m,2),1)+StepSize;
    mdir=randi([0,1],1,size(m,2)); % Generate the direction in which to move
    ndir=randi([0,1],1,size(m,2));
    
for j = 1:size(m,2) % Moves the remaining molecules
        if (m(j)+mshift(j)>px) % Boundary conditions, reflects the dye molecule
            m(j)=m(j)-mshift(j); % back at the boundary for abscissa (x)
        elseif (m(j)-mshift(j)<0)
            m(j)=m(j)+mshift(j);
        else
            if mdir(j)==0           % moves the dye molecule based on the variables
                m(j)=m(j)+mshift(j);    % for abscissa(x)
            else
                m(j)=m(j)-mshift(j);
            end
        end
        
        if (n(j)+nshift(j)>px)      % Boundary conditions, reflects the dye molecule
            n(j)=n(j)-nshift(j);    % back at the boundary for ordinate (y)
        elseif (n(j)-nshift(j)<0)   
            n(j)=n(j)+nshift(j);
        else
            if ndir(j)==0
                n(j)=n(j)+nshift(j);
            else
                n(j)=n(j)-nshift(j);
            end
        end
end

    % Random number of molecules that need to added within the
    % given uncertainity
    HR1=randi([round(HitRate-HitRate*UncerHR), round(HitRate+HitRate*UncerHR)]);

m1 = randi([1 px],1,HR1);  %Creating random coordinates for new dye molecules Hitting the imaging plane
n1 = randi([1 px],1,HR1);  % m1 is for abscissa (x) and n1 is for ordinate (y)

m=cat(2,m,m1); % Combining new and old molecules coordinates
n=cat(2,n,n1);

for j = size(m,2)-size(m1,2):size(m,2) % Making new molecules non-fluorescent.
    A(i,j)=dimA;
end

for j = 1:size(m,2) % Setting amplitudes of the dye molecules based on their location
    pitx=round(m(j));
    pity=round(n(j));
    
    if pitx==0  % To get rid of the error if the molecule is at the edge
        pitx=1;
    end
    if pity==0
        pity=1;
    end
    
    if sample(pitx,pity,i)>Thres % Setting the amplitude based on Threshold value
        A(i,j) = 1;
    else
        if A(i,j)==1
        else
        A(i,j) = dimA;
        end
    end
end

[frame(:,:,i)]=CreatingFrame(A,size(m,2),px,sigmax,m,n,i); %Creates the moved frame

A(i+1,:)=A(i,:); % Saves the amplitude of the molecules

sz(i)=size(m,2); % Saves the number of molecules

if Display == true
imagesc([1,px-1],[1,px-1],frame(:,:,i));
caxis([0 1.0]);
pause(1/1000);
else
end

end
