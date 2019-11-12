function [CMC_Mean,CMCArr,CMC_Mean_Antith_Var,CMCAntithArr...
          ,GT,AT,GTAntith,ATAntith,ST_Mean,ST_MeanArith,CG0Arr,CG0Mean,CA0Arr,CA0Mean,CG0AntithArr,CG0AntithMean,CA0AntithArr,CA0AntithMean...
          ,CovAntithEuro,CorrAntithEuro...
          ,CovAntithGT,CovAntithAT,GTNeg,ATNeg,CMCNegArr...
          ,CorrCVBase,CorrCVAnt]  = MonteGTAT(S0,K,r,vol,n,m)

     
      %NOTE dont generally require GT and AT and other matuyrity arrays,
      %But useful for debugging to have printed, Code can be altered to
      %remove them 
      
      %The Stockprice average calculation can also be removed to increase
      %code efficency as not required for this investigvation analysis
     

         T = n/253; %time to maturity in fraction of financial year (253 days)
         dt = T/n; %discretsing time steps
         
         %setting up arrays
         ZeroArr = zeros(1,n);
         OnesArr = ones(1,n);
         NanArr = nan(1,n);
         CMCArr = zeros(1,m);%size m as m paths
         CMCNegArr = CMCArr;
         CMCAntithArr = CMCArr;
         
         
         %ASian Option Set Up
         
         AT=nan(1,m); %arthimetic mean value at T
         GT=AT; %geometric Mean value at T
         ATNeg = AT; %array for antithetic negative prices
         GTNeg = AT;
         CG0Arr = AT; %intial price arrays
         CA0Arr= AT;
         CG0NegArr= AT;
         CA0NegArr= AT;
         
        
         %Arithmetic Variance reduction Asian option values 
       
         
         GTAntith = AT;  %arrays for the arithmetic variance reduction technique
         ATAntith = AT;
         CG0AntithArr = AT;  %arrays for the arithmetic variance reduction technique
         CA0AntithArr = AT;
         
         
         STArr = nan(1,m); %maturity stock price array
         STArithVarArr = STArr;
         
         sig = 0.5*(vol^2); %consatnt value in calculation,
                            %oputside loop for efficency

                for j =1:m % running multiple simulations (paths)
                    
                     Z = normrnd(ZeroArr,OnesArr);
                     %faster to calculate all random variables at the same
                     %time
                     ZNeg = (-1).*(Z); %antithetic GRVs
                     Stockprices = NanArr;
                     Stockprices(1) = S0; %intial stock price in array
                     StockpricesNeg = Stockprices;
                     StockpricesAv = Stockprices;
                     timestep = ZeroArr;
                     timestep(1) = 0;
                     St=S0; %intial stock price
                     StNeg = S0;
                     
 
                     
                    
                    for i = 1:n %Stock path until maturity day
                                                                     
                        
                        %St is the discrete form approximation

                        %Splitting equation up to increase computational
                        %efficency  and clarity
                        Sta = St*exp((r-sig)*dt);
                        StaNeg = StNeg*exp((r-sig)*dt);
                        Stbexpo = vol*sqrt(dt);
                        
                        St = Sta * exp(Stbexpo*Z(i));
                        StNeg = StaNeg * exp(Stbexpo*ZNeg(i)); 
                        %the stock price if random number was negative
                        
                        Stockprices(i+1)=St;
                        StockpricesNeg(i+1) = StNeg; 
                        %negative for arithmetic var reduction technique
                        
                        StockpricesAv(i+1) = (Stockprices(i+1) + StockpricesNeg(i+1))/2;
                        %This could be removed to speeed up calculation
                        timestep(i+1)=i;
                        
                        
                        if i == n %when at maturity date
                            
                            
                            CMC = exp(-r*T)*max([St-K,0.]);%exponential factor is the discount factor
                            % Calculating european Call option price 
                            %Antithetic price
                            CMCNeg = exp(-r*T)*max([StockpricesNeg(end)-K,0.]);
                            %exponential factor is the discount factor
                            
                            CMCAntith = (CMC+CMCNeg)/2;
                            
                            %FIXED CALL ASIAN OPTION Section
                            
                            %TO DEAL WITH 0 Stockprice Values in Log, add 1
                            %to all values, then subtract 1 from the final
                            %geo average
                            
                            StockpricesPlus = Stockprices + 1;
                            StockpricesNegPlus = StockpricesNeg + 1;
                            
                            GT(j) = exp(sum(log(StockpricesPlus))/length(StockpricesPlus));
                            %geometric average    Geo average final stock price
                            GT(j) = GT(j) - 1;
                            
                            GTNeg(j) = exp(sum(log(StockpricesNegPlus))/length(StockpricesNegPlus)); %geometric average    Geo average final stock price
                            GTNeg(j) = GTNeg(j) - 1;
                            
                            AT(j) = sum(Stockprices)/length(Stockprices); %arthimetic average
                            ATNeg(j) = sum(StockpricesNeg)/length(StockpricesNeg); %arthimetic average
                            
                            %Arithmetic var reduction asian
                            
                            GTAntith(j) = (GT(j)+ GTNeg(j))/2; %geometric average
                            ATAntith(j) = (AT(j)+ ATNeg(j))/2 ; %arthimetic average for arithmetic var reduction
                            

                            STArr(j) = Stockprices(end); %storing maturity stock price
                            
                            STArithVarArr(j) = StockpricesAv(end);
                            
                            %ASIAN OPTION PRICES geo and arith
                            CG0Arr(j) = exp(-r*T)*max([GT(j)-K,0.]);
                            CA0Arr(j) = exp(-r*T)*max([AT(j)-K,0.]);
                            
                            CG0NegArr(j) = exp(-r*T)*max([GTNeg(j)-K,0.]);
                            CA0NegArr(j) = exp(-r*T)*max([ATNeg(j)-K,0.]);
                        
                            %Antithetic method pricing
                              CG0AntithArr(j) = (CG0Arr(j)+CG0NegArr(j))/2;
                              CA0AntithArr(j) = (CA0Arr(j)+CA0NegArr(j))/2;

                        end
                        %above tells the MC call option pay off at
                        %every step

                    %     MOVIE comment in and out for debugging 
                        
