function [H] = createHist(data, unit, fileName)
%create a histogram of initiation times stored in data displayed in 'unit's
%and save as fileName

if strcmp(unit, 'hours')== 1
    factor = 60*60;
elseif strcmp(unit, 'seconds')== 1
    factor = 1;
elseif strcmp(unit, 'minutes')== 1
    factor = 60;
elseif strcmp(unit, 'days') == 1
    factor = 24*60*60;
else 
    error('Error: unit must be seconds, minutes, hours, or days')
end

figure
H = histogram(data/(factor), 100, 'Normalization', 'pdf');
xlabel('Pit Initiation Time (' + string(unit) + ')');
saveas(H, fileName');
