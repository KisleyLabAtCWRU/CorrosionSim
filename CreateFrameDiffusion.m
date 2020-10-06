function Frame=CreateFrameDiffusion(dyeProps,px,sigmax,movie, fig,startTime, timeStep, frameRate,CA, markTime)
%creates a movie frame of the diffusion simulation
frame0 = zeros(px,px);
r = size(dyeProps,1);
m = dyeProps(:,1); n = dyeProps(:,2); A = dyeProps(:,3);
if isempty(sigmax) ==1
    sigmax = 5;
end
for k = 1:r
    for i = 1:px
        for j=1:px
            C = (CA(i,j) - 1)*1e-2;
            if A(k) >= 0.8 %only plot turned on dyes to save time
                G=A(k)*exp(-((i-m(k))^2/(2*sigmax^2)+(j-n(k))^2/(2*sigmax^2)))*randi([9000 11000])/10000;
            else
                G = 0;
            end
            if G > C
                frame0(i,j) = G;
            else
                frame0(i,j) = C;
            end
            if k==1
                frame(i,j)=frame0(i,j);
            else
                frame(i,j)=frame0(i,j)+frame(i,j);
            end
        end
    end
end
if r==0;
    frame = zeros(px,px);
end
figure(fig)
%figure('visible', 'off')
imagesc([1,px],[1,px],frame);
axis image
caxis([0 1.0]);
colorbar;

%add time marker which will change every second of real time
if markTime == true
persistent FrameNumDiff
if isempty(FrameNumDiff)
    FrameNumDiff = 0;
end
timeText = startTime+timeStep*(FrameNumDiff-rem(FrameNumDiff,frameRate));
%text(10,px-20,string(timeText)+ ' seconds','FontSize', 14, 'color', 'white') ;
FrameNumDiff = FrameNumDiff +1;
end
Frame = [movie getframe];
end