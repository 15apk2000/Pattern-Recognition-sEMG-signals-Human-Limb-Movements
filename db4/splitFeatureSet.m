function [featureTrain,featureTest] = splitFeatureSet(featureSubj,numFeat,trainRep,testRep)


featureTrain = [];
featureTest = [];

bTrain = featureSubj(:,numFeat+2)==trainRep;
bTest = featureSubj(:,numFeat+2)==testRep;
    

for i = 1:length(trainRep)
    featureTrain = [featureTrain;featureSubj(bTrain(:,i),:)];
end

for i = 1:length(testRep)
    featureTest = [featureTest;featureSubj(bTest(:,i),:)];
end


end

