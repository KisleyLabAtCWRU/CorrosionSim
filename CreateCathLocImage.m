%create figure showing the cathode location probability distribution around
%a single pit for one fluorophore, requires some manual editing of colormap

px = 500;
pxsize = 10;
pitrad = 15;
M = CreateCirclePit(px, 4);
m = M(px/2-25:end, px/2-25:end);
cathLocMax = 1000; %maximum possible distance for cathodic reaction in nm
cathSigma = 100; %standard deciation for cathloc gaussian in nm
cathLoc = zeros(cathLocMax/pxsize); %cathode location probability matrix
for i=1:cathLocMax/pxsize
    for j = 1:cathLocMax/pxsize
        cathLoc(i,j) = Gauss2D(i,j,ceil(cathLocMax/pxsize/2), ceil(cathLocMax/pxsize/2),cathSigma/pxsize,[]);
    end
end
z = max(max(cathLoc));
cathLoc = cathLoc.*(1/z);
[~,m1,n1] = NearestNNVariableNeighborhood(m, [50,50], 2, 250);
C = AdjCathLoc(m1, n1, [50,50], m, cathLoc);
C(10:12, 10:30) = 1.01;
figure
imagesc(C)
axis image
colorbar
text(10,7, sprintf('%d nm', pxsize*20), 'FontSize', 14,'color', 'white')
x = [50,50+10/sqrt(2)];
y = [50, 50+10/sqrt(2)];
hold on
plot(x,y,'red', 'LineWidth' , 2)
%need to adjust colormap manually to get colorbar to be white