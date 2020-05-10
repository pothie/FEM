function [K,F] = Global1D() 
read_1D_mesh
read_1D_input
k = nElems;
n = nNodes;
% calculating shape functions
psi = polyLagrange(p);

% calculating ke and fe
[ke,fe] = element1D(psi);
K = sparse(n,n);
F = sparse(n,1);

for i = 1: k
    % retrieve element data
    nodelist = MESH.ConnectivityList(i,:);
    
    % calculating element size
    hn = MESH.Points(nodelist(2))-MESH.Points(nodelist(1));
    
    % computing element stiffness matrix and load vector
    fn = hn/2*FofX(i)*fe;
    kn = 2/hn*KofX(i)*ke.k+hn/2*BofX(i)*ke.b;
    
    % Assembling kn and fn to global K and F
    [K,F] = assemble1D(nodelist,kn,fn,K,F);
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

% Plot approximation solution in Project 1.1
sol = K\F;
%FEM1DPlot(k,p,sol,MESH.Points);
end

