function featureTrial = featureSet3(segment,label)

% Feature Set 3 : m0, m2, m4, S, IF, WL, SC

N = size(segment,1);
numChannels = size(segment,2); 
d1     = diff([zeros(1,numChannels);diff(segment)],1,1);
d2     = diff([zeros(1,numChannels);diff(d1)],1,1);

%feature 1 - Zero Order Moment
mZero = (sum(abs(segment).^2,1));
firstFeature = log(mZero/N);

%feature 2 - Second Order Moment
mTwo = sum(d1.^2,1);
secFeature = log(abs((mTwo.*(N^2))./mZero));

%feature 3 - Fourth Order Moment
mFour = sum(d2.^2,1);
thirdFeature = log(abs((mFour.*(N^4))./mZero));

%feature 4 - Sparseness
fourFeature = log(abs(mZero./((sqrt(mZero - mTwo).*sqrt(mZero - mFour)))));

%feature 5 - Irregularity Factor
WL = sum(abs(d1))./sum(abs(d2));
fifthFeature = log(abs((mTwo./sqrt(mZero.*mFour))./WL));

%feature 6 - Logarithm of Waveform Length
sixthFeature = log(abs(WL));

featureTrial = [firstFeature secFeature thirdFeature fourFeature fifthFeature sixthFeature];

%feature 7 - Spectral Corelation
select = nchoosek(1:numChannels,2);
sc = zeros(size(select,1),1);
for i=1:size(select,1)
    sc(i) = ...
        sum(segment(:,select(i,1)).*segment(:,select(i,2)))...
        ./(sqrt(sum(segment(:,select(i,1)).^2,1)).*...
            sqrt(sum(segment(:,select(i,2)).^2,1)));
end

featureTrial = [featureTrial, sc', label];
end