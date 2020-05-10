clear all
w0 = 38.4;
L = 10;
f = @(x) w0/2*x*(10-x); %f(x)
k = 1; %k(x)
b = 0; %b(x)
error = zeros(3,1);
app = zeros(3,1); % approximation at midspan deflection

% loop through 2,4,8 elements with equal length
for m = 1:3
    nE = 2^m;
    nN = nE+1;
    
    % alter input.1d
    fid = fopen('input.1d','w');
    fprintf(fid,'%s \n','k(x)=1, f(x)=w0/2*x(10-x), u(0)=0; u(10)=0 ');
    % element data
    mid = L/(2*nE)+L/nE*(0:nE-1);
    for j = 1:nE
        fprintf(fid,'%d %d %d %d\n',j,k,b,f(mid(j)));
    end
    fprintf(fid,'%d %d\n%d %d\n',1,0,nN,0);
    fclose(fid);

    % alter mesh.1d
    fid = fopen('mesh.1d','w');
    fprintf(fid,'%d %s \n',nE,'element mesh, RBC = D, LBC = D');
    fprintf(fid,'%d %d\n',nE,nN);
    % node number and node list
    xN = linspace(0,L,nN);
    for j = 1:nN
        fprintf(fid,'%d %d\n',j,xN(j));
    end
    % element and connectivity list
    for j = 1:nE
        fprintf(fid,'%d %d %d\n',j,j,j+1);
    end
    % BC: two Dirchlet BC with values = 0
    fprintf(fid,'%d\n%d\n%d\n%d\n',2,1,nN,0);
    fclose(fid);

    % 1D finite element code
    [K,F] = Global1D();
    
    % error
    exact = 5*38.4*10^4/384; %exact delta
    y = K\F;
    app(m) = y(ceil(length(y)/2));
    error(m) = abs(app(m)-exact)/exact*100; % in percentage
end

% app =
%          4500 
%          4875
%        4968.8

% error = (in percentage)
%            10
%           2.5
%         0.625

% part 1) mid deflection using two linear element: 4500
% part 2) relative error: 10%
% part 3) refined mesh size: 2^3 = 8

