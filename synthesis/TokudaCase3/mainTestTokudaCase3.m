close all
clear all
clc

% mixgauss_prob.m and fwdback.m can be deleted, if they have been included
% in paths. They are copied from the HMM toolbox ~\m_HMM\KPMstats and ~\m_HMM\HMM 

load('hmm.mat');
numState = size(hmm.A,1);
T = 50;

% here two methods can be found to construct intial data.  
%===== initial data 1 =====%
%initialData = zeros(size(hmm.mu,1), T);
%===== initial data 2 =====%
randomState = 1; % randomState is random variable in range of 1:numState;
initialData = repmat(hmm.mu(:,randomState),1,T);

[trajectory] = Syn_Tokuda_case3_Sequence( initialData,hmm );

figure
subplot(4,1,1)
plot(trajectory(1,:), 'r--');
subplot(4,1,2)
plot(trajectory(2,:), 'r--');
subplot(4,1,3)
plot(trajectory(3,:), 'r--');
subplot(4,1,4)
plot(trajectory(4,:), 'r--');
