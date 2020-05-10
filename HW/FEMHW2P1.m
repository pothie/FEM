% HW2 P1
% two elements
clear all
figure()
u_exact = @(x) -x+log(1+x)/log(2);
d = linspace(0,1,1e3);
plot(d,u_exact(d))
hold on

syms x
n = 2;
h = 1/n;
node = (0:n).*h;
pl = (x-node(1))/h; % psi left
pr = (node(3)-x)/h;  % psi right
dpl = diff(pl); %psi' left
dpr = diff(pr); %psi' right
K = int((1+x)*dpl*dpl,x,node(1:2))+int((1+x)*dpr*dpr,x,node(2:3));
F = int(pl,x,node(1:2))+int(pr,x,node(2:3));
alpha2 = K\F
% alpha2 =
% 1/12
plot(node,[0 alpha2 0],":")


% 4 elements
n = 7;
h = 1/n;
node = MESH.Points;%nope
K = zeros(n-1);
F = zeros(n-1,1);
for i = 1:n-1 %row of K
    for j = max(i-1,1):i %column of K
        pl = (x-node(j))/h; % psi with element on the left of node(j+1)
        pr = (node(j+2)-x)/h;  % psi right with element on the right of node(j+1)
        dpl = diff(pl); %psi' left
        dpr = diff(pr); %psi'right
        if i == j
            F(i) = int(pl,x,node(j:j+1))+int(pr,x,node(j+1:j+2));
            K(i,j) = int((1+x)*dpl*dpl,x,node(j:j+1))...
                +int((1+x)*dpr*dpr,x,node(j+1:j+2));
        else
            K(i,j) = int((1+x)*dpl*dpr,x,node(j+1:j+2));
            K(j,i) = K(i,j);
        end
    end
end
alpha4 = full(K\F)
% alpha4 =
%     0.0715
%     0.0845
%     0.0571
plot(node,[0 alpha4' 0],"-.")
legend()

