tic
folderBase = 'C:\Users\User\Documents\MessengerCorrosionSim\CorrosionSim_20201112\SimulationResults\';
    %location of the data folder
folderName = '17-Nov-2020_DiffusionCoefficientFlow_';
    %name of the folder and begining of file names (assuming it has been
    %saved automatically by the model, the folder name and file names will
    %be the same)
filelabel = {''};
    %if there is a label or additional part of the file name it can be
    %here. By making this an array you can loop through multiple folders
    %from the same date
for i = 1 %loop through multiple folders if you want
    onLocs = [];
    for g = 1:30 % this loops through each chunk of data, since data is save in 100 time step chunks to speed up simulation
        Folder = strcat(folderBase,folderName, filelabel{i});
        OL = load(strcat(Folder, '\', folderName,filelabel{i},sprintf('_OnLocations1_%d.mat', g*100)));
        onLocs = [onLocs;OL.onLocs]; %cobined on locations for whole simulation
    end
    turnOnLocs = dlmread(strcat(Folder, '\', folderName, filelabel{i}, '_turnOnLocs1'));
    dyeTracker = dlmread(strcat(Folder, '\', folderName, filelabel{i}, '_dyeTracker1'));
    MetaData = load(strcat(strcat(Folder, '\', folderName, filelabel{i},'_MetaData.mat')));
    CA = dlmread(strcat(Folder, '\', folderName, filelabel{i}, '_CA1'));
    LN = onLocs(end, 4); %this is the total number of dyes that entered the frame at any point during the sim
    Total = sum(dyeTracker(:,2)); %this is the sum of the number of dyes (on and off) in each frame
    timeSpent = Total/LN; %this represents the average time spent in the frame by each dye

    onTotal = size(onLocs,1); %this represents the sum of the number of ON dyes in every frame
    onLN = size(turnOnLocs,1); %this is the total number of turn on events
    timeSpentOn = onTotal/onLN; %this is the average time spent in the frame by fluorescents

    Time.LN = LN;
    Time.Total = Total;
    Time.timeSpent = timeSpent;
    Time.onLN = onLN;
    Time.onTotal = onTotal;
    Time.onTimeSpent = timeSpentOn;
    Time.units = 'time steps';

    save(strcat(Folder,'\',folderName, filelabel{i},'_TimeData'),'-struct', 'Time');
        %save the struct of time spent data to folder with appropriate
        %file name

    %find distances from corrosion site for each on location
    [a,b] = size(onLocs);
    D = zeros(1,a);
    for k=1:a
        m = onLocs(k,1);
        n = onLocs(k,2);
        if CA(floor(m),floor(n)) == 1
            [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 2, 500);
        elseif CA(floor(m),floor(n)) == 2
            [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 1, 500);
            dist = -1*dist;
        end
        D(k) = dist;
    end

    %find distance from corrosion site for each turn on locations
    [c,d] = size(turnOnLocs);
    turnOnD = zeros(1, c);
    for l = 1:c
        m = turnOnLocs(l,1);
        n = turnOnLocs(l,2);
        if CA(floor(m),floor(n)) == 1
            [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 2, 200);
        elseif CA(floor(m),floor(n)) == 2
            [dist, ~, ~] = NearestNNVariableNeighborhood(CA, [m,n], 1, 200);
            dist = -1*dist;
        end
        turnOnD(l) = dist;
    end
    
    %save distance and on loc data
    dlmwrite(strcat(Folder,'\',folderName, filelabel{i},'_AllDists'), D);
    dlmwrite(strcat(Folder,'\',folderName, filelabel{i}, '_turnOnDists'), turnOnD);
    dlmwrite(strcat(Folder,'\',folderName, filelabel{i}, '_onLocs'), onLocs);

    %print when analysis of one folder is done to keep track
    sprintf('trial %d complete', i)
end  
toc
beep;

