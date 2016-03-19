function [ U_1_mean,U_1M_mean ] = Tokuda_Case3_Generer_U_1mean_et_U_1Mmean(mu,Sigma,invSigma,mixmat,T,gamma)
% For CHMM
T
% Generer U_1_mean et U_1M_mean, comme Tokuda(2000) (21)(22), Speech Parameter Generation..

% Input:
% mu(dimFeat,Q,m);
% mu(dimFeat,Q,m,t);
% Sigma(dimFeat,dimFeat,Q,m);
% Sigma(dimFeat,dimFeat,Q,m,t);
% gamma(i,t) = p(Q(t)=i | y(1:T))

% DimFeat : Mn
 Mn = size(mu,1);
 Qn = size(mu,2);
 Mixn = size(mu,3);

 % Assigner l'espace pour U_1_mean
 U_1_mean = zeros(Mn*T,Mn*T);
 U_1M_mean = zeros(Mn*T,1);
 gamma_U_1_mu = zeros(Mn,1,Mixn*Qn);
 %-------------------------------------------------
 % SigQ
%  % SigQ(dimFeat,dimFeat,m,Q);
%  SigQ = permute(Sigma,[1 2 4 3]);
%  % U_1(dimFeat,dimFeat,m*Q);
%  U_1 = reshape(SigQ,Mn,Mn,Mixn*Qn);

 %----------------------------------------------
 % invSigma
 % SigQ(dimFeat,dimFeat,m,Q);
 
 %invSigmaOrSigma = 'Sigma';
 invSigmaOrSigma = 'invSigma';
 
 switch invSigmaOrSigma
      case 'Sigma'
        invSigmaOrSigma
        invSigma = permute(Sigma,[1 2 4 3]);
      case 'invSigma'
        invSigmaOrSigma
        %if ndims(invSigma) == 4
           invSigma = permute(invSigma,[1 2 4 3]);
        %elseif ndims(invSigma) == 5
        %   invSigma = permute(invSigma,[1 2 4 3 5]);
        %end
      otherwise
        disp('error in Tokuda_Case3_Generer_U_1mean_et_U_1Mmean')
 end
 
 %if ndims(invSigma) == 4
 % U_1(dimFeat,dimFeat,m*Q);
     U_1 = reshape(invSigma,Mn,Mn,Mixn*Qn);
 %elseif ndims(invSigma) == 5
 %    U_1 = reshape(invSigma,Mn,Mn,Mixn*Qn, T);
 %end
 
 
 
 %%%----------------------------------------------
 %%% mu(dimFeat,dimFeat,m,Q);
 %%% mu(dimFeat,dimFeat,m,Q,t);
 %%%muu = permute(mu,[1 2 4 3]);
 
 %muu = permute(mu,[1 3 2 4]);
 
 %if ndims(mu) == 3
 muu = permute(mu,[1 3 2]);
 
 %%%mu(dimFeat,1,m*Q);
 %muu = reshape(muu,Mn,1,Mixn*Qn,T);
 muu = reshape(muu,Mn,1,Mixn*Qn);
 %elseif ndims(mu) == 4
 %    muu = permute(mu,[1 3 2 4]);
 %    muu = reshape(muu,Mn,1,Mixn*Qn,T);
 %end

 %-------------------------------------------------
 
 for t = 1:T
  %--------------------------------------------------------------------------------------------------
  % Generer U_1mean
  % gamma_colone : ( Q*Mixn ) * 1
  gamma_colone = kron(gamma(:,t),ones(Mixn,1));
  % maxmit_colone : ( Q*Mixn ) * 1
  maxmit_colone = reshape(mixmat',[Mixn*Qn,1]);
  % gamma_maxmit_colone : ( Q*Mixn ) * 1
  gamma_maxmit_colone = gamma_colone.*maxmit_colone; 
  % gamma_maxmit_carre_colone : ( Q*Mixn*Mn ) * Mn
  gamma_maxmit_carre_colone = kron(gamma_maxmit_colone,ones(Mn,Mn));
  % gamma_maxmit_carre_colone : Mn * ( Q*Mixn*Mn )
  gamma_maxmit_carre_colone = gamma_maxmit_carre_colone';
  % gamma_matrix : Mn * Mn * (Qn*Mixn)
  gamma_matrix = reshape(gamma_maxmit_carre_colone,Mn,Mn,Qn*Mixn);
  % U_1_gamma : Mn * Mn * (Qn*Mixn)
  U_1_gamma = U_1.* gamma_matrix;
  kk = (Mn*(t-1)+1):Mn*t;
  ggg = sum(U_1_gamma,3);
  U_1_mean(kk,kk) = ggg;
  %--------------------------------------------------------------------------------------------------
  
  %--------------------------------------------------------------------------------------------------
  % Generer U_1M_mean
  MQ = Mixn*Qn;
  for mi = 1:MQ
      gamma_U_1_mu(:,:,mi) = U_1_gamma(:,:,mi) * muu(:,:,mi);
      % gamma_U_1_mu(:,:,mi) = U_1_gamma(:,:,mi) * muu(:,1,mi,t);  CHMM
  end
  U_1M_mean(kk) = sum(gamma_U_1_mu,3);
  %--------------------------------------------------------------------------------------------------
  
 end

end
