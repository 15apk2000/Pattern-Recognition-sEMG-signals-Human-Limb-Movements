function [featureTrain,featureTest] = ...
    splitFeatureSet(featureMatrix,trainPercent,numFeat)
    
    labels = featureMatrix(:,numFeat+1);

    % pos 1
    class1 = featureMatrix(labels==1,:);
    class2 = featureMatrix(labels==2,:);
    class3 = featureMatrix(labels==3,:);
    class4 = featureMatrix(labels==4,:);
    class5 = featureMatrix(labels==5,:);
    class6 = featureMatrix(labels==6,:);
    class7 = featureMatrix(labels==7,:);
    class8 = featureMatrix(labels==8,:);
    class9  = featureMatrix(labels==9,:);
    class10 = featureMatrix(labels==10,:);
    
    

    trainLength = floor(trainPercent * length(class1));
    shuffle = randperm(length(class1));

    class1 =class1(shuffle,:);
    class2 =class2(shuffle,:);
    class3 =class3(shuffle,:);
    class4 =class4(shuffle,:);
    class5 =class5(shuffle,:);
    class6 =class6(shuffle,:);
    class7 =class7(shuffle,:);
    class8 =class8(shuffle,:);
    class9 =class9(shuffle,:);
    class10 =class10(shuffle,:);
   
    

    featureTrain = [class1(1:trainLength,:);
    class2(1:trainLength,:);
    class3(1:trainLength,:);
    class4(1:trainLength,:);
    class5(1:trainLength,:);
    class6(1:trainLength,:);
    class7(1:trainLength,:);
    class8(1:trainLength,:);
    class9(1:trainLength,:);
    class10(1:trainLength,:)];
    

    featureTest =[class1(trainLength+1:end,:);
    class2(trainLength+1:end,:);
    class3(trainLength+1:end,:);
    class4(trainLength+1:end,:);
    class5(trainLength+1:end,:);
    class6(trainLength+1:end,:);
    class7(trainLength+1:end,:);
    class8(trainLength+1:end,:);
    class9(trainLength+1:end,:);
    class10(trainLength+1:end,:)
    ];


end

