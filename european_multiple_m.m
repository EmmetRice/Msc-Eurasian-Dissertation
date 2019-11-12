clear all
clf(figure(1));
clf(figure(2));
clf(figure(3));

%Glboal m to pass between functions
 global m
 m=100; % the intial number of iterations
 L = 100; %L is how the variable m is saved for each iteration
 

maxorderm = 100; % maximum amount of times m is increased in magnitude
mstep = nan(1,maxorderm); %array to save m values

%Assigning Values
[S0,K,r,vol,n] = deal(25,20,0.05,0.2,253);


tickrate=0.01; %Market tickrate forf Unceratianity, typically $0.01

%setting up arrays to hold values
MCc0=nan(1,maxorderm); %Monte Carlo Call option price
StdofMean=nan(1,maxorderm);   %these all use true mean from BS, but could use approx mean MCc0
VarofMean=nan(1,maxorderm);

MCc0Antith_Var = MCc0;
StdofMeanAntith_Var = StdofMean;
VarofMeanAntith_Var = VarofMean;


%need a cell to hold aray of maturityCMC results
PriceCMCCell = cell(maxorderm,1);
PriceCMCCellAntith_Var = PriceCMCCell;

%corr and cov arrays
CovAntith = nan(1,maxorderm);
CorrAntith = nan(1,maxorderm);
       
%Theoretical Black Scholes price calculation
            c0 = BlackScholes(S0,K,r,vol,n);


BSMCDiff1 = 1; % intial to get while loop started
%This is the difference between the analytical and numerical call price

l = 0; % the number of times the iterations have increaed, should start at 0

            
            while BSMCDiff1 > tickrate  %iterating until difference within uncertaintity
                   l=l+1;
                   mstep(l) = L;
                    t = cputime;
                    
                    fprintf('# iteratins m:\t %d\n',m)
                    disp('Running...');
                    
                    %THIS m MUST BECOME A GLOBAL VARIABLE
                    
                    
%                     MaturityCMC = MonteCarlo(S0,K,r,vol,n,m);
%                     CMC_Mean = mean(MaturityCMC);
      
     
     %Price Calculated From MonteCarlo Function
     [MCc0(l), PriceCMCCell{l},MCc0Antith_Var(l) ,PriceCMCCellAntith_Var{l}...
          ,~,~,~,~,~,~,~,~,~,~,~,~,~,~...
          ,CovAntith(l),CorrAntith(l)]  = MonteGTAT(S0,K,r,vol,n,m);
     

      %Calculating varaince and sdtandard deviations
     [StdofMean(l), VarofMean(l)] = SampleStdVar(PriceCMCCell{l},c0);
 
     [StdofMeanAntith_Var(l), VarofMeanAntith_Var(l)] = SampleStdVar(PriceCMCCellAntith_Var{l},c0);
            

                    
            BSMCDiff1 = abs(c0-MCc0(l)); %difference ebtween analytical and numerical

            BSMCDiff_Arith_Var = abs(c0-MCc0Antith_Var(l));
            
            BSMCdiffArray = [BSMCDiff1,BSMCDiff_Arith_Var]; %array to hold all difference values
            
                    
                    et = cputime - t;
                    fprintf('elapsed time (s):\t %.2f\n',et)
                    %how long code takles to run for m iterations.
                    %The antithetic and base MC prices can be split
                    %Between functions to compare computational timming 
                    %to reach tickrate difference by storring and summing et
                    
                    
%                         figure(1)
%                         plot (mstep,StdofMean(l) , 'DisplayName',['m=' num2str(legendm)]);
%                         title ("Monte Carlo Simulated Stock Price for m Paths");
%                         xlabel("Day");
%                         ylabel("Stock Price");
%                         legend('-DynamicLegend')
%                         hold all;\

              m=m*2; %number of iterations doubled every loop
              L = L*2;
              
            end
            
      
            
            
                        figure(1)
                        plot (mstep,StdofMean,mstep,StdofMeanAntith_Var);
                        title ("Monte Carlo European Call Option Error");
                        xlabel("Number of Path Iterations (m)");
                        ylabel("Standard Deviation");
                        legend('MC2','MCAnithetic')
                        
            mstep=(mstep(~isnan(mstep))); %eliminating the NaN values not needed
            MCc0=(MCc0(~isnan(MCc0)));
            MCc0Antith_Var=(MCc0Antith_Var(~isnan(MCc0Antith_Var)));
            %Generating black scholes array
            c0Arr = ones(1,length(mstep));
            c0Arr = c0 * c0Arr;
                       
                        figure(2)
                        plot (mstep,c0Arr,mstep,MCc0,mstep,MCc0Antith_Var);
                        title ("Monte Carlo European Call Option Price");
                        xlabel("Number of Path Iterations (m)");
                        ylabel("European Call Option Price");
                        legend('C0 BS','C0 MC','C0 Anithetic MC')
                       
            
