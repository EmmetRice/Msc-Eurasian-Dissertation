%MonteCarloMean(S0,K,r,vol,n,m);
clear all: 
clf(figure(1));
clf(figure(2));
clf(figure(3));


%Assigning Variable values
[S0,K,r,vol,n,m] = deal(25,20,0.05,0.2,253,100);

%T is time to maturity in terms of financial years
%n is the number of fincical days (253 in a year)
%m the number of path iterations
         T = n/253;
         dt = T/n; % discretising time steps
         
         %Setting up arrays to hold values
         
         %size n as number of steps in one path equal to days
         ZeroArr = zeros(1,n); 
         OnesArr = ones(1,n);
         NanArr = nan(1,n);
         
         %Array to hold CMC = call option Monte Carlo
         PriceCMC = nan(1,m);%size m as m paths
         
         %Covariance arrays
         covZ = nan(1,m); 
         covST = nan(1,m);

                for j =1:m % running multiple simulations (paths)
                    
                    %Generating array of z values
                     Z = normrnd(ZeroArr,OnesArr);
                     ZNeg = (-1).*(Z);
                     Stockprices = NanArr;
                     Stockprices(1) = S0; %intialising first asset price
                    
                     StockpricesNeg = Stockprices;
                     StockpricesAv = Stockprices;
                     timestep = ZeroArr;
                     timestep(1) = 0; %matlab arrays start at 1
                     St=S0;
                     StNeg = S0;
                
                     sig = 0.5*(vol^2); %this is a cosnatnt used in the equations
                     
                    
                    for i = 1:n %runnning loop for one stock path
                                              
                        
                        
                        %Z(i)=normrnd(0,1);
                        
                        
                        St = St*(1+r*dt+vol*sqrt(dt)*Z(i));
                        %St is the discrete form approximation of asset price

                        %Splitting equation up to increase computational
                        %efficency 
                        Stbexpo0 = vol*sqrt(dt);
                        Stbexpo1 = Stbexpo0*Z(i);
                        
                        %Antithetic components
                        Stbexpo1Neg = Stbexpo0*ZNeg(i);
                        Stbexpo2 = ((r-sig)*dt);
                                                
                        StNeg = StNeg * exp(Stbexpo1Neg+Stbexpo2); %the stock price if random number was negative
                        St = St * exp(Stbexpo1+Stbexpo2);
                        Stockprices(i+1)=St; %saving stock rpice to array for next loop
                        StockpricesNeg(i+1) = StNeg; %negative for arithmetic var reduction technique

                        StockpricesAv(i+1) = (Stockprices(i+1) + StockpricesNeg(i+1))/2;
                        timestep(i+1)=i;
                        
                        
                        if i == n
                            
                            
                            CMC = exp(-r*T)*max([St-K,0.]);%exponential factor is the discount factor
                           %European Call Option Price
                            
                           %Calculating Covariance using MATLAB Functions
                           %This process is coded independantly in the
                           %Control_Variate Function, but it is a basic
                           %function
                            covSTtemp = cov(Stockprices,StockpricesNeg);
                            covST(j) = covSTtemp(1,2);
                        end
                        %above tells the MC call option pay off at
                        %every step

%                         MOVIE comment in and out for debugging 
                        
%                         figure(1)
%                         hold on;
%                         plot (timestep, Stockprices,'color',CP(j,:));
%                         title ("Animated: Stock price per day");
%                         xlabel("Day");
%                         ylabel("Stock Price");

                    
                    end
                
                PriceCMC(j) = CMC; %creating array of the call option payoffs at maturity (ie end)     

                    figure(1)
                        hold all;
                        plot (timestep, Stockprices);
                        title ("Monte Carlo Simulated Stock Price Sample Paths");
                        xlabel("Day");
                        ylabel("Stock Price");
                        
                
                 
                end   %end of monte carlo
        CMC_Mean = mean(PriceCMC);
        MaturityCMCArray = PriceCMC; 
        
              

                     figure(2)
                        plot (timestep(1,2:51), Z(1,1:50),'-ob',timestep(1,2:51), ZNeg(1,1:50),'-or')
                        title ("Antithetic Gaussian Random Variable/n For Stock Pricing");
                        xlabel("Step");
                        ylabel("Gaussian Random Variable");
                        legend('Z','Z*')
                        
                                     figure(3)
                        
                        plot (timestep(1,1:50), Stockprices(1,1:50),'b',timestep(1,1:50), StockpricesNeg(1,1:50),'r',timestep(1,1:50), StockpricesAv(1,1:50),'-.g')
                        title ("Stockprice and Antithetic StockPrice");
                        xlabel("Day");
                        ylabel("Stock Price");
                        legend('Standard','Antithetic','Anthithetic Average')
                        
                        
                        
                covCMCtemp = cov(PriceCMC,PriceCMCNeg);
                covCMC = covCMCtemp(1,2);
                        
               %Covaraiance used to asses code     