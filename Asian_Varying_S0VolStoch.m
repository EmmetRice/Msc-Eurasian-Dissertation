%comparing BS and MC for multiple intial stock prices
%CALL OPTION NO DIVIDEND

clear all: 
clf(figure(1));
clf(figure(2));
clf(figure(3));


disp('Starting Programme')

global m
m = 1000000;%input('Enter How many monte carlo iterations / paths - ');

vol = 0.2;%input('Enter Volatility of Underliny Asset - ');
alpha = 10; %stoch vol mean reversion speed 
eta = 0.3; %the vol of vol
volhat = vol; 


count = 0;

vol = 0.2;%input('Enter Volatility of Underliny Asset - ');
ndash = 253; %input('Enter number of TRADING days till maturity - ');%also number of steps
n=ceil(ndash);
T = n/253; %time in fraction of year
dt = T/n;
%r and mu are equal, check why

r = 0.05;%input('Enter equivaelent annual continous intenerest rate r - ');
K = 10;%input('Enter Strike Price - ');


fprintf('\nStrike Price K:\t %f\nand %d Monte Carlo Path iterations',K,m);
FinS = input('\nUpper Limit of Initial Stock Price (ranging from 0, Recommend 3xK) - ');
FinS1= FinS+1; %Adding 1 as loop iteration i starts at 1 not zero
x=FinS1;
Sarr = (0:FinS);
% disp(size(Sarr))
% Sarr0=zeros(1,FinS1);
% disp(size(Sarr0))

Zeroarr = zeros(1,FinS1);

% disp(Sarr(1))
BSc0=Zeroarr;
MCc0=Zeroarr;


%need a cell to hold aray of maturityCMC results

MCGTC0 = Zeroarr;
MCATC0 = Zeroarr;
AnaGTDisC0 = Zeroarr;
AnaGTContC0 = Zeroarr;


%Antithmetic Variance reduction method

MCc0Antith = MCc0;
MCGTC0Antith = MCGTC0;
MCATC0Antith = MCATC0;
% C0GTArrayCellAntith = C0GTArrayCell;


%VARAINCE
VarofMeanCMC_Mean = Zeroarr;
VarofMeanCMC_Mean_Antith_Var = VarofMeanCMC_Mean;
VarofMeanFixG0 = VarofMeanCMC_Mean;
VarofMeanFixA0 = VarofMeanCMC_Mean;
VarofMeanFixAntithG0 = VarofMeanCMC_Mean;
VarofMeanFixAntithA0 = VarofMeanCMC_Mean;


%Setting up Control VAriate Variable arrays

BetaoptHatArithDisGeo = Zeroarr;
BetaoptHatArithContGeo = BetaoptHatArithDisGeo;
BetaoptHatAntArithDisGeo = BetaoptHatArithDisGeo;
BetaoptHatAntArithContGeo = BetaoptHatArithDisGeo;

ControlVarBetaoptDisGeo = Zeroarr;
ConVarArithBetaoptContGeo = ControlVarBetaoptDisGeo;
AntConVarArithBetaoptDisGeo = ControlVarBetaoptDisGeo;
AntConVarArithBetaoptContGeo = ControlVarBetaoptDisGeo;

VarcvBetaoptArithDisGeo = Zeroarr;
VarcvBetaoptArithContGeo = VarcvBetaoptArithDisGeo;
VarAntcvBetaoptArithDIsGeo = VarcvBetaoptArithDisGeo;
VarAntcvBetaoptArithContGeo = VarcvBetaoptArithDisGeo;

%Covariance and correlation arrays
CovAntith= Zeroarr;
CorrAntith= Zeroarr;
       

%Confidence intervals


ConfofMeanCMC_Mean = CovAntith;
ConfofMeanCMC_Mean_Antith_Var = CovAntith;
ConfofMeanFixG0 = CovAntith;
ConfofMeanFixA0 = CovAntith;
ConfofMeanFixAntithG0 = CovAntith;
ConfofMeanFixAntithA0 = CovAntith;

ConfcvBetaoptArithDisGeo = Zeroarr;
ConfcvBetaoptArithContGeo = VarcvBetaoptArithDisGeo;
ConfAntcvBetaoptArithDIsGeo = VarcvBetaoptArithDisGeo;
ConfAntcvBetaoptArithContGeo = VarcvBetaoptArithDisGeo;



disp('Running...')

