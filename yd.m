omegacell = cell(5,1);
for i = 1:20
    omegacell{i,1} = [rand(3,1).*10+i;1];
end
sum =zeros(4,4);
omega_omega = [];
for i = 1:20
    for t = 1:10
        %omega_omega = rand(1,1)*omegacell{i,1}*omegacell{i,1}';
        omega_omega = omegacell{i,1}*omegacell{i,1}';
        omega_omega = rand(1,1)*omega_omega;
        sum =sum + omega_omega;
    end
end
% disp(sum);
inv = sum^(-1
