function [aModel,wModel,aMean,aStd] = crossValidateData(featureTrain,numFeat,numCV,fSet)

c = cvpartition(featureTrain(:,numFeat+1),'Kfold',numCV);

armClassifiers = {@armClassifier1,@armClassifier2,@armClassifier3,@armClassifier4,@armClassifier5,@armClassifier6};
wristClassifiers = {@wristClassifier1,@wristClassifier2,@wristClassifier3,@wristClassifier4,@wristClassifier5,@wristClassifier6};

accuracy = zeros(c.NumTestSets,1);

for iter = 1:c.NumTestSets
    
    % train classifier
    trainIndex = c.training(iter);
    
    aModelf = armClassifiers{fSet};
    [aModel,~] = aModelf(featureTrain(trainIndex,:));
    
    wModelf = wristClassifiers{fSet};
    [wModel,~] = wModelf(featureTrain(trainIndex,:));
    % test
    testIndex  = c.test(iter);
    
    alabelsHat = aModel.predictFcn(featureTrain(testIndex,1:numFeat));
    wlabelsHat = wModel.predictFcn(featureTrain(testIndex,1:numFeat));
    
    % store accuracy
    labels = featureTrain(testIndex,numFeat+1);
    labelsHat = alabelsHat*10 + wlabelsHat;
    cMat = confusionmat(labels,labelsHat);
    accuracy(iter) = trace(cMat)/sum(cMat(:));
    
    disp(['Cross Validation Fold',num2str(iter)])
end

aMean = mean(accuracy);
aStd = std(accuracy);

disp(['CV accuracy = ',num2str(aMean*100),' +- ',num2str(aStd*100)])

end


