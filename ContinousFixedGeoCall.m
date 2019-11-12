function [C0fixanalyticalcontPB,C0fixanalyticalDiscretePB]  = ContinousFixedGeoCall(S0,K,r,vol,n)


   
    T = n/253;
    
    vol0 = vol/(sqrt(3));
    q0 = 0.5*(r+0.5*(vol0^2));
    
    d2 = (log(S0/K)+0.5*(r-0.5*(vol^2))*T)/(vol0*sqrt(T));
    d1 = d2 + (vol0*sqrt(T));
    C0fixanalyticalcontPB= S0*exp(-q0*T)*normcdf(d1)-K*exp(-r*T)*normcdf(d2); 
    
    
    dt = T/n;
    Tn = 0.5*(n+1)*dt;
    TnHat = dt*(((n+1)*(2*n + 1))/(6*n));
    
    qn = r - ((r -0.5*(vol^2))*Tn/T) - (0.5*(vol^2))*(TnHat/T);
    
    d4 = (log(S0/K)+(r-0.5*(vol^2))*Tn)/(vol*sqrt(TnHat));
    d3 = d4 + (vol*sqrt(TnHat));
    C0fixanalyticalDiscretePB = S0*exp(-qn*T)*normcdf(d3)-K*exp(-r*T)*normcdf(d4);
