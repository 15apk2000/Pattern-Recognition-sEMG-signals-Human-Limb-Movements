% nina-pro db4 data-base
% using restimulus and re-repititions
% 
% num-classes = 52 (12+17+23)
% Hand Rest State - 1 class
% Exercise 2 - 12 classes
% Exercise 1 - 17 classes 
% Exercise 3 - 23 classes
% 
% DOI: 10.1038/sdata.2014.53 ( refer to it )
% 
% 
% using corrected labels - restimulus and rerepitition
% 
% Feature Sets - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% 1 - MAV,ZC,SSC,WL
% 2 - Mean,Var,Skw,Kurt
% 3 - RMS,AR
% 4 - Log(m0),Log(m2),Log(m4),Log(S),Log(IF),Log(WL),Cosine Similarity
% 5 - Max,Std of DWT coeff
% 6 - Log(Hjorth),Log(ICS),LogD,Log(WL),Log(MTW)
% - - - - - - - - - - - - - - - - - - - - - - - - - - - -- - - - - - - -
% 
% Labels ( 1-12 - EA) , (13-29 - EB), (30-52 - EC)
%      1 - Thumb upflexion ofthe others
%      2 - Extension of index and middle
%      3
%      4
%      5
%      6
%      7
%      8
%      9
%     10
%     11
%     12
%     13
%     14
%     15
%     16
%     17
%     18
%     19
%     20
%     21
%     22
%     23
%     24
%     25
%     26
%     27
%     28
%     29
%     30
%     31
%     32
%     33
%     34
%     35
%     36
%     37
%     38
%     39
%     40
%     41
%     42
%     43
%     44
%     45
%     46
%     47
%     48
%     49
%     50
%     51
%     52
%
%
% -------------------------------------------------------------------------
    
close all
clear
clc

tic

addpath('/Academics/btp/data/featureExtraction/');
addpath('/Academics/btp/data/performance/');
addpath('/Academics/btp/data/classifiers/db1/');

slidingWindowSize = 200 ; % in ms
samplingRate = 2000; 
sampleConverter = (1/1000)*samplingRate ;
slidingWindowSize = slidingWindowSize*sampleConverter;

boolPreProcess =1;
boolFeatureScaling = 1;
f = {@featureSet1,@featureSet2,@featureSet3,@featureSet4,@featureSet5,@featureSet6};
fSet = 3;

numChannels = 12;
numFeat = [numChannels*2+5*numChannels,numChannels*4,6*numChannels+nchoosek(numChannels,2),8*numChannels,5*numChannels+3*numChannels+nchoosek(numChannels,2),4*numChannels]; % includes labels
numFeat = numFeat(fSet);

folders = dir;
folders = struct2cell(folders);
folders = folders(1,:);
folders(contains(folders,'.')) = [];
numFolder = length(folders);
numSubj = 6;

trainRep = [ 1 3 4 6]; 
testRep = [2 5];
featureSubj = zeros(82082,numFeat+2);

p=0;
n=0;

for iterSubj = 1:numSubj
   
    folderCurrent = folders(iterSubj);
    cd (char(folderCurrent))
    files = dir;
    files = files(3:end);
    numFiles = length(files);
    
    for iterFiles = 1:numFiles
        
        filename = files(iterFiles).name;
        disp(['processing  : ' ,char(folders(iterSubj)),'  -  ',char(filename)]);
        load(filename)
        
        
        if(boolPreProcess)
            emg = abs(emg);
        end
                
        prev=1;
        next=slidingWindowSize;
        
        
        if(exercise==2)
            restimulus(restimulus~=0) = restimulus(restimulus~=0)+12;
        elseif(exercise==3)
            restimulus(restimulus~=0) = restimulus(restimulus~=0)+29;
        end
        
        dim = size(emg);
        featureMatrix = zeros(floor(dim(1)/slidingWindowSize),numFeat+2);
        
        for iter = 1:length(featureMatrix)
            
            segment = emg(prev:next,:);
            label = mode(restimulus(prev:next));
            rep = mode(rerepetition(prev:next,:));
            label = [label,rep];
            fFunc = f{fSet};
            featureSegment = fFunc(segment,label);   

            featureMatrix(iter,:) = featureSegment;            
            prev=next+1;
            next=next+slidingWindowSize;
%             disp(['Computing Feature : ',num2str(iter)]);
        end
        p=n+1;
        n=length(featureMatrix)+n;
                    
            % feature scaling
            if(boolFeatureScaling)
                featureMatrix(:,1:numFeat) = ...
                normalize(featureMatrix(:,1:numFeat),'scale');
            end
        
        
        featureSubj(p:n,:) = featureMatrix;
    end
    cd ..
end

toc

disp('Split Data-Set');
% split data-set into train and test
[featureTrain,featureTest] = splitFeatureSet(featureSubj,numFeat,trainRep,testRep);

disp('Performing Cross Validation');
% cross validation
numCV = 10;
[model,cvAcc,cvStd] = crossValidateData(featureTrain,numFeat,numCV,fSet); 

disp('Testing');
% testing
labelsHat = wpC.predictFcn(featureTest(:,1:numFeat));
labelsActual = featureTest(:,numFeat+1);

disp( 'Calculating Performance Metrics');
% performance evaluation
[accuracy,precision,recall,specificity,f1score,kappa,cMat] = ...
    performanceMetrics(labels,labelsHat);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


