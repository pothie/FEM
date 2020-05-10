syms x
n = (1:10)';%1e3;
alpha = 2*(-1).^(n+1)./(n.^3*pi^3);
y = alpha'*sin(n*pi*x);
u = matlabFunction(y);
d = linspace(0,1,1e3);
plot(d,u(d))

