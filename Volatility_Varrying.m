%comparing BS and MC for multiple intial stock prices
%CALL OPTION NO DIVIDEND

clear;
disp('Starting Programme')

%vol = 0.2;%input('Enter Volatility of Underliny Asset - ');

ndash = 250; %input('Enter number of TRADING days till maturity - ');%also number of steps
n=ceil(ndash);
T = n/253; %time in fraction of year
dt = T/n;
%r and mu are equal, check why

r = 0.05;%input('Enter equivaelent annual continous intenerest rate r - ');
K = 430;%input('Enter Strike Price - ');
m = 10000;%input('Enter How many monte carlo iterations / paths - ');
S0 = 500;

volstep = 0.01;
numvolsteps = 49;
volend = volstep*numvolsteps;

fprintf('\nStrike Price K:\t %f\nand %d Monte Carlo Path iterations',K,m);
%FinS = input('\nUpper Limit of Initial Stock Price (ranging from 0, Recommend 3xK) - ');
%numvolsteps= FinS+1; %adding 1 as starting loop from 1 not 0
%x=numvolsteps;

Volarr = (0.01:volstep:volend); %vol spread in steps of 0.01 to 0.8



% disp(size(Volarr))
% Volarr0=zeros(1,numvolsteps);
% disp(size(Volarr0))

% disp(Volarr(1))
BSc0=zeros(1,numvolsteps);
MCc0=zeros(1,numvolsteps);
StdofMean=zeros(1,numvolsteps);   %these all use true mean from BS, but could use approx mean MCc0
VarofMean=zeros(1,numvolsteps);
SampleStd=zeros(1,numvolsteps);
SampleVar=zeros(1,numvolsteps);

%need a cell to hold aray of maturityCMC results
MaturityCMCCell = cell(numvolsteps,1);

% disp(BSc0)
% disp(MCc0)
% S0=Volarr(end);
% MCc0(end)= MonteCarloMean(S0,K,r,vol,n,m);
% disp(MCc0(end))

% CMC_Mean(1) = MonteCarloMean(S0,K,r,vol,n,m);
% disp(CMC_Mean)
disp('Running...')

t = cputime;
 for l=1:numvolsteps
     
     vol = Volarr(l);
     
     
%      disp(S0)
    
     BSc0(l) = BlackScholes(S0,K,r,vol,n);
     [MCc0(l), MaturityCMCCell{l}]  = MonteCarloMean(S0,K,r,vol,n,m);
     [StdofMean(l), VarofMean(l)] = SampleStdVar(MaturityCMCCell{l},BSc0(l));
     
     
%      fprintf('BS values\n')
%      disp(BSc0(l))
%      fprintf('\nMC Values\n')
%      disp(MCc0(l))
     
 end 
 
 et = cputime - t;
 fprintf('elapsed time (s):\t %.2f\n',et)
 
 %question, should the number of parameters for BS be 5 for use in chi
 %squared below?
 
 
%  %comment out as appropriate
%  fprintf('\nstandard deviation:\t %f\n',StdMCc0)
%  fprintf('\nVariance:\t %f\n',VarMCc0)
%  
 figure(1)
 plot(Volarr,BSc0,'b',Volarr,MCc0,'r')
 title ("Comparison BS and MC simulation for Call Option Price varying Volatility");
 xlabel("Volatility");
 ylabel("Call Option Price");
 legend('BSc0','MSc0')
 
 figure(2)
 scatter(Volarr,StdofMean,'p')
 title ("Monte Carlo Standard Deviation of Mean (using BS)");
 xlabel("Volatility");
 ylabel("Standard Deviation");
 
 figure(3)
 scatter(Volarr,VarofMean,'o')
 title ("Monte Carlo Variance of Mean (using BS)");
 xlabel("Volatility");
 ylabel("Variance");