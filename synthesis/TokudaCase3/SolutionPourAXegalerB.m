function [ X ] = SolutionPourAXegalerB( A,B,methode )
% Solution : AX = B 
switch methode
    case 'LU'
        % [L,U] = lu(A), LU=A
        % LUX = B
        % UX = L\B
        % X = U\(L\B)
        [L,U] = lu(A);
        T = L\B;
        X = U\T;
        %unable = ;
    case 'Cholesky'
        R = chol(A);
        %[R,p] = chol(A);
        % 确定A是对称正定型
        % R'*R = A
        % R'*R*X = B
        % X = R\(R'\B)
   
      
     


        
        
        T = R'\B;
        X = R\T;
        %unable = p;
    case 'QR'
        % [Q,R] = qr(A), A=QR 
        % QRX = B 
        % RX = Q\B
        % X = R(Q\B)
        [Q,R] = qr(A);
        T = Q\B;
        X = R\T;
        %unable = ;
    case 'Tokuda11'
    case 'Tokuda10'
    otherwise
 end
end

