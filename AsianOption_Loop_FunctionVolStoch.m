
function [c0,CMC_Mean,CMC_Mean_Antith_Var,FixG0,FixA0...
    ,FixAntithG0,FixAntithA0,C0GTAnaDis,C0GTAnaCont...
    ,ConVarArithBetaoptDisGeo,BiasVarcvBetaoptArithDIsGeo,BetaoptHatArithDisGeo...
    ,ConVarArithBetaoptContGeo,BiasVarcvBetaoptArithContGeo,BetaoptHatArithContGeo...
    ,AntConVarArithBetaoptDisGeo,BiasVarAntcvBetaoptArithDIsGeo,BetaoptHatAntArithDisGeo...
    ,AntConVarArithBetaoptContGeo,BiasVarAntcvBetaoptArithContGeo,BetaoptHatAntArithContGeo...
    ,VarofMeanCMC_Mean,VarofMeanCMC_Mean_Antith_Var,VarofMeanFixG0...
    ,VarofMeanFixA0,VarofMeanFixAntithG0,VarofMeanFixAntithA0...
    ,CovAntith,CorrAntith,CovAntithGT,CovAntithAT]  = AsianOption_Loop_FunctionVolStoch(S0,K,r,vol,n,m,alpha,eta,volhat)



%  global m
 
          
            c0 = BlackScholes(S0,K,r,vol,n);

% %RUNNING MONTE CARLO 


               [CMC_Mean,CMCArray,CMC_Mean_Antith_Var,CMCArray_Antith_Var...
          ,~,~,~,~,~,~...
          ,CG0Arr,FixG0,CA0Arr,FixA0,CG0AntithArr,FixAntithG0,CA0AntithArr,FixAntithA0...
          ,CovAntith,CorrAntith,CovAntithGT,CovAntithAT]  = MonteGTATVolStoch(S0,K,r,vol,n,m,alpha,eta,volhat);
   

      
%Geometric Asian ANALyTICAL SOLUTION               
               [C0GTAnaCont,C0GTAnaDis]   = ContinousFixedGeoCall(S0,K,r,vol,n);
                

                 
                 %CONTROL VARIATE 
                 [ConVarArithBetaoptDisGeo,BiasVarcvBetaoptArithDIsGeo,BetaoptHatArithDisGeo] = Control_Variate_fn(CG0Arr,CA0Arr,C0GTAnaDis);
                 [ConVarArithBetaoptContGeo,BiasVarcvBetaoptArithContGeo,BetaoptHatArithContGeo] = Control_Variate_fn(CG0Arr,CA0Arr,C0GTAnaCont);
                 [AntConVarArithBetaoptDisGeo,BiasVarAntcvBetaoptArithDIsGeo,BetaoptHatAntArithDisGeo] = Control_Variate_fn(CG0AntithArr,CA0AntithArr,C0GTAnaDis);
                 [AntConVarArithBetaoptContGeo,BiasVarAntcvBetaoptArithContGeo,BetaoptHatAntArithContGeo] = Control_Variate_fn(CG0AntithArr,CA0AntithArr,C0GTAnaCont);


%                     VARIANCE CALCULATIONS


                [~,VarofMeanCMC_Mean] = SampleStdVar(CMCArray,CMC_Mean);
                [~,VarofMeanCMC_Mean_Antith_Var] = SampleStdVar(CMCArray_Antith_Var,CMC_Mean_Antith_Var);
                [~,VarofMeanFixG0] = SampleStdVar(CG0Arr,FixG0);
                [~,VarofMeanFixA0] = SampleStdVar(CA0Arr,FixA0);
                [~,VarofMeanFixAntithG0] = SampleStdVar(CG0AntithArr,FixAntithG0);
                [~,VarofMeanFixAntithA0] = SampleStdVar(CA0AntithArr,FixAntithA0);

 

return
      