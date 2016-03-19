%%this file is created by WANG Qi on 06 Jan,2016.
%it is a scripts file for plotting the learned thetas and the
%initialization values of thetas.

    tmpThetasCell = FPHMMCell{1,1}{8,1};
    numIteration = size(tmpThetasCell,1);
    numEm = size(tmpThetasCell,2);
    figure;
    for i = 1:numEm
        
        tmpMat = zeros(numIteration-1,theta_dim);
%         tmpMat(1,:) = initTheta{indFold,1}{i,1}';
        
        for j = 2:numIteration
            tmpMat(j-1,:) = tmpThetasCell{j,i}';
        end
%         figure;
        if theta_dim ==2
            plot(tmpMat(:,1),tmpMat(:,2),'b--o');
            str = ['\leftarrow ' emotionCell{1,i}];
            text(tmpMat(4,1),tmpMat(4,2),str,'Color','blue','FontSize',14);
        else
        plot3(tmpMat(:,1),tmpMat(:,2),tmpMat(:,3),'b--o');
        
        str = ['\leftarrow ' emotionCell{1,i}];
        text(tmpMat(4,1),tmpMat(4,2),tmpMat(4,3),str,'Color','blue','FontSize',14);
%         str1 = '\rightarrow initial point';
%         text(tmpMat(1,1),tmpMat(1,2),tmpMat(1,3),str1,'Color','blue','FontSize',14);
        end
        hold on;
        
    end
    hold off;
%         axis([min(tmpMat(:,1))-0.2,max(tmpMat(:,1))+0.2,min(tmpMat(:,2)-0.2,max(tmpMat(:,2))+0.2),2]);
