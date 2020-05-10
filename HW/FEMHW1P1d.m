clear all
syms x
phi(1) = x*(1-x);
phi(2) = x*(1-x)*(1/2-x);
phi(3) = x*(1-x)*(1/3-x)*(2/3-x);
a = zeros(3);
d = linspace(0,1,1e3);
error_x = (1:3)./4;
u_exact = @(x) x/2-x.^2/4-log(1+x)/(4*log(2));
exact = u_exact(error_x);
exact = repmat(exact,3,1);

for i = 1:3
p = phi(1:i);
dp = diff(p);
in1 = int((1+x)*dp'*dp,x,[0 1]);
in2 = int(x*p,x,[0 1]);
K = double(in1);
F = double(in2)';
a(i,1:i) = K\F;
u = a(i,1:i)*p';
u = matlabFunction(u);
error(i,:) = abs(exact(i,:)-u(error_x))./exact(i,:)*100;
plot(d,u(d))
hold on
end

plot(d,u_exact(d))
title("HW1P1d")
legend("N=1","N=2","N=3","Exact");

% a =
%       0.16667            0            0
%       0.16412    -0.038168            0
%       0.16448    -0.039326    -0.019663
% error =
%        8.1578      0.98715       3.9533
%       0.31427      0.55464     0.079153
%       0.08318    0.0057014     0.059845
% 
