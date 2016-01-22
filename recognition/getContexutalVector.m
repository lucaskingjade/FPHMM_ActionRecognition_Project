function [ contextualVector ] = getContexutalVector( emotion,context,emotionCell)
%UNTITLED6 Summary of this function goes here
    if size(emotionCell,2)~=size(context,1)
        fprintf('the length of emotionCell and contextualVector are not equal');
    end
    isExist =0;
    numEm = size(emotionCell,2);
    for i = 1:numEm
        if strcmp(emotion,emotionCell{1,i})
            contextualVector = context{i,1};
            isExist = 1;
        end
    end
    if isExist == 0
        fprintf('\nthe emotion %s doesnt exist in emotionCell\n',emotion);
    end
end

% %   Detailed explanation goes here
% if (strcmp(emotion,'Anger'))
% %     contextualVector = [1.0;0.0;0.0;0.0;0.0;0;0;0];
%     contextualVector = context{1,1};
% % elseif (strcmp(emotion,'Anxiety'))
% % %     contextualVector = [0;1;0;0;0;0;0;0];
% %     contextualVector = context{2,1};
% % 
% % elseif (strcmp(emotion,'Joy'))
% % %     contextualVector = [0;0;1;0;0;0;0;0];
% %     contextualVector = context{3,1};
% % elseif(strcmp(emotion,'Neutral'))
% % %     contextualVector = [0;0;0;1;0;0;0;0];
% %     contextualVector = context{4,1};
% % 
% % elseif(strcmp(emotion,'Panic Fear'))
% % %     contextualVector = [0;0;0;0;1;0;0;0];
% %     contextualVector = context{5,1};
% % 
% % elseif(strcmp(emotion,'Pride'))
% % %     contextualVector = [0;0;0;0;0;1;0;0];
% %     contextualVector = context{6,1};
% % 
% % elseif(strcmp(emotion,'Sadness'))
% % %     contextualVector = [0;0;0;0;0;0;1;0];
% %     contextualVector = context{7,1};
% 
% elseif(strcmp(emotion,'Shame'))
% %     contextualVector = [0;0;0;0;0;0;0;1];
%     contextualVector = context{2,1};

% end


