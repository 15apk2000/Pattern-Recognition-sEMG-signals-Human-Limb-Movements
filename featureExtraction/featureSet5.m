function featureTrial = featureSet5(segment,label)
% Hjorth, ICS, WL, LD, MTW 

% activity
f1 = var(segment);

if(min(f1(:,1))== -Inf)
    disp('haha')
end

% mobility
f2 = sqrt(var(diff(segment))./f1);
f22 = sqrt(var(diff(diff(segment)))./var(diff(segment)));
% complexity

f3 = f22./f2 ;

% feature 5 - ICS

f5 = InterChannelStatistics(segment);

% feature 6 - Waveform Length

f6 = sum(abs(diff(segment)));

% feature 7 - Log Dectector

f7 = LogDetector(segment);

% feature 9 - Multiple Trapezoidal Window

f8 = MultipleTrapezoidalWindows(segment);

featureTrial = ...
    [log(f1),log(f2),log(f3),log(f5)',log(f6),f7,log(f8),label];

end

function featuresTrial = InterChannelStatistics(segment)

numChannels = size(segment,2);
channelSelect = nchoosek(1:numChannels,2);
featuresTrial = zeros(size(channelSelect,1),1);


for iterChannelSelect = 1:length(channelSelect)
    
    featuresTrial(iterChannelSelect) = ...
        max(xcorr(segment(:,channelSelect(iterChannelSelect,1)),segment(:,channelSelect(iterChannelSelect,2))));
end
end


function featuresTrial =  LogDetector(segment)

N = size(segment,1);
featuresTrial = exp(sum(log(abs(segment)))/N);
end


function featuresTrial = MultipleTrapezoidalWindows(segment)

segmentLength = size(segment,1);
numChannel = size(segment,2);
% segmentLength = segmentLength - mod(segmentLength,12);
% segment = segment(segmentLength,:);

l = floor((5/12)*segmentLength);
h = (2.5*(1/l));

step = h/floor(0.15*l);
slp1 = 0:step:h;
slp2 = h:-step:0;
middle = ones(l - length(slp1) - length(slp2),1)*h;
trapWindow = [slp1,middle',slp2];

f1 = segment(1:l,:).*(trapWindow'*ones(1,numChannel));

f2 = segment(floor(0.7*l):floor(1.7*l),:);
f2 = f2(1:length(trapWindow));
f2 = f2'.*(trapWindow'*ones(1,numChannel));

f3 = segment(floor(1.4*l):end,:);
f3 = f3(1:length(trapWindow));
f3 = f3'.*(trapWindow'*ones(1,numChannel));

f1 = sum(f1.^2);
f2 = sum(f2.^2);
f3 = sum(f3.^2);

featuresTrial = [f1,f2,f3];
end
