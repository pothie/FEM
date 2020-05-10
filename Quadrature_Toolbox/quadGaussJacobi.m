function Q = quadGaussJacobi(n,alpha,beta)

%% QUADGAUSSJACOBI Gauss-Jacobi quadrature weights and points
%   Q = QUADGAUSSJACOBI(n,alpha,beta), where n is a positive integer and 
%   alpha and beta are real constants > -1, returns the n-point, 
%   (alpha,beta)-weighted Gauss-Jacobi quadrature rule Q as a stucture with 
%   fields Q.Points and Q.Weights, which store the n points (in ascending 
%   order), and corresponding weights, respectively, of the quadrature 
%   rule. An additional field, Q.Properties, stores the degree, type and 
%   interval, or domain, of the quadrature rule in subfields .Degree, .Type 
%   and .Domain, respectively. 
%
%   Note: An n-point Gauss-Jacobi quadrature rule is of degree 2n-1; that 
%   is, it integrates all polynomial up to degree 2n-1 exactly.
%
%   Functional dependencies: quadGaussLegendre
%
%   See also quadGaussLegendre, quadGaussLobatto 
%
%   Detailed help, with examples, available online at:   
%   http://u.osu.edu/kubatko.3/codes_and_software/quadtools/quadgaussjacobi/
%

%% Validate input

vn  = @(x)validateattributes(x,{'numeric'},{'scalar','integer','positive'});
vab = @(x)validateattributes(x,{'numeric'},{'scalar','real','>',-1});
ip  = inputParser;
ip.addRequired('n',vn); 
ip.addRequired('alpha',vab); ip.addRequired('beta',vab);
ip.parse(n,alpha,beta);
ip.Results;

%% Compute the weights and points

% Check for the Legendre case (alpha
if isequal([alpha,beta],[0,0])
    Q = quadGaussLegendre(n); 
    return
else
    N = 1:n-1; ab = alpha + beta;
    % Define the coefficients of the three-term recurrence relationship
    a(1) = 1/2*ab+1;
    b(1) = 1/2*(alpha-beta);
    a(2:n) = (2*N+ab+1).*(2*N+ab+2)./(2*(N+1).*(N+ab+1)); 
    b(2:n) = (alpha^2-beta^2)*(2*N+ab+1)./(2*(N+1).*(N+ab+1).*(2*N+ab)); 
    c(2:n) = (N+alpha).*(N+beta).*(2*N+ab+2)./((N+1).*(N+ab+1).*(2*N+ab));
    % Constructe the symmetric tridiagonal matrix 
    A = -b(1:n)./a(1:n); B = sqrt(c(2:n)./(a(1:n-1).*a(2:n)));
    J = diag(B,1) + diag(A) + diag(B,-1);    
    % Compute the eigenvalues and eigenvectors
    [V,D] = eig(J,'vector');    
    % Save (sorted) points and weights
    [Q.Points,I] = sort(D);
    Q.Weights = (V(1,I).^2*2^(alpha+beta+1).*exp(gammaln(alpha+1)+...
        gammaln(beta+1)-gammaln(alpha+beta+2)))';
end

%% Assign properties
Q.Properties.Degree = 2*n-1;
Q.Properties.Type = ['Gauss-Jacobi (',...
    num2str(alpha),',',num2str(beta),')'];
Q.Properties.Domain = [-1 1];

end