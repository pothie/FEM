function Q = quadGaussLegendre(n,varargin)

%% QUADGAUSSLEGENDRE Gauss-Legendre quadrature weights and points
%    Q = quadGaussLegendre(n),  where n is a positive integer, returns the 
%    n-point Gauss-Legendre quadrature rule Q as a stucture with fields 
%    Q.Points and Q.Weights, which store the n points (in ascending order) 
%    and corresponding weights, respectively, of the quadrature rule. An 
%    additional field, Q.Properties, stores the degree, type and interval, 
%    or domain, of the quadrature rule (the default domain is [-1,1]) in 
%    subfields .Degree, .Type and .Domain, respectively. 
%
%    Q = quadGaussLegendre(n,'Domain',[a,b]), same as above, but where the
%    Name, Value pair 'Domain',[a,b] specifies the domain of integration
%    for the quadrature rule. The default domain is the bi-unit interval
%    [-1,1].
%
%    Note: An n-point Gauss-Legendre quadrature rule is of degree 2n-1;  
%    that is, it integrates all polynomial up to degree 2n-1 exactly.
%
%    See also quadGaussJacobi, quadGaussLobatto 
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/quadtools/quadgausslegendre/
%

%% Validate input

vn = @(x)validateattributes(x,{'numeric'},{'scalar','integer','>=',1});
vD = @(x)validateattributes(x,{'numeric'},{'numel',2,'increasing'}); 
ip = inputParser;
ip.addRequired('n',vn); ip.addParameter('Domain',[-1,1],vD)
ip.parse(n,varargin{:}); ip.Results; Domain = ip.Results.Domain;

%% Compute the weights and points

% Define the coefficients of the three-term recurrence relationship
a = @(n)(2*n+1)./(n+1);
b = @(n)0;
c = @(n)n./(n+1);
% Constructe the symmetric tridiagonal matrix
A = -b(0:n-1)./a(0:n-1); B = sqrt(c(1:n-1)./(a(0:n-2).*a(1:n-1)));
J = diag(B,1) + diag(A) + diag(B,-1);     
% Compute the eigenvalues and eigenvectors
[V,D] = eig(J,'vector');
% Save (sorted) points and weights
[Q.Points,I] = sort(D);
Q.Weights = (2*V(1,I).^2)'; 
% Note: The next three lines insure zero is zero and the points and weights 
% are perfectly symmetric
Q.Points(abs(Q.Points)<10*eps) = 0; 
Q.Points(ceil(end/2)+1:end) = -flipud(Q.Points(1:floor(end/2)));
Q.Weights(ceil(end/2)+1:end) = flipud(Q.Weights(1:floor(end/2)));
% Transformation of points and weights if [a,b]~=[-1,1]
if ~isequal(Domain,[-1,1])
    Q.Points  = (Domain(2)-Domain(1))/2*Q.Points + (Domain(1)+Domain(2))/2;
    Q.Weights = (Domain(2)-Domain(1))/2*Q.Weights;
end

%% Assign properties

Q.Properties.Degree = 2*n-1;
Q.Properties.Type   = 'Gauss-Legendre';
Q.Properties.Domain = Domain;

end