function Frame=HeatMap(onLocs,px,sigmax,clims)
%creates a heatmap of fluoresence locations over a simulation

frame0 = zeros(px,px);
r = size(onLocs,1);
m = onLocs(:,1); n = onLocs(:,2); A = onLocs(:,3);
if isempty(sigmax) ==1
    sigmax = 5;
end
for k = 1:r
    for i = 1:px
        for j=1:px
            G=A(k)*exp(-((i-m(k))^2/(2*sigmax^2)+(j-n(k))^2/(2*sigmax^2)))*randi([9000 11000])/10000;
            frame0(i,j) = G;
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

Frame = figure
imagesc([1,px],[1,px],frame);
axis image
caxis([0 1.01]);
%set(gcf,'Colormap',turbo);
colorbar;
set(gca, 'Cscale', 'log');
caxis(clims)
end