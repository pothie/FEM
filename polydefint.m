function I = polydefint(p,a,b)

%% POLYDEFINT Definite integral of a polynomial
%    POLYDEFINT(p,a,b)returns the value I of the definite integral of poly-
%    nomial p (in MATLAB®  polynomial form) over the real interval [a,b].      
%
%    See also polyint, polyder
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polydefint/
%

%% Validate input

vp  = @(x)validateattributes(x,{'numeric'},{'real','vector'});
vab = @(x)validateattributes(x,{'numeric'},{'real','scalar'});
ip  = inputParser;
ip.addRequired('p',vp); ip.addRequired('a',vab); ip.addRequired('b',vab);
ip.parse(p,a,b);
ip.Results;

%% Compute the definite integral

I = diff(polyval(polyint(p),[a b]));

end

