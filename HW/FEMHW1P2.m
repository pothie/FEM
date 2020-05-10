clear all
syms x
phi(1) = x;
phi(2) = x.^2;
L = 120;

p = phi;
dp = diff(p);
in1 = int(dp'*dp*6,x,[0 L]);
in2 = int(5*p/12,x,[0 L]);
K = double(in1);
F = double(in2)';
N = 3000*[L L^2]';
a = K\(F+N);
u = a'*p';
u = matlabFunction(u);

% a =
%   508.3333
%    -0.0347
% % part i
% u(120)/2
% ans =
%        30250
% % part ii
% u(120)/0.5
% ans =
%       121000
