function [accuracy,precision,recall,specificity,f1score,kappa,cMat] = performanceMetrics(labels,labelsHat)

% Suppose there are three classes: C1, C2, and C3
% "TP of C1" is all C1 instances that are classified as C1.
% "TN of C1" is all non-C1 instances that are not classified as C1.
% "FP of C1" is all non-C1 instances that are classified as C1.
% "FN of C1" is all C1 instances that are not classified as C1.


cMat = confusionmat(labels,labelsHat);
numClasses = size(cMat,1);
f1score = zeros(numClasses,1);
precision = zeros(numClasses,1);
recall = zeros(numClasses,1);
specificity = zeros(numClasses,1);
accuracy = zeros(numClasses,1);


for iterClass = 1:numClasses
    
    tp = cMat(iterClass,iterClass);
    tn = trace(cMat)-tp;
    fp = sum(cMat(:,iterClass))-tp;
    fn = sum(cMat(iterClass,:))-tp;    
    
    accuracy(iterClass) = (tp)/(tp+fp);
    recall(iterClass) = tp/(tp+fn);
    precision(iterClass) = tp/(tp+fp);
    specificity(iterClass) = tn/(tn+fp);
    f1score(iterClass) = 2/(recall(iterClass)^-1 + precision(iterClass)^-1);
end

n = sum(cMat(:)); % get total N
cMat = cMat./n; % Convert confusion matrix counts to proportion of n
r = sum(cMat,2); % row sum
s = sum(cMat); % column sum
expected = r*s; % expected proportion for random agree
po = sum(diag(cMat)); % Observed proportion correct
pe = sum(diag(expected)); % Proportion correct expected
kappa = (po-pe)/(1-pe); % Cohen's kappa

end



