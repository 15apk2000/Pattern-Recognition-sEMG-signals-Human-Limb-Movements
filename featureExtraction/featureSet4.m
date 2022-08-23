function featureTrial = featureSet4(segment,label)

% Feature Set 5 : wavlet
% numChannels*8 features

N = 3;
numChannels = size(segment,2);
f = zeros(numChannels*8,1);

prev = 1;
next = 8;
for i = 1:numChannels
    
    [ch,lch] = wavedec(segment(:,i),N,'db2');
    [chd1,chd2,chd3] = detcoef(ch,lch,[1 2 3]); %det coeff
    cha = ch(1:lch(1)); % app coeff
    f(prev:next) = ...
        [max(chd1),max(chd2),max(chd3),...
            std(chd1),std(chd2),std(chd3),...
                max(cha),std(cha)];
    prev = next+1;
    next=next+8;
end

featureTrial = [f',label];

end
