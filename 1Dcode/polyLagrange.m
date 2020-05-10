% FEM HW2 P3
function psi = polyLagrange(k)

    %initialize the structure
    psi = struct('fun',{},'der',{}); 
    
    %calculating the nodes
    node = linspace(-1,1,k+1); 
    
    %jth row is the values of Lagrange polynomial of j at (xi_j)
    I = eye(k+1);  
    
    for i = 1:k+1
        % Lagrange polynomial
        psi(i).fun = polyfit(node,I(i,:),k);
        
        % derivatives
        psi(i).der = polyder(psi(i).fun);
    end
end

% test = polyLagrange(3)
% test = 
%   1×4 struct array with fields:
%     fun
%     der
% test.fun
% ans =
%    -0.5625    0.5625    0.0625   -0.0625
% ans =
%     1.6875   -0.5625   -1.6875    0.5625
% ans =
%    -1.6875   -0.5625    1.6875    0.5625
% ans =
%     0.5625    0.5625   -0.0625   -0.0625