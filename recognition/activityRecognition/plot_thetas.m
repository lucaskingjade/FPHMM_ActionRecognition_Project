%%this file is created by WANG Qi on 06 Jan,2016.
%it is a scripts file for plotting the learned thetas and the
%initialization values of thetas.
K = size(K_CV_FPHMMCell,1);
numActivity = size(K_CV_FPHMMCell{1,1},1);
numEmotion = size(K_CV_FPHMMCell{1,1}{1,1}{7,1},1);
learned_theta_values = zeros(numEmotion,2);
emotionCell = {'Anger','Anxiety','Joy','Neutral','Panic Fear','Pride','Sadness','Shame'};

disp('plot the initialized thetas....')



for indFold = 1:K
    for indAct = 1:numActivity
        for indEm = 1:numEmotion
            learned_theta_values(indEm,:) = K_CV_FPHMMCell{indFold,1}{indAct,1}{7,1}{indEm,1};
        end
    end
    figure
    scatter(learned_theta_values(:,1),learned_theta_values(:,2),'ro');
    axis([-2,2,-2,2]);
    
    for indEm = 1:numEmotion
        str = emotionCell{indEm};
        x0 = learned_theta_values(indEm,1)+0.03;
        y0 = learned_theta_values(indEm,2);
        text(x0,y0,str,'HorizontalAlignment','left','FontSize',12,'Color','Blue');
    end
    
    
    
end

