%plot the results of activity classification
f = cell(4,1);
f{1,1} = figure(1);
str = strcat(num2str(numStates),' States,PCA:',num2str(dim),num2str(K),'-fold Cross Validation',num2str(max_iter),'iterations for HMM, ',num2str(mxIter_FPHMM),' iteration for FPHMM');
annotation('textbox',[0.40,0.94,0.175,0.05],'String',str,'FontWeight','bold','color','r');
subplot(2,2,1);
bar(100.*CV_Accuracy_FPHMM_knownEm);
title('FPHMM with Emotion Known','color','b');
legend('Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame','Location','northeastoutside');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

subplot(2,2,2);
bar(100.*CV_Accuracy_FPHMM_unknownEm);
title('FPHMM with Emotion unKnown','color','b');
legend('Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame','Location','northeastoutside');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

subplot(2,2,3);
bar(100.*CV_Accuracy_HMM_knownEm);
title('HMM with Emotion Known','color','b');
legend('Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame','Location','northeastoutside');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

subplot(2,2,4);
bar(100.*CV_Accuracy_HMM_unknownEm);
title('HMM with Emotion unKnown','color','b');
legend('Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame','Location','northeastoutside');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
ax.YTickLabel = {'0','20','40','60','80','100',''};


%% 
f{2,1} = figure(2);
y_value = [CV_Accuracy_HMM_knownEm(:,9), CV_Accuracy_FPHMM_knownEm(:,9),CV_Accuracy_HMM_unknownEm(:,9), CV_Accuracy_FPHMM_unknownEm(:,9)];
bar(100.*y_value);
title('accuracy of four algorithms on activities classfication','color','b');
legend('HMM known Em','FPHMM known Em','HMM unknown Em','FPHMM unknown Em');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'Sitting Down','Move Books','Simple Walk','Walk with smth in the Hands'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

f{3,1} = figure(3);
y_value = [CV_Accuracy_HMM_knownEm(1,10), CV_Accuracy_FPHMM_knownEm(1,10),CV_Accuracy_HMM_unknownEm(1,10), CV_Accuracy_FPHMM_unknownEm(1,10)];
bar(100.*y_value);
title('Total accuracy of four algorithms','color','b');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'HMM known Em','FPHMM known Em','HMM unknown Em','FPHMM unknown Em'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

f{4,1} = figure(4);
y_value = [CV_Accuracy_HMM_knownEm_SW_WH(1,10), CV_Accuracy_FPHMM_knownEm_SW_WH(1,10),CV_Accuracy_HMM_unknownEm_SW_WH(1,10), CV_Accuracy_FPHMM_unknownEm_SW_WH(1,10)];
bar(100.*y_value);
title('accuracy of four algorithms on classification of activities:Simple Walk and WH','color','b');
xlabel('Four Acitivities','color','r');
ylabel('classification accuracy,    %','color','r');
ax = gca;
axis([0,5,0,120]);
ax.XTickLabel = {'HMM known Em','FPHMM known Em','HMM unknown Em','FPHMM unknown Em'};
ax.YTickLabel = {'0','20','40','60','80','100',''};

%% save figures

disp('saving figures...');
for i = 1:length(f)
saveFigPath = '~/Desktop/Recognition Results/';
figName = strcat('ActReg',num2str(numStates),'StatesF',num2str(dim),'PCADim',num2str(max_iter),'mxItr_HMM',num2str(mxIter_FPHMM),'IetrFP',num2str(K),'Folds','_',num2str(i),'.fig');
savefig(f{i,1},strcat(saveFigPath,figName));
end
