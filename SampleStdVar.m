function [StdofMean,VarofMean,SampleStd, SampleVar] = SampleStdVar(x,Mean)

    %where x is an array
    %Sample standard Deviation / Variance with bessel correction
    %(1/N-1)
    %correction (N-1 is degrees of freedom)
    N = length(x);
    %note x must be an array of results (ie the sample)
    SampleVar = sum((x - Mean).^2)/(N-1); %here xbar (Mean) chosen as Expected from BS, could also use CMC_Mean (both should be similar, ideally within tickrate)
    %this is an unbiased sample variance
    SampleStd = sqrt(SampleVar); %this is biased as sqrt nonlinear

    %Standard error of the mean
    StdofMean = SampleStd / sqrt(N); %this gives proportionality of 1/sqrtN
    VarofMean = (SampleStd^2) / N;
end