function varargout = polyplot(varargin)

%% POLYPLOT Plots a MATLAB® polynomial
%     POLYPLOT(p) plots the polynomial represented by the row vector p 
%     (assuming standard MATLAB® polynomial form) over the interval [-1,1].
%
%     POLYPLOT(p,I) plots the polynomial p over the interval I = [a,b], 
%     where a and b are real scalar values.
%
%     POLYPLOT( ___ ,LineSpec) sets the line style, marker symbol, and 
%     color.
%
%     POLYPLOT( ___ ,Name,Value) specifies line properties using one or 
%     more Name,Value pair arguments. Use this option with any of the input 
%     argument combinations in the previous syntaxes. 
%
%     h = POLYPLOT( ___ ) returns a column vector of chart line objects. 
%     Use h to modify properties of a specific polynomial plot after it is 
%     created. 
%
%     See also plot, fplot
%
%     Detailed help, with examples, available online at:   
%     http://u.osu.edu/kubatko.3/codes_and_software/polytools/polyplot/
%

%% Validate input

vp = @(x)validateattributes(x,{'numeric'},{'real','vector'});
vI = @(x)validateattributes(x,{'numeric'},{'numel',2,'real'});
ip = inputParser;
ip.addRequired('p',vp); 
ip.addOptional('I',[-1,1],vI);
n = 1;
if nargin >= 2
    if ~ischar(varargin{2})
        n = 2;
    end
end
ip.parse(varargin{1:n});
ip.Results; p = ip.Results.p; I = ip.Results.I;

%% Plot polynomial

X = linspace(I(1),I(2),100); Y = polyval(p,X);
if nargout == 1
    varargout{1} = plot(X,Y,varargin{n+1:end});
else
    plot(X,Y,varargin{n+1:end})
end

end

