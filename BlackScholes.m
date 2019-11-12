function c0 = BlackScholes(S0,K,r,vol,n)

%Calculating The European Call Option Black Scholes Analytical Pirce
    T = n/253;
    d1 = (log(S0/K)+(r+0.5*(vol^2))*T)/(vol*sqrt(T));
    d2 = d1 - (vol*sqrt(T));
    c0 = S0*normcdf(d1)-K*exp(-r*T)*normcdf(d2);
end