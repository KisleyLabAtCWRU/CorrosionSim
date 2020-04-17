function [frame,sz]=NormalWalkers3(A,r1,HitRate,UncerHR,px,sigmax,nsteps,StepSize,Display)


m = randi([1 px],1,r1); %Creating random coordinates for dye molecules
n = randi([1 px],1,r1); % m is for abscissa (x) and n is for ordinate (y)

%[frame(:,:,1)]=CreatingFrame(A,r1,px,sigmax,m,n); % Creates the first frame 
                                                 % with dye molecules at 
                                                 % initial locations 

% if Display == true % Displays the frame
% pause on;
% hold on;
% imagesc([1,px-1],[1,px-1],frame(:,:,1));
% pause(1/1000);
% else
% end

frame=zeros(px,px,nsteps);
sz=zeros(1,nsteps);

for i = 1:nsteps
    
    fprintf('Step Number %d \n',i)
    
    if size(m,2) < HitRate+1
    else
    for j = 1:HitRate               % Deleting dye molecules that leave the frame
        deldye=randi([1,size(m,2)]);
        m(deldye)=[];
        n(deldye)=[];
    end
    end
    
    r=size(m,2);
    mshift=randn(r,1)+StepSize; % Generates the distance to be moved
    nshift=randn(r,1)+StepSize;
    mdir=randi([0,1],1,r); % Generate the direction in which to move
    ndir=randi([0,1],1,r);
for j = 1:r
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

HR1=round(randn(1)*HitRate*UncerHR);

m1 = randi([1 px],1,HitRate+HR1);  %Creating random coordinates for new dye molecules Hitting the imaging plane
n1 = randi([1 px],1,HitRate+HR1);  % m1 is for abscissa (x) and n1 is for ordinate (y)

m=cat(2,m,m1);
n=cat(2,n,n1);

[frame(:,:,i)]=CreatingFrame(A,r,px,sigmax,m,n); %Creates the moved frame

sz(i)=size(m,2);

if Display == true
imagesc([1,px-1],[1,px-1],frame(:,:,i));
pause(1/1000);
else
end

end
