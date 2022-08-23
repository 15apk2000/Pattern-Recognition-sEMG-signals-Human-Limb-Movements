% Cross validated arm accuracy      
% Cross validated wrist accuracy    
% Testing arm accuracy              
% Testing wrist accuracy            
% Testing overall accuracy          

close all
clear
clc
    % every col is a feature set
results ...
 = [67.14 79.75 99.80 99.90;   %cv - overall
    79.71 82.31 99.881 99.9921];  %test - overall

results = results/100;

leg = {'Feature Set 1','Feature Set 2','Feature Set 3','Feature Set 4'};                  
x = {'CV','Testing'};

hb = bar(results);

tem = 0:0.001:2;

title('Classification Results','FontSize',15);
set(gca,'xticklabel',x)  
ylim([0 1.2])
yticks(tem(1:50:end))
ylabel('Classification Accuracy %');
grid on
% Get handle to current axes.
ax = gca;
ax.XAxis.FontSize = 10;
legend(hb,leg,'Orientation','horizontal','Location','northeast','FontSize',12,'FontWeight','bold','LineWidth',1.5)
 
hb = flipud(hb); 

% Number of XAxisValues:
numXVals = numel(hb);
% Find the width of a bar
dx = hb(1).BarWidth/numXVals;
% Find the Left Most Edge of each X Values bars
leftEdge = hb(1).XData - hb(1).BarWidth/2;
% Adjust to center of left bar
leftEdge = leftEdge + dx/2;
for k = 1:numXVals
    labelBar(hb(k),dx,leftEdge,k,results(:,k))
end




% hold on
% % Find the number of groups and the number of bars in each group
% ngroups = size(results, 1);
% nbars = size(results, 2);
% % Calculate the width for each bar group
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% % Set the position of each error bar in the centre of the main bar
% % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
% for i = 1:nbars
%     % Calculate center of each bar
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, results(:,i), error(:,i), 'k', 'linestyle', 'none');
% end
% hold off




function labelBar(hb,dx,leftEdge,k,lbl)
      % YData Location
      yLoc = hb.YData;
      % Adjust offset from left edge of bars
      xLoc = leftEdge + (k-1)*dx; % Find position from Left Edge
      txt = num2str(lbl,'%.4f');
      
      text(xLoc,yLoc,txt,...
          'HorizontalAlignment','center',...
          'VerticalAlignment','bottom','FontWeight','bold');
end


