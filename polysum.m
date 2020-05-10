function p = polysum(polys,varargin)

%% POLYSUM 
%    POLYSUM(polys) returns the polynomial resulting from summing the poly-
%    nomials of the input argument polys, which is a cell array where each 
%    cell is a row vector representing a polynomial. The vectors contained 
%    in the cell array polys need not be the same length.
%
%    POLYSUM(polys,coeffs) same as above but where the i-th entry of the 
%    vector coeffs of length n (where n equals the number of cells in cell 
%    array polys) multiplies the corresponding i-th row vector (polynomial) 
%    of cell array poly, i.e., a linear combination of the polynomials is 
%    taken.
%
%    See also polyval, polypower, conv, deconv
%
%    Detailed help, with examples, available online at:   
%    http://u.osu.edu/kubatko.3/codes_and_software/polytools/polysum/
%

%% Validate input

vp = @(x)validateattributes(x,{'cell'},{'2d','real'});
vc = @(x)validateattributes(x,{'numeric'},{'vector','numel',length(polys)});
ip  = inputParser;
ip.addRequired('polys',vp); ip.addOptional('coeffs',ones(length(polys)),vc);
ip.parse(polys,varargin{:});
ip.Results; coeffs = ip.Results.coeffs;

polyclass = cellfun(@class,polys,'UniformOutput',0);
if sum(strcmp(polyclass(:),'double'))~=length(polys)
    error('Entries of input cell array must be numeric!')
end

%% Sum the polynomials

n = max(cellfun('length',polys)); 

p = zeros(1,n);
for i = 1:length(polys)
    p = p + coeffs(i)*[ zeros(1,n-length(polys{i})), polys{i} ];
end

end