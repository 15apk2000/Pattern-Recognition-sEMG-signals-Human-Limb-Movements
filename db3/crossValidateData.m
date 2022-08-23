function [wModel,aMean,aStd] = crossValidateData(featureTrain,numFeat,numCV,fSet)

c = cvpartition(featureTrain(:,numFeat+1),'Kfold',numCV);
wristClassifiers = {@wristClassifier1,@wristClassifier2,@wristClassifier3,@wristClassifier4,@wristClassifier5};

accuracy = zeros(c.NumTestSets,1);

for iter = 1:c.NumTestSets
    
    % train classifier
    trainIndex = c.training(iter);
    
    
    wModelf = wristClassifiers{fSet};
    [wModel,~] = wModelf(featureTrain(trainIndex,:));
    % test
    testIndex  = c.test(iter);
    labelsHat = wModel.predictFcn(featureTrain(testIndex,1:numFeat));
    
    % store accuracy
    labels = featureTrain(testIndex,numFeat+1);
    cMat = confusionmat(labels,labelsHat);
    accuracy(iter) = trace(cMat)/sum(cMat(:));
    
    disp(['Cross Validation Fold',num2str(iter)])
end

aMean = mean(accuracy);
aStd = std(accuracy);

disp(['CV accuracy = ',num2str(aMean*100),' +- ',num2str(aStd*100)])

end


