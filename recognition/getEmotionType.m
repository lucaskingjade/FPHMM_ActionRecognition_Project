function [ emotion ] = getEmotionType( fileName )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if size(strfind(fileName(1:2),'Ag'),1) ~= 0
    emotion ='Anger';
elseif (size(strfind(fileName(1:2),'Ax'),1) ~= 0)
    emotion ='Anxiety';
elseif (size(strfind(fileName(1:2),'Jy'),1) ~= 0)
    emotion ='Joy';
elseif (size(strfind(fileName(1:2),'Nt'),1) ~= 0)
    emotion ='Neutral';
elseif (size(strfind(fileName(1:2),'PF'),1) ~= 0)
    emotion ='Panic Fear';
elseif (size(strfind(fileName(1:2),'Pr'),1) ~= 0)
    emotion ='Pride';
elseif (size(strfind(fileName(1:2),'Sd'),1) ~= 0)
    emotion ='Sadness';
elseif (size(strfind(fileName(1:2),'Sh'),1) ~= 0)
    emotion ='Shame';
    
else
    emotion = 'wangqi'
    disp('file name isnt correct!!!!!!');
end

end

