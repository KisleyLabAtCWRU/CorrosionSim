function [HR] = Hitrate(D)
%calculate the hitrate as a function of the diffusion coefficient
surfA=(500*10*1e-9)^2;
Conc = 20e-9;
dT = 0.05;
HR = (1000)*surfA*Conc*sqrt(D*1e-18/(pi*dT))/2*6.023e23;
end