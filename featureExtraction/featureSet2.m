function featureTrial = featureSet2(segment,label)

% Feature Set 2 : mean , var , skew , kurt
% 7*4  = 28 features

f1 = mean(segment);
f2 = var(segment);
f3 = skewness(segment);
f4 = kurtosis(segment);

featureTrial = ...
    [f1,f2,f3,f4,label];

end