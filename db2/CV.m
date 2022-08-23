close all
clear
clc

addpath('/Academics/btp/data/featureExtraction/');
addpath('/Academics/btp/data/performance/');
addpath('/Academics/btp/data/classifiers/db2/');

% Feature Sets - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% 1 - MAV,ZC,SSC,WL
% 2 - Mean,Var,Skw,Kurt
% 3 - RMS,AR
% 4 - Log(m0),Log(m2),Log(m4),Log(S),Log(IF),Log(WL),Cosine Similarity
% 5 - Max,Std of DWT coeff
% 6 - Log(Hjorth),Log(ICS),LogD,Log(WL),Log(MTW)
% - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - -
% Labels
% class 1 - Thumb (T)
% class 2 - Index (I)
% class 3 - Middle (M)
% class 4 - Ring (R)
% class 5 - Little (L)
% class 6 - Thumb-Index (T-I)
% class 7 - Thumb-Middle (T-M)
% class 8 - Thumb-Ring (T-R)
% class 9 - Thumb-Little (TL)
% class 10 - Hand close (HC)
% - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - -

slidingWindowSize = 200 ;
samplingRate = 4000;
sampleConverter = (1/1000)*samplingRate ;
slidingWindowSize = slidingWindowSize*sampleConverter;

boolPreProcess =1;
boolFeatureScaling = 1;



f = {@featureSet1,@featureSet2,@featureSet3,@featureSet4,@featureSet5,@featureSet6};
fSet = 6;

numChannels = 8;
numFeat = [numChannels*2+5*numChannels,numChannels*4,6*numChannels+nchoosek(numChannels,2),8*numChannels,5*numChannels+3*numChannels+nchoosek(numChannels,2),4*numChannels]; % includes labels
numFeat = numFeat(fSet);

numWindows = ceil(20000/slidingWindowSize);
numSubj = 6;
numTrials = 3;
numClasses = 15;
lenMatrix = numWindows*numClasses*numSubj*numTrials;
featureMatrix = zeros(lenMatrix,numFeat+1);
prev = 1;
next = numWindows;

folders = dir;
folders = struct2cell(folders);
folders = folders(1,:);
folders(contains(folders,'.')) = [];
numFolder = length(folders);


numCV = 8 ;

for iterFolder = 1:numFolder
    
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
trainPercent = 0.9 ;
[featureTrain,featureTest] = ...
    splitFeatureSet(featureMatrix,trainPercent,numFeat);

disp(' Training Classifiers ' );

% train classifiers
[wpC,aMean,aStd] = crossValidateData(featureTrain,numFeat,numCV,fSet);

disp(' Predicting Labels ');

% perform testing
labelsHat = wpC.predictFcn(featureTest(:,1:numFeat));

labelsActual = featureTest(:,numFeat+1);

disp( ' Calculating Confusion Matrices ');

cMat = confusionmat(labelsActual,labelsHat);
confusionchart(cMat,'RowSummary','row-normalized','ColumnSummary','column-normalized');
accuracyN = trace(cMat)/sum(cMat(:));

disp(['* Testing overall accuracy       : ',num2str(accuracyN*100),'%','   *']);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function category = getLabel(filename)

if(filename(1:3)=="T_T")
    category = 1 ;
elseif (filename(1:3)=="I_I")
    category = 2 ;
elseif (filename(1:3)=="M_M")
    category = 3 ;
elseif (filename(1:3)=="R_R")
    category = 4 ;
elseif (filename(1:3)=="L_L")
    category = 5 ;
elseif (filename(1:3)=="T_I")
    category = 6 ;
elseif (filename(1:3)=="T_M")
    category = 7 ;
elseif (filename(1:3)=="T_R")
    category = 8 ;
elseif (filename(1:3)=="T_L")
    category = 9 ;
elseif (filename(1:3)=="I_M")
    category = 10 ; 
elseif (filename(1:3)=="M_R")
    category = 11 ; 
elseif (filename(1:3)=="R_L")
    category = 12 ; 
elseif (filename(1:3)=="IMR")
    category = 13 ; 
elseif (filename(1:3)=="MRL")
    category = 14 ; 
elseif (filename(1:3)=="HC_")
    category = 15 ; 
end

end

function featureTrial = ...
    getEmgFeatures(trial,label,slidingWindowSize,numFeat,numWindows,featureSet,f)


featureTrial = zeros(numWindows,numFeat+1);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

