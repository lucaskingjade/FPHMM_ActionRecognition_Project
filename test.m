% 
% sum_sum = zeros(size(gammaSet{1,1},1),1);
% for i =1:size(gammaSet,1)
%     for j = 1:size(gammaSet{i,1},1)
%         sum_sum(j) = sum_sum(j)+sum(gammaSet{i,1}(j,:));
%     end
%  end
% 

figure;
x1 = 1:size(likStateSet_contextual{9,1},2);
plot(x1,likStateSet_contextual{9,1}(2,:),'b');
hold on
x2 = 1:size(likStateSet_contextual{10,1},2);
plot(x2,likStateSet_contextual{10,1}(2,:),'r');
hold on 
x3 = 1:size(likStateSet_contextual{6,1},2);
plot(x3,likStateSet_contextual{6,1}(2,:),'g');
figure;
x1 = 1:size(likStateSet{9,1},2);
plot(x1,likStateSet{9,1}(2,:),'b');
hold on
x2 = 1:size(likStateSet{10,1},2);
plot(x2,likStateSet{10,1}(2,:),'r');
hold on 
x3 = 1:size(likStateSet{6,1},2);
plot(x3,likStateSet{6,1}(2,:),'g');