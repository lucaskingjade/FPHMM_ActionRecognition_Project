% y1 = data{1,1}(1,:);
% y2 = data{3,1}(1,:);
% % y2 = data{1,1}(2,:);
% % y3 = data{1,1}(3,:);
% stateSeq1 = likStateSet{1,1}(2,:);
% stateSeq2 = likStateSet{3,1}(2,:);
% x1 = linspace(1,size(y1,2),size(y1,2));
% x2 = linspace(1,size(y2,2),size(y2,2));
% plot(x1,y1,'r');
% hold on;
% plot(x2,y2,'g');
% % hold on;
% % plot(x,y3,'b');
% hold on;
% plot(x1,stateSeq1,'y');
% 
% x3= linspace(1,size(stateSeq2,2),size(stateSeq2,2));
% hold on;
% plot(x3,stateSeq2,'b');
% 
figure
x1= 1:size(likStateSet_contextual{1,1},2);
plot(x1,likStateSet_contextual{1,1}(2,:));
figure
x2= 1:size(likStateSet{1,1},2);

plot(x2,likStateSet{1,1}(2,:));