function G = Gauss2D(x,y,mux,muy, sigma,A)
%a 2D gauss function of size [x,y], with center at [mux, muy], standard
%deviation sigma, and amplitude A

if isempty(A)
    A = 1/(2*pi*sigma^2); %normalization as prob density function
end
G = exp(-((x-mux).^2+(y-muy).^2)./(2.*sigma.^2)).*A;
end

