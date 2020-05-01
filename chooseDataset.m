function [a, b, unit, factor, histUnit] = chooseDataset(input)
%select from the three datasets in the Valor paper that proved shape and
%scale parameter values and choose appropriate unit for the movie and
%histogram

if input == 1
    %Choose Aziz dataset 
    a = 17.27;
    b = 4.79;
    unit = 'hours';
    factor = 60*60;
    histUnit = 'days';
elseif input == 2
    %choose Strutt dataset
    a = 0.007325;
    b = 0.998;
    unit = 'seconds';
    factor = 1;
    histUnit = 'hours';
elseif input == 3
    %Choose Melchers dataset
    a = 234;
    b = 5.39;
    unit = 'days';
    factor = 60*60*24;
    histUnit = 'days';
else
    error('Error: input must be 1, 2, or 3')
end
