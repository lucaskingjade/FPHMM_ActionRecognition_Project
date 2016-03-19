function [ v_sequence ] = Syn_Tokuda_case3_Sequence( data,hmm )

prior      = hmm.pi0;
transmat   = hmm.A;
mu         = hmm.mu;
Sigma      = hmm.Sigma;
mixmat     = hmm.mixmat;

invSigma = zeros(size(Sigma));
for i=1:size(mu,2)
    s = Sigma(:,:,i);
    s = s^(-1);
    invSigma(:,:,i) = s;
end

Mn = size(data,1);
T  = size(data,2);
W = Wcreated(T,Mn/3);
% inputSeq to C
C = data(1:Mn/3,:);
% Step0 : initialization
sequence_initialization = data;

% Step1 : calculation gamma
B = mixgauss_prob(sequence_initialization, mu, Sigma, mixmat);
[alpha, beta, gamma, loglik, xi_summed, gamma2] = fwdback(prior, transmat, B);            

% gamma(i,t) = p(Q(t)=i | y(1:T))
% mu(:,Q);
% mu(dimfeat,Q,mixmat);

% Step2 : calculation  U_1_mean et U_1M_mean
iteration = 1;
while iteration == 1 || abs(loglik-loglik0) > 10
    
    loglik0 = loglik;
  
    iteration = iteration+1;
    
    [U_1_mean,U_1M_mean] = Tokuda_Case3_Generer_U_1mean_et_U_1Mmean( mu,Sigma,invSigma, mixmat,T,gamma );
    
    % Generer A, A = W'*U_1mean*W
    A = W'*U_1_mean*W;
 
    % Generer B, B = W'*U_1M_mean
    B = W'*U_1M_mean;

    % Solution pour AX = B
    methode = 'Cholesky';

%     disp('size(A) = ')
%     size(A)
%     disp('size(B) = ')
%     size(B)
%     
%     disp('size(W) = ')
%     size(W)
    disp('size(U_1M_mean) = ')
    size(U_1M_mean)
    
    C = SolutionPourAXegalerB( A,B,methode );
 
    O = W*C;

    B = mixgauss_prob(sequence_initialization, mu, Sigma, mixmat);
   [alpha, beta, gamma, loglik, xi_summed, gamma2] = fwdback(prior, transmat, B); 
 
end

v_sequence = reshape(C,Mn/3,T);

end


