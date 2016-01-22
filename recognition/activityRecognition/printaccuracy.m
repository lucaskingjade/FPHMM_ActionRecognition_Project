%print accuracy
disp('HMM');
fprintf('%.2f%%\n',CV_Accuracy_HMM_knownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_HMM_knownEm(1,1)*100);
fprintf('%.2f%%\n',CV_Accuracy_HMM_unknownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_HMM_unknownEm(1,1)*100);
disp('FPHMM');
fprintf('%.2f%%\n',CV_Accuracy_FPHMM_knownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_FPHMM_knownEm(1,1)*100);

fprintf('%.2f%%\n',CV_Accuracy_FPHMM_unknownEm(1,10)*100);
fprintf('%.2f%%\n',CV_Variance_FPHMM_unknownEm(1,1)*100);

fprintf('%d+%d iteration FPHMM',FPHMM_HMM_init_Iter,mxIter_FPHMM);
