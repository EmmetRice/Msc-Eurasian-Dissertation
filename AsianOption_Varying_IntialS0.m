%comparing BS and MC for multiple intial stock prices
%CALL OPTION NO DIVIDEND


clear all: 
clf(figure(1));
clf(figure(2));
clf(figure(3));


disp('Starting Programme')

global m
m = 1000;%input('Enter How many monte carlo iterations / paths - ');

count = 0;

vol = 0.2;%input('Enter Volatility of Underliny Asset - ');
ndash = 253; %input('Enter number of TRADING days till maturity - ');%also number of steps
n=ceil(ndash);
T = n/253; %time in fraction of year
dt = T/n;

r = 0.05;%input('Enter equivaelent annual continous intenerest rate r - ');
K = 10;%input('Enter Strike Price - ');


fprintf('\nStrike Price K:\t %f\nand %d Monte Carlo Path iterations',K,m);
FinS = input('\nUpper Limit of Initial Stock Price (ranging from 0, Recommend 3xK) - ');
FinS1= FinS+1; %Adding 1 as loop iteration i starts at 1 not zero
x=FinS1;
Sarr = (0:FinS); %generating equally unit spaced intial stock values

Zeroarr = zeros(1,FinS1);

% disp(Sarr(1))
BSc0=Zeroarr;
MCc0=Zeroarr;



