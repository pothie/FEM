function [K,F] = Global2D() 
read_2D_mesh
read_2D_input
k = nElems;
n = nNodes;
% calculating shape functions
psi = polyLagrange2D(p);

% calculating ke and fe
[ke,fe] = element2D(psi);
K = sparse(n,n);
F = sparse(n,1);

for i = 1: k
    % retrieve element data: 3 nodes 
    nodelist = MESH.ConnectivityList(i,:);
    coord = MESH.Points(nodelist,:);
    x = coord(:,1);
    y = coord(:,2);
    
    % Find Ae and Jacobian 
    J = abs((x(2)-x(1))*(y(3)-y(1))-(x(3)-x(1))*(y(2)-y(1)));
    Ae = 0.5*J;
    X = [x(2)-x(3);x(3)-x(1);x(1)-x(2)];
    X = X*X';
    Y = [y(2)-y(3);y(3)-y(1);y(1)-y(2)];
    Y = Y*Y';
    ke.k = KofXY(i)/(4*Ae)*(X+Y);
    
    % computing element stiffness matrix and load vector
    kn = ke.k+BofXY(i)*J*ke.b;
    fn = FofXY(i)*J*fe;
    
    % Assembling kn and fn to global K and F
    [K,F] = assemble2D(nodelist,kn,fn,K,F);
end

% Dealing with boundary conditions
% Neumann BC
neuNode = boundaryNodes('Neumann');
if ~isempty(neuNode)
    neuValues = boundaryValues('Neumann');
    F(neuNode) = F(neuNode) - KofXY(neuNode).*neuValues;
end
% Dirichlet BC
[K,F] = enForceBCs2D(boundaryNodes('Dirichlet'),boundaryValues('Dirichlet')...
    ,K,F);

% Plot approximation solution 
sol = K\F;
trimesh(MESH.ConnectivityList,MESH.Points(:,1),MESH.Points(:,2),sol)
end

