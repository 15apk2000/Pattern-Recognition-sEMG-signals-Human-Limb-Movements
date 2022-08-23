function featureTrial = featureSet6(segment,label)
% Feature Set 6 - MAV, VAR, WL, Willison amplitude

f1 = mean(abs(segment));
f2 = var(segment);
f31 = abs(diff(segment));
f3 = sum(f31);
f31(f31>mean(f31)) = 1;
f31(f31<mean(f1)) = 0;
f4 = sum(f31);

featureTrial = [f1,f2,f3,f4,label];


    



end