t = cputime;
 for l=1:FinS1 %this is lower case L
     
     
     
   [BSc0(l),MCc0(l),MCc0Antith(l),MCGTC0(l),MCATC0(l),MCGTC0Antith(l), MCATC0Antith(l)...
         ,AnaGTDisC0(l),AnaGTContC0(l)...
         ,ControlVarBetaoptDisGeo(l),VarcvBetaoptArithDisGeo(l),BetaoptHatArithDisGeo(l)...
         ,ConVarArithBetaoptContGeo(l),VarcvBetaoptArithContGeo(l),BetaoptHatArithContGeo(l)...
         ,AntConVarArithBetaoptDisGeo(l),VarAntcvBetaoptArithDIsGeo(l),BetaoptHatAntArithDisGeo(l)...
         ,AntConVarArithBetaoptContGeo(l),VarAntcvBetaoptArithContGeo(l),BetaoptHatAntArithContGeo(l)...
         ,VarofMeanCMC_Mean(l),VarofMeanCMC_Mean_Antith_Var(l),VarofMeanFixG0(l)...
         ,VarofMeanFixA0(l),VarofMeanFixAntithG0(l),VarofMeanFixAntithA0(l)...
         ,CovAntith(l),CorrAntith(l)]  = AsianOption_Loop_FunctionVolStoch(Sarr(l),K,r,vol,n,m,alpha,eta,volhat);
     
     
     %Calculating Confidence Intervals
     
                ConfofMeanCMC_Mean(l) = confidenceVarofMean(VarofMeanCMC_Mean(l),m);
                ConfofMeanCMC_Mean_Antith_Var(l) = confidenceVarofMean(VarofMeanCMC_Mean_Antith_Var(l),m);
                ConfofMeanFixG0(l) = confidenceVarofMean(VarofMeanFixG0(l),m);
                ConfofMeanFixA0(l) = confidenceVarofMean(VarofMeanFixA0(l),m);
                ConfofMeanFixAntithG0(l) = confidenceVarofMean(VarofMeanFixAntithG0(l),m);
                ConfofMeanFixAntithA0(l) = confidenceVarofMean(VarofMeanFixAntithA0(l),m);
                
                %Due to how the control variate method works, as well as
                %the approximation of its variance, take the 95% confidence
                %intervals very skeptically for the analytic arithemtic
                %asian option price
                ConfcvBetaoptArithDisGeo(l) = confidenceVarofMean(VarcvBetaoptArithDisGeo(l),m);
                ConfcvBetaoptArithContGeo(l) = confidenceVarofMean(VarcvBetaoptArithContGeo(l),m);
                ConfAntcvBetaoptArithDIsGeo(l) = confidenceVarofMean(VarAntcvBetaoptArithDIsGeo(l),m);
                ConfAntcvBetaoptArithContGeo(l) = confidenceVarofMean(VarAntcvBetaoptArithContGeo(l),m);

    
     count = count +1;
     fprintf('\n Path Cycles Completed %i',count); 
 end 
 
 
 
 
 et = cputime - t;
 fprintf('elapsed time (s):\t %.2f\n',et)
 
 
     
 figure(1)
 plot(Sarr,AnaGTDisC0,Sarr,MCGTC0,Sarr,MCGTC0Antith,Sarr,AnaGTContC0,Sarr,MCc0Antith,'c',Sarr,BSc0,Sarr,MCc0,Sarr,MCATC0,Sarr,MCATC0Antith,Sarr,ControlVarBetaoptDisGeo,'LineWidth',2)
 title ("Asian Option Pricing Varying Intial Stock Price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend('Analytical discrete Asian CG0','MC CG0','MC CG0 Antith','Analytical Continous Asian CG0','Antithetc Euro C0','BS Euro C0','MC Euro C0','MC Asian CA0','Antith MC Asian CA0','CVMC using DisGeo Asian CA0')
 


 figure(2)
 plot(Sarr,AnaGTDisC0,Sarr,MCGTC0,Sarr,MCGTC0Antith,Sarr,AnaGTContC0,Sarr,MCATC0,Sarr,MCATC0Antith,Sarr,ControlVarBetaoptDisGeo,'LineWidth',2)
 title ("Comparison Analytical discrete and MC simulation for Asian fixed Call Option Price varying Initial Stock price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend
 

  figure(3)
 plot(Sarr,MCc0Antith,Sarr,BSc0,Sarr,MCc0,'LineWidth',2)
 title ("Comparison Analytical discrete and MC simulation for Asian fixed Call Option Price varying Initial Stock price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend

 figure(4)
 plot(Sarr,AnaGTDisC0,Sarr,MCATC0,Sarr,ControlVarBetaoptDisGeo,Sarr,ConVarArithBetaoptContGeo,Sarr,AntConVarArithBetaoptDisGeo,Sarr,AntConVarArithBetaoptContGeo,'LineWidth',2)
 title ("Comparison Analytical discrete and MC simulation for Asian fixed Call Option Price varying Initial Stock price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend
 


 
%VARAINCE PLOTS





 figure(7)
 plot(Sarr,VarofMeanFixAntithA0,'-.or',Sarr,VarcvBetaoptArithDisGeo,Sarr,VarcvBetaoptArithContGeo,Sarr,VarAntcvBetaoptArithDIsGeo,Sarr,VarAntcvBetaoptArithContGeo,'LineWidth',2)
 title ("Monte Carlo Variance of Mean (Arithmetic Average)");
 xlabel("Initial Stock Price");
 ylabel("Variance");
 legend('Antit MC A0','BiasVarcvBetaoptArithDisGeo','BiasVarcvBetaoptArithContGeo','BiasVarcvBetaoptAntithArithDisGeo','BiasVarcvBetaoptAntithArithContGeo');
 
 
 figure(8)
 plot(Sarr,VarofMeanCMC_Mean,Sarr,VarofMeanCMC_Mean_Antith_Var,Sarr,VarofMeanFixG0,Sarr,VarofMeanFixA0,Sarr,VarofMeanFixAntithG0,Sarr,VarofMeanFixAntithA0,'LineWidth',2)
 title ("Control Variate price (Arithmetic Average)");
 xlabel("Initial Stock Price");
 ylabel("Arithmetic Option Price");
 legend('VarofMeanCMC_Mean','VarofMeanCMC_Mean_Antith_Var','VarofMeanFixG0','VarofMeanFixA0','VarofMeanFixAntithG0','VarofMeanFixAntithA0');
 
 
function [confidenceinterval] = confidenceVarofMean(var,m)
 
            temp = var * m;
            temp = sqrt(temp);
            confidenceinterval =  1.96*(temp / sqrt(m));
            %returns 95% confidence interval when input is a varaince of
            %the mean
end 
            