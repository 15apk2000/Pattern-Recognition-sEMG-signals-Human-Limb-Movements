close all
clear
clc

addpath('/Academics/BTP/codeFinal/featureExtraction/');
addpath('/Academics/BTP/codeFinal/performance/');
addpath('/Academics/BTP/codeFinal/classifiers/');
addpath('/Academics/BTP/codeFinal/db1/');
addpath('/Academics/BTP/codeFinal/db2/');
addpath('/Academics/BTP/codeFinal/db3/');
addpath('/Academics/BTP/codeFinal/db4/');
addpath('/Academics/BTP/codeFinal/db5/');


slidingWindowSize = 200 ;
samplingRate = 4000;
sampleConverter = (1/1000)*samplingRate ;
slidingWindowSize = slidingWindowSize*sampleConverter;

boolPreProcess = 1;
boolFeatureScaling = 1;

% 1 - RMS, WL, AR-4
% 2 - Mean,Var,Skw,Kurt
% 3 - Log(m0),Log(m2),Log(m4),Log(S),Log(IF),Log(WL),Cosine Similarity
% 4 - Max,Std of DWT coeff
% 5 - Log(Hjorth),Log(ICS),LogD,Log(WL),Log(MTW)
% 6 - MAV, VAR, WL, Willison Amp


fSet = 1;

numChannels = 7;
f = {@featureSet1,@featureSet2,@featureSet3,@featureSet4,@featureSet5,@featureSet6};
numFeat = [numChannels*2+5*numChannels,numChannels*4,6*numChannels+nchoosek(numChannels,2),8*numChannels,5*numChannels+3*numChannels+nchoosek(numChannels,2),4*numChannels]; % includes labels
numFeat = numFeat(fSet);

numWindows = ceil(20000/slidingWindowSize);
lenMatrix = numWindows*9*5*8*6;
featureMatrix = zeros(lenMatrix,numFeat+3);
prev = 1;
next = numWindows;

folders = dir;
folders = struct2cell(folders);
folders = folders(1,:);
folders(contains(folders,'.')) = [];



numCV = 4 ;

for iterFolder = 1:9
    
    folderCurrent = folders(iterFolder);
    cd (char(folderCurrent))
    
    files = dir;
    files = files(3:end);
    numFiles = length(files);
    
    for iterFiles = 1:numFiles
        
        filename = files(iterFiles).name;
        disp([char(folders(iterFolder)),'  -  ',char(filename)]);
        
        trial = load(files(iterFiles).name);
        trial = trial(1:2*10^4,:);
        label = getLabel(files(iterFiles).name);
        
        if(boolPreProcess)
            trial = abs(trial);
        end
        
        featureTrial = ...
            getEmgFeatures(trial,label,slidingWindowSize,numFeat,numWindows,fSet,f);
        
        if(boolFeatureScaling)
            featureTrial(:,1:numFeat) = ...
                normalize(featureTrial(:,1:numFeat),'scale');
        end
        
        featureMatrix(prev:next,:) = featureTrial;
        prev=next+1;
        next=next+numWindows;
        
    end
    
    cd ..
end

% shuffle data and divide into validation + testing
trainPercent = 0.3 ;
[featureTrain,featureTest] = ...
    splitFeatureSet(featureMatrix,trainPercent,numFeat);

disp(' Training Classifiers ' );

% train classifiers
[apC,wpC,aMean,aStd] = crossValidateData(featureTrain,numFeat,numCV,fSet);

disp(' Predicting Labels ');

% perform testing
armLabels = apC.predictFcn(featureTest(:,1:numFeat));
wristLabels = wpC.predictFcn(featureTest(:,1:numFeat));

labelsHat = armLabels*10 + wristLabels ;
labelsActual = featureTest(:,numFeat+1);

disp( ' Calculating Confusion Matrices ');

cMat = confusionmat(labelsActual,labelsHat);
confusionchart(cMat,'RowSummary','row-normalized','ColumnSummary','column-normalized');
accuracyN = trace(cMat)/sum(cMat(:));

figure;

cMat1 = confusionmat(wristLabels,featureTest(:,numFeat+3));
% subplot(121)
confusionchart(cMat1,'RowSummary','row-normalized','ColumnSummary','column-normalized');
accuracyW = trace(cMat1)/sum(cMat1(:));

figure;

cMat2 = confusionmat(armLabels,featureTest(:,numFeat+2));
% subplot(122)
confusionchart(cMat2,'RowSummary','row-normalized','ColumnSummary','column-normalized');
accuracyA = trace(cMat2)/sum(cMat2(:));


disp('*-------------------------------------------*');
disp(['* Testing arm accuracy           : ',num2str(num2str(accuracyA*100)),'%','   *']);
disp('*-------------------------------------------*');
disp(['* Testing wrist accuracy         : ',num2str(accuracyW*100),'%','    *']);
disp('*-------------------------------------------*');
disp(['* Testing overall accuracy       : ',num2str(accuracyN*100),'%','   *']);
disp('*-------------------------------------------*');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function label = getLabel(filename)

poslabel = str2double(filename(4));
label = poslabel*10;

filename(1:5) = [];

if(filename(1:9)=="WristFlex")
    category = 1 ;
elseif (filename(1:9)=="WristExte")
    category = 2 ;
elseif (filename(1:9)=="WristPron")
    category = 3 ;
elseif (filename(1:9)=="WristSupi")
    category = 4 ;
elseif (filename(1:9)=="ObjectGri")
    category = 5 ;
elseif (filename(1:9)=="PichGrip_")
    category = 6 ;
elseif (filename(1:9)=="HandOpen_")
    category = 7 ;
elseif (filename(1:9)=="HandRest_")
    category = 8 ;
end

label = [label + category,poslabel,category];

end

function featureTrial = ...
    getEmgFeatures(trial,label,slidingWindowSize,numFeat,numWindows,featureSet,f)


featureTrial = zeros(numWindows,numFeat+3);
cnt = 1;
numWindows = floor(length(trial)/slidingWindowSize);
prev = 1;
next = slidingWindowSize;

for iterWindow = 1:numWindows
    
    if(iterWindow == numWindows)
        next = length(trial);
    end
    
    fFunc = f{featureSet};
    featureTrial(cnt,:) = fFunc(trial(prev:next,:),label); 
    
    cnt = cnt+1;
    prev = next+1;
    next = next + slidingWindowSize;
    
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
