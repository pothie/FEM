clear all
syms x
phi(1) = sin(pi*x);
phi(2) = sin(2*pi*x);
phi(3) = sin(3*pi*x);
a = zeros(3);
d = linspace(0,1,1e3);
error = zeros(3);
error_x = (1:3)./4;
u_exact = @(x) x/2-x.^2/4-log(1+x)/(4*log(2));
exact = u_exact(error_x);

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
    error(i,:) = abs(exact-u(error_x))./exact*100;
    plot(d,u(d))
    hold on
end

plot(d,u_exact(d))
title("HW1P1c")
legend("N=1","N=2","N=3","Exact");

% a =
%      0.043002            0            0
%      0.042342   -0.0021973            0
%      0.042434   -0.0018922    0.0014154
%      
% error = (x=0.25     x=0.5        x=0.75)
%        5.2402       4.2237       6.5442
%        3.9793       2.6249       1.2243
%       0.76519      0.58366        1.113
% 
