function [featureTrain,featureTest] = ...
    splitFeatureSet(featureMatrix,trainPercent,numFeat)
    
    labels = featureMatrix(:,numFeat+1);

    % pos 1
    class1 = featureMatrix(labels==11,:);
    class2 = featureMatrix(labels==12,:);
    class3 = featureMatrix(labels==13,:);
    class4 = featureMatrix(labels==14,:);
    class5 = featureMatrix(labels==15,:);
    class6 = featureMatrix(labels==16,:);
    class7 = featureMatrix(labels==17,:);
    class8 = featureMatrix(labels==18,:);

    % pos 2
    class9  = featureMatrix(labels==21,:);
    class10 = featureMatrix(labels==22,:);
    class11 = featureMatrix(labels==23,:);
    class12 = featureMatrix(labels==24,:);
    class13 = featureMatrix(labels==25,:);
    class14 = featureMatrix(labels==26,:);
    class15 = featureMatrix(labels==27,:);
    class16 = featureMatrix(labels==28,:);

    % pos 3
    class17 = featureMatrix(labels==31,:);
    class18 = featureMatrix(labels==32,:);
    class19 = featureMatrix(labels==33,:);
    class20 = featureMatrix(labels==34,:);
    class21 = featureMatrix(labels==35,:);
    class22 = featureMatrix(labels==36,:);
    class23 = featureMatrix(labels==37,:);
    class24 = featureMatrix(labels==38,:);

    % pos 4
    class25 = featureMatrix(labels==41,:);
    class26 = featureMatrix(labels==42,:);
    class27 = featureMatrix(labels==43,:);
    class28 = featureMatrix(labels==44,:);
    class29 = featureMatrix(labels==45,:);
    class30 = featureMatrix(labels==46,:);
    class31 = featureMatrix(labels==47,:);
    class32 = featureMatrix(labels==48,:);

    % pos 5
    class33 = featureMatrix(labels==51,:);
    class34 = featureMatrix(labels==52,:);
    class35 = featureMatrix(labels==53,:);
    class36 = featureMatrix(labels==54,:);
    class37 = featureMatrix(labels==55,:);
    class38 = featureMatrix(labels==56,:);
    class39 = featureMatrix(labels==57,:);
    class40 = featureMatrix(labels==58,:);

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
    class11 =class11(shuffle,:);
    class12 =class12(shuffle,:);
    class13 =class13(shuffle,:);
    class14 =class14(shuffle,:);
    class15 =class15(shuffle,:);
    class16 =class16(shuffle,:);
    class17 =class17(shuffle,:);
    class18 =class18(shuffle,:);
    class19 =class19(shuffle,:);
    class20 =class20(shuffle,:);
    class21 =class21(shuffle,:);
    class22 =class22(shuffle,:);
    class23 =class23(shuffle,:);
    class24 =class24(shuffle,:);
    class25 =class25(shuffle,:);
    class26 =class26(shuffle,:);
    class27 =class27(shuffle,:);
    class28 =class28(shuffle,:);
    class29 =class29(shuffle,:);
    class30 =class30(shuffle,:);
    class31 =class31(shuffle,:);
    class32 =class32(shuffle,:);
    class33 =class33(shuffle,:);
    class34 =class34(shuffle,:);
    class35 =class35(shuffle,:);
    class36 =class36(shuffle,:);
    class37 =class37(shuffle,:);
    class38 =class38(shuffle,:);
    class39 =class39(shuffle,:);
    class40 =class40(shuffle,:);

    featureTrain = [class1(1:trainLength,:);
    class2(1:trainLength,:);
    class3(1:trainLength,:);
    class4(1:trainLength,:);
    class5(1:trainLength,:);
    class6(1:trainLength,:);
    class7(1:trainLength,:);
    class8(1:trainLength,:);
    class9(1:trainLength,:);
    class10(1:trainLength,:);
    class11(1:trainLength,:);
    class12(1:trainLength,:);
    class13(1:trainLength,:);
    class14(1:trainLength,:);
    class15(1:trainLength,:);
    class16(1:trainLength,:);
    class17(1:trainLength,:);
    class18(1:trainLength,:);
    class19(1:trainLength,:);
    class20(1:trainLength,:);
    class21(1:trainLength,:);
    class22(1:trainLength,:);
    class23(1:trainLength,:);
    class24(1:trainLength,:);
    class25(1:trainLength,:);
    class26(1:trainLength,:);
    class27(1:trainLength,:);
    class28(1:trainLength,:);
    class29(1:trainLength,:);
    class30(1:trainLength,:);
    class31(1:trainLength,:);
    class32(1:trainLength,:);
    class33(1:trainLength,:);
    class34(1:trainLength,:);
    class35(1:trainLength,:);
    class36(1:trainLength,:);
    class37(1:trainLength,:);
    class38(1:trainLength,:);
    class39(1:trainLength,:);
    class40(1:trainLength,:)];

    featureTest =[class1(trainLength+1:end,:);
    class2(trainLength+1:end,:);
    class3(trainLength+1:end,:);
    class4(trainLength+1:end,:);
    class5(trainLength+1:end,:);
    class6(trainLength+1:end,:);
    class7(trainLength+1:end,:);
    class8(trainLength+1:end,:);
    class9(trainLength+1:end,:);
    class10(trainLength+1:end,:);
    class11(trainLength+1:end,:);
    class12(trainLength+1:end,:);
    class13(trainLength+1:end,:);
    class14(trainLength+1:end,:);
    class15(trainLength+1:end,:);
    class16(trainLength+1:end,:);
    class17(trainLength+1:end,:);
    class18(trainLength+1:end,:);
    class19(trainLength+1:end,:);
    class20(trainLength+1:end,:);
    class21(trainLength+1:end,:);
    class22(trainLength+1:end,:);
    class23(trainLength+1:end,:);
    class24(trainLength+1:end,:);
    class25(trainLength+1:end,:);
    class26(trainLength+1:end,:);
    class27(trainLength+1:end,:);
    class28(trainLength+1:end,:);
    class29(trainLength+1:end,:);
    class30(trainLength+1:end,:);
    class31(trainLength+1:end,:);
    class32(trainLength+1:end,:);
    class33(trainLength+1:end,:);
    class34(trainLength+1:end,:);
    class35(trainLength+1:end,:);
    class36(trainLength+1:end,:);
    class37(trainLength+1:end,:);
    class38(trainLength+1:end,:);
    class39(trainLength+1:end,:);
    class40(trainLength+1:end,:)];


end