%Array to hold variables

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
 for l=1:FinS1
     

   [BSc0(l),MCc0(l),MCc0Antith(l),MCGTC0(l),MCATC0(l),MCGTC0Antith(l), MCATC0Antith(l)...
         ,AnaGTDisC0(l),AnaGTContC0(l)...
         ,ControlVarBetaoptDisGeo(l),VarcvBetaoptArithDisGeo(l),BetaoptHatArithDisGeo(l)...
         ,ConVarArithBetaoptContGeo(l),VarcvBetaoptArithContGeo(l),BetaoptHatArithContGeo(l)...
         ,AntConVarArithBetaoptDisGeo(l),VarAntcvBetaoptArithDIsGeo(l),BetaoptHatAntArithDisGeo(l)...
         ,AntConVarArithBetaoptContGeo(l),VarAntcvBetaoptArithContGeo(l),BetaoptHatAntArithContGeo(l)...
         ,VarofMeanCMC_Mean(l),VarofMeanCMC_Mean_Antith_Var(l),VarofMeanFixG0(l)...
         ,VarofMeanFixA0(l),VarofMeanFixAntithG0(l),VarofMeanFixAntithA0(l)...
         ,CovAntith(l),CorrAntith(l)]  = AsianOption_Loop_Function(Sarr(l),K,r,vol,n,m);
     
     
     %CAlculating Confidence Intervals
     
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
 

     %YcvBetapt(l) this is the arithmetic control variate using discrete
     %geo

     
 figure(1)
 plot(Sarr,AnaGTDisC0,Sarr,AnaGTContC0,Sarr,MCGTC0,Sarr,MCGTC0Antith,Sarr,MCATC0,Sarr,MCATC0Antith,Sarr,ControlVarBetaoptDisGeo,'LineWidth',2)
 title ("Asian Option Pricing Varying Intial Stock Price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Call Option Price");
 legend('Analytical Discrete CG0','Analytical Continous Asian CG0','MC CG0','MC CG0 Antith','MC Asian CA0','Antith MC Asian CA0','CVMC using Discrete Analytical CA0')
 
 
  figure(2)
 plot(Sarr,AnaGTDisC0,Sarr,AnaGTContC0,Sarr,MCGTC0,Sarr,MCGTC0Antith,Sarr,MCATC0,Sarr,MCATC0Antith,Sarr,ControlVarBetaoptDisGeo,'LineWidth',2)
 title ("Asian Option Pricing Varying Intial Stock Price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Call Option Price");
 legend('Analytical Discrete CG0','Analytical Continous Asian CG0','MC CG0','MC CG0 Antith','MC Asian CA0','Antith MC Asian CA0','CVMC using Discrete Analytical CA0')
 xlim([17.75 17.83])
 ylim([7.8 7.84])


 figure(3)
 plot(Sarr,AnaGTDisC0,Sarr,MCGTC0,Sarr,MCGTC0Antith,Sarr,AnaGTContC0,Sarr,MCATC0,Sarr,MCATC0Antith,Sarr,ControlVarBetaoptDisGeo,'LineWidth',2)
 title ("Comparison Analytical discrete and MC simulation for Asian fixed Call Option Price varying Initial Stock price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend
 

  figure(4)
 plot(Sarr,MCc0Antith,Sarr,BSc0,Sarr,MCc0,'LineWidth',2)
 title ("Comparison Analytical discrete and MC simulation for Asian fixed Call Option Price varying Initial Stock price");
 xlabel("Initial Stock Price");
 ylabel("Asian Fixed Geo Call Option Price");
 legend

 figure(5)
 plot(Sarr,MCATC0,Sarr,MCATC0,Sarr,ControlVarBetaoptDisGeo,Sarr,ConVarArithBetaoptContGeo,Sarr,AntConVarArithBetaoptDisGeo,Sarr,AntConVarArithBetaoptContGeo,'LineWidth',2)
 title ("Fixed Call Arithmetic Asian Option pricing");
 xlabel("Initial Stock Price");
 ylabel("Option Price");
 legend('Base MC Asian CA0','Antith MC Asian CA0','CVMC using Discrete CA0','CVMC using Continous CA0','Antithetic CVMC using Discrete CA0','Antithetic CVMC using Discrete CA0')
 
  figure(6)
 plot(Sarr,MCATC0,Sarr,MCATC0,Sarr,ControlVarBetaoptDisGeo,Sarr,ConVarArithBetaoptContGeo,Sarr,AntConVarArithBetaoptDisGeo,Sarr,AntConVarArithBetaoptContGeo,'LineWidth',2)
 title ("Fixed Call Arithmetic Asian Option pricing");
 xlabel("Initial Stock Price");
 ylabel("Option Price");
 legend('Base MC Asian CA0','Antith MC Asian CA0','CVMC using Discrete CA0','CVMC using Continous CA0','Antithetic CVMC using Discrete CA0','Antithetic CVMC using Discrete CA0')
  xlim([15.762 15.772])
 ylim([5.863 5.869])

 
%VARAINCE PLOTS





 figure(7)
 plot(Sarr,VarofMeanFixAntithA0,'-.or',Sarr,VarcvBetaoptArithDisGeo,Sarr,VarAntcvBetaoptArithDIsGeo,'LineWidth',2)
 title ("Variance for Arithemetic Asian Option Pricing");
 xlabel("Initial Stock Price");
 ylabel("Variance");
 legend('Antith MC Asian CA0','CVMC using Discrete Geo Sol','Antithetic CVMC using Continous Geo Sol');
 
 
 figure(8)
 plot(Sarr,VarofMeanCMC_Mean,Sarr,VarofMeanCMC_Mean_Antith_Var,Sarr,VarofMeanFixG0,Sarr,VarofMeanFixA0,Sarr,VarofMeanFixAntithG0,Sarr,VarofMeanFixAntithA0,'LineWidth',2)
 title ("Variance of Mean for Monte-Carlo Priced Options");
 xlabel("Initial Stock Price");
 ylabel("Variance");
 legend('Base MC Euro CE0','Antithetic MC Euro CE0','Base MC Asian CG0','Base MC Asian CA0','Antithetic MC Asian CG0','Antithetic MC Asian CA0');
 
 
function [confidenceinterval] = confidenceVarofMean(var,m)
 
            temp = var * m;
            temp = sqrt(temp);
            confidenceinterval =  1.96*(temp / sqrt(m));
            %returns 95% confidence interval when input is a varaince of
            %the mean
end 
            
