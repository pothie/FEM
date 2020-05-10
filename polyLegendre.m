function P = polyLegendre(n,varargin)
 
%% POLYLEGENDRE Generates Legendre polynomials
%    Pn = polyLegendre(n), where n is a non-negative integer, returns the 
%    coefficients of the n-th degree Legendre polynomial in MATLAB® poly-
%    nomial form.    
%
%    See also polyChebyshev, polyJacobi
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polylegendre/
%

%% Validate input

ip = inputParser;
vn = @(x)validateattributes(x,{'numeric'},{'vector','integer','>=',0});
vs = @(x)validateattributes(x,{'numeric'},{'scalar','positive'});
vI = @(x)validateattributes(x,{'numeric'},{'numel',2,'real'});
ip.addRequired('n',vn); 
ip.addOptional('s',1,vs); ip.addOptional('I',[-1,1],vI);
ip.parse(n,varargin{:});
ip.Results; s = ip.Results.s; I = ip.Results.I;
if nargin == 2
    I = [-s,s];
end

%% Construct the Legendre polynomials 

A = @(n)(2*n+1)/(n+1);
B = @(n)0;
C = @(n)n/(n+1);

P = cell([1,n+1]);
P{1} = [ zeros(1,n), 1];
P{2} = [ zeros(1,n-1), A(0), B(0)];
for i = 2:n
    AB = conv([A(i-1), B(i-1)],P{i});
    P{i+1} = AB(2:end) - C(i-1)*P{i-1};
end
if isscalar(n)
    P = P{n+1};
end

end