%                         figure(1)
%                         plot (timestep, Stockprices);
%                         title ("Animated: Stock price per day");
%                         xlabel("Day");
%                         ylabel("Stock Price");
                    
                    end
                
                CMCArr(j) = CMC; %creating array of the discounted call option payoffs at maturity (ie end) so can calculate sample variance
                CMCNegArr(j) = CMCNeg;
                CMCAntithArr(j) = CMCAntith;
                
                

                
                 
                end   %end of monte carlo
        CMC_Mean = mean(CMCArr);  %arithemtic mean value of all simultion
                                  %prices
         

        CG0Mean = mean(CG0Arr);
        CA0Mean = mean(CA0Arr);
         
 
        CG0AntithMean = mean(CG0AntithArr);
        CA0AntithMean = mean(CA0AntithArr);
        
        CMC_Mean_Antith_Var = mean(CMCAntithArr);
        

ST_Mean = mean(STArr);
ST_MeanArith = mean(STArithVarArr);

  
%Correlation and Covariance calculations


CovAntithtemp = cov(CMCArr,CMCNegArr);
CovAntithEuro = CovAntithtemp(1,2); %selecting from covaraince array element (a,b)
%
CorrAntithtemp = corrcoef(CMCArr,CMCNegArr);
CorrAntithEuro = CorrAntithtemp(1,2); %selecting

CovAntithtemp = cov(CG0Arr,CG0NegArr);
CovAntithGT = CovAntithtemp(1,2); %selecting from covaraince array element (a,b)
%
% CorrAntithtemp = corrcoef(CG0Arr,CG0NegArr);
% CorrAntithEuro = CorrAntithtemp(1,2); %selecting

CovAntithtemp = cov(CA0Arr,CA0NegArr);
CovAntithAT = CovAntithtemp(1,2); %selecting from covaraince array element (a,b)
             

%Correlartion for investigating variance reduction

CorrCVBasetemp = corrcoef(CG0Arr,CA0Arr);
CorrCVBase = CorrCVBasetemp(1,2); %selecting

CorrCVAnttemp = corrcoef(CG0AntithArr,CA0AntithArr);
CorrCVAnt = CorrCVAnttemp(1,2); %selecting

end


