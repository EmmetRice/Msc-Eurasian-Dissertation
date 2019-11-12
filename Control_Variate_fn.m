function[YcvBetapt,VarYcvBetaopt,BetaoptHat] = Control_Variate_fn(hX,fX,theta)
    

%hX = C0GTArray the geometric monte carlo price
%fX = C0ATArray the garithmetic monte carlo price
%theta = AnalyGeoPrice

%Note theta can either be continous or discrete - check how similar
%For asian options

%hX is the value of control option each path from MC, its an array
%theta = analytic value of control option, scalar
%fX is the value of arithmetic option each path from MC, array

%assuming Var(h(X)) is not singular (Has inverse) 
%then optimal variance minimzing parameter Beta given by:

m = length ( hX); %ie number of MC paths

%Betaopt = Cov(hX,fX)/Var(hX)
%fXHat = average fX

hXHat = mean(hX);
fXHat = mean(fX);


%Even though know theoretical Var(hX), must use saple from MC due to integrals 
% brack = (hX - hXHat).^2;
% VarhX = (sum(brack))/(m-1);  %m-1 as sample 

[~,~,StdofhX,VarofhX,] = SampleStdVar(hX,hXHat);
[~,~,StdoffX,VaroffX] = SampleStdVar(fX,fXHat);

% CovhXfX = (sum((hX - hXHat)*transpose((fX-fXHat))))/(m-1);
%splitting for ease 
hdash = hX - hXHat;
fdash = fX-fXHat;
hfdash = hdash * transpose(fdash); %transpose for matrix multiplication
CovhXfX = (sum(hfdash))/(m-1);
BetaoptHat = CovhXfX/VarofhX;
%betaopthat must be greater than 1/2 for Var Control to be less than
%Var(FxHat)

%As dont know covariance so estimating it 

%and check error mat hes expected

YcvBetapt = fXHat - BetaoptHat*(hXHat - theta); %ie arithmetic from control variable
%VaCV = VaHat - B(VgeoHat= VgeoAnayltic)

%Taking the variance from the MC is biased as Betaopt is dependant on hX
%and fX. Unbiased if run a pilot sample MC simulation

% rho = corr(hX,fX); %multipliy each aray together and takes the average
%Note as the correlation will be squared, even a negative correlation is
%usable




rho = (CovhXfX)/(StdoffX*StdofhX);

mrat = (m-2)/(m-3);



VarYcvBetaopt = mrat*(1-rho^2)*(VaroffX/m);


%For an unbiased Betaopt run a seperate MC pilot and take betaopt from
%there


end 