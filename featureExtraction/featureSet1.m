function featureTrial = featureSet1(segment,label)
% Feature Set 1 :RMS, WL, AR-4 coeff
f1 = sqrt(mean(segment.^2)); % rms

f2 = sum(abs(diff(segment)));

AR = 4;
f3 = aryule(segment,AR);
f3 = f3';
f3 = f3(:)';

featureTrial = ...
    [f1,f2,f3,label];
end