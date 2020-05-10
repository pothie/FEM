function T = polyChebyshev(n,varargin)

%% POLYCHEBYSHEV Generate Chebyshev polynomial
%     Tn = POLYCHEBYSHEV(n), where n is a non-negative integer, returns the
%     n-th degree Chebyshev polynomial of the first kind in MATLAB® poly-
%     nomial form.
%
%     Tn = POLYCHEBYSHEV(n,K), where n is a non-negative integer, returns 
%     the n-th degree Chebyshev polynomial of the first (K = 1, default) or 
%     second (K = 2) kind in MATLAB® polynomial form.
%    
%    See also polyLegendre, polyJacobi 
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polychebyshev/
%

%% Validate input

in = inputParser;
vn = @(x)validateattributes(x,{'numeric'},{'scalar','integer','>=',0});
vK = @(x)validateattributes(x,{'numeric'},{'scalar','integer','<',3,'>',0});
in.addRequired('n',vn); in.addOptional('K',1,vK);  
in.parse(n,varargin{:});
in.Results; K = in.Results.K; 

%% Construct the Chebyshev polynomials

T = zeros(1,n+1);
for r = 0:floor(n/2)
    T(2*r+1) = (-1)^r*2^(n-2*r)/((n-r)^(2-K))*nchoosek(n-r,r);
end
T = (n/2)^(2-K)*T; T(end) = min(T(end),1);

end