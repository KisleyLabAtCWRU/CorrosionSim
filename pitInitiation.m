function [sample, tk] = PitInitiation(a, b, px, timestep, nsteps, startTime, Display)
%function to create model of pit initiation over time based on Weibull 
%     distribution of initiation times
%a = Weibull scale parameter, b = Weibull shape parameter
%all times are in days

WeibullDistribution = makedist('Weibull', 'a', a, 'b', b); %create Weibull Distribution

[sample] = zeros(px, px, nsteps); %matrix representing state of sample

tk = zeros(px,px); %matrix representing pit initiation time at each location
for i = 1:px
    for j = 1:px
        tk(i,j) = random(WeibullDistribution)*(24*60*60); %sample from Weibull Distribution to find tks and convert from days to seconds
    end
end

t= startTime; 
for T = 1:nsteps  
    for i = 1:px
        for j = 1:px
            if tk(i,j) <= t
                sample(i,j,T)] = 1;
            end
        end
    end
    t = t+timestep;
end    

%figure %display corrosion progression
if Display == true
    for i = 1:nsteps
        imagesc(sample(:,:,i))
        pause(0.25)
    end
end


