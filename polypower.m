function q = polypower(p,k)

%% POLYPOWER Raises polynomial p to the (non-negative integer) power of k
%    POLYPOWER(p,k) returns the polynomial q (in MATLAB® polynomial form) 
%    that results from raising polynomial p to a non-negative integer power 
%    of k.    
%
%    See also power, realpow, conv
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polypower/
%

%% Validate input

vp = @(x)validateattributes(x,{'numeric'},{'real','vector'});
vk = @(x)validateattributes(x,{'numeric'},{'scalar','nonnegative'});
ip = inputParser;
ip.addRequired('p',vp); ip.addRequired('k',vk);
ip.parse(p,k);
ip.Results; 

%% Raise polynomial to the power of k

q = 1;
for i = 1:k
    q = conv(p,q);
end

end