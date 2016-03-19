close all
clear all
clc

load('hmm.mat');
numState = size(hmm.A,1);
T = 20;
stateSequence = 1+(numState-1).*rand(1, T);
stateSequence = round(stateSequence);
stateSequence = [stateSequence; % 1st row is state sequeqnce, each element < numState
                 ones(size(stateSequence))];% 2nd row is index of mixture
% in stateSequence, 1st row is state sequeqnce, each element < numState;
% 2nd row is index of mixture, in our hmm example, mixture number = 1;
             
             
methode = 'Cholesky';
trajectory = Tokuda_Case1( hmm,stateSequence,methode );
% trajectory is the output of Tokuda's algorithm, here it represents
% 4-dimensional data stream, which is showed in the following figure.

figure
subplot(4,1,1)
plot(trajectory(1,:), 'r--');
subplot(4,1,2)
plot(trajectory(2,:), 'r--');
subplot(4,1,3)
plot(trajectory(3,:), 'r--');
subplot(4,1,4)
plot(trajectory(4,:), 'r--');