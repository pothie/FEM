function P = polyJacobi(n,a,b)

%% POLYJACOBI Generates Jacobi polynomials
%     Pn = POLYJACOBI(n,a,b), where n is a non-negative integer and a and b 
%     are real constants > -1, returns the n-th degree Jacobi polynomial in 
%     MATLAB® polynomial form.  
%
%    See also polyChebyshev, polyLegendre
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polyjacobi/
%

%% Validate the input

ip  = inputParser;
vn  = @(x)validateattributes(x,{'numeric'},{'scalar','integer','nonnegative'});
vab = @(x)validateattributes(x,{'numeric'},{'scalar','real','>',-1});
ip.addRequired('n',vn); ip.addRequired('a',vab); ip.addRequired('b',vab); 
ip.parse(n,a,b);
ip.Results; 

%% Construct the Jacobi polynomials

A = @(n)(2*n+a+b+1)*(2*n+a+b+2)/(2*(n+1)*(n+a+b+1));
B = @(n)(a^2-b^2)*(2*n+a+b+1)/(2*(n+1)*(n+a+b+1)*(2*n+a+b));
C = @(n)(n+a)*(n+b)*(2*n+a+b+2)/((n+1)*(n+a+b+1)*(2*n+a+b));

P = cell([1,n+1]);
P{1} = [ zeros(1,n), 1];
P{2} = [ zeros(1,n-1), 1/2*(a+b)+1, 1/2*(a-b)];
for i = 2:n
    AB = conv([A(i-1), B(i-1)],P{i});
    P{i+1} = AB(2:end) - C(i-1)*P{i-1};
end
if isscalar(n)
    P = P{n+1};
end

end