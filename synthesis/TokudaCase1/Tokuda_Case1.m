function [X] = Tokuda_Case1( hmm,Q,methode )
% Maximize P(O|Q,HMM)

% Trois method + deux Tokuda
% methode = 'LU';
% methode = 'Cholesky';
% methode = 'QR';

% Mn : le numbre de caracteristique ? statique
Mn = size(hmm.mu,1);
% 假设 : weights((state,)k)
% 假设 : mu(:,(state,)k)
mu = hmm.mu;
% 假设 : Sigma(:,:,(state,)k)
Sigma = hmm.Sigma;

invSigma = zeros(size(Sigma));
for i=1:size(mu,2)
    s = Sigma(:,:,i);
    s = s^(-1);
    invSigma(:,:,i) = s;
end

% 确定T为横向量
T = size(Q,2);
% Generer W : 3MnT*MnT

% W = Wcreated(T,Mn/3);
W = NewWcreated(T,Mn/3);

% Generer U : 3MT*3MT
% et
% Generer M : 3MT*1
% 注意M : 3MT*1　在文章中可能有误
[ U_1,M ] = Generer_U_et_M( Q,mu,invSigma );
% Generer A, A = W'U^(-1)W
A = W'*U_1*W;
% Generer B, B = W'U^(-1)M
B = W'*U_1*M;
% Solution pour AX = B
X = SolutionPourAXegalerB( A,B,methode );
X = reshape(X,Mn/3,T);
end






                  % mu : dims * nb_etat * nb_gaussian
                  % Sigma : dims * dims * nb_etat * nb_gaussian

