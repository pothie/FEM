function [L,pt] = Globalad() 
read_1D_mesh
read_1D_input
k = nElems;
n = nNodes;
% calculating shape functions
psi = polyLagrange(p);

% calculating ke and fe
[me,ke,fe] = elementad(psi);%%%%%%% changed function
K = sparse(n,n);
F = sparse(n,1);
M = sparse(n,n);
% change alpha in the upwind parameter
alpha = 0.23;

for i = 1: k
    % retrieve element data
    nodelist = MESH.ConnectivityList(i,:);
    
    % calculating element size
    hn = MESH.Points(nodelist(2))-MESH.Points(nodelist(1));
    
    % computing element stiffness matrix and load vector
    fn = hn/2*FofX(i)*fe;    
    kn = (KofX(i)+1/2*alpha*hn)*(2/hn)^2*ke.k+2/hn*ke.c;
    
    % Assembling kn and fn to global K and F
    [K,F,M] = assemblead(nodelist,kn,fn,me,K,F,M);
end

% Dealing with boundary conditions
% Neumann BC
neuNode = boundaryNodes('Neumann');
if ~isempty(neuNode)
    neuValues = boundaryValues('Neumann');
    F(neuNode) = F(neuNode) - KofX(i)*neuValues;
end
% Dirichlet BC
[K,F] = enForceBCs(boundaryNodes('Dirichlet'),boundaryValues('Dirichlet')...
    ,K,F);

L = -M\K;
pt = MESH.Points;

% sol = K\F;
% plot(pt,sol) % comment out in Problem 3
end