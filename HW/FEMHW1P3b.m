clear all
syms x
phi(1) = x*(1-x);
phi(2) = x*(1-x)*(1/2-x);
a = zeros(2);
d = linspace(0,1,1e3);

p = phi(1:2);
dp = diff(p);
in1 = int(dp'*dp,x,[0 1]);
in2 = int(x*p,x,[0 1]);
K = double(in1);
F = double(in2)';
a = K\F
a =
    0.2500
   -0.1667
