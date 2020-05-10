function r = polycompose(p,q)

%% POLYCOMPOSE Compose two polynomials
%    POLYCOMPOSE(p,q) returns the coefficients of the polynomial r (in 
%    MATLAB® polynomial form) that results from composing polynomial p with 
%    polynomial q(x), i.e., p(q(x)), where p and q are row vectors whose 
%    elements are the coefficients of the polynomials in MATLAB® polynomial 
%    form.        
%
%    See also polyval, polypower, conv, deconv
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polycompose/
%

%% Validate input

vpq = @(x)validateattributes(x,{'numeric'},{'real','vector'});
in  = inputParser;
in.addRequired('p',vpq); in.addRequired('q',vpq);
in.parse(p,q);
in.Results; 

%% Compose the two polynomials

n = length(p); m = length(q);
r = zeros(n,(n-1)*(m-1)+1);
for i = 0:n-1
    poly = p(n-i);
    for j = 1:i
        poly = conv(poly,q);
    end    
    r(i+1,1:length(poly)) = fliplr(poly);
end
r = fliplr(sum(r));

end