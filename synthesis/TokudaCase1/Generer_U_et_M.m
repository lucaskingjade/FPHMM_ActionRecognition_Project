function [ U_1,M ] = Generer_U_et_M( Q,mu,Sigma )
% Generer U^(-1) et M, comme Tokuda(2000) (7)(8), Speech Parameter Generation..
% Input:
% Q : La sequence d'etats 2*T, Q(1,t) = Qt; Q(2,t) = mt  
% mu : dimFeat*nstates*num_gaussians  
% Sigma : dimFeat*dimFeat*nstates*num_gaussians  

% Longueur de la seqeunce Q
 T = size(Q,2);
% DimFeat : Mn
 Mn = size(mu,1);
% Assigner l'espace a U et M
 U_1 = zeros(Mn*T,Mn*T);
 M = zeros(Mn*T,1);

 for t = 1:T
  % Generer U^(-1)
  %-----------------------------------------------------
  if ndims(Sigma) == 3
    Uqtit = Sigma(:,:,Q(1,t),1);
  elseif ndims == 4
    Uqtit = Sigma(:,:,Q(1,t),Q(2,t));
  end
  %-----------------------------------------------------
  kk = (Mn*(t-1)+1):Mn*t;
  %kksize = size(kk)
  %Uqtitsize = size(Uqtit)
  U_1(kk,kk) = Uqtit^(-1);
  % Generer M
  gg = (Mn*(t-1)+1):Mn*t;
  M(gg) = mu(:,Q(1,t),Q(2,t));
 end
end