function psi = polyLagrange2D(p)
    psi = struct('fun',{}); 
    
    % Create a set of equi-spaces points over the master element
    [xi,eta] = meshgrid(0:1/p:1);
    xi = reshape(xi',[],1);
    eta = reshape(eta',[],1);
    I = find(xi+eta<=1);
    xi = xi(I); 
    eta = eta(I);
    N = length(xi);
    
    % Construct the Vandermode matrix associated with this set of points
    k = 1;
    for i = 0:p
        for j = 0:i
            % Compute column k of the Vandermode matrix
            V(:,k) = xi.^(i-j).*eta.^j;
            k = k + 1;
        end
    end
    
    %  For each node, contruct the vector dictating the nodal conditions (the right-hand side vector)
    I = eye(N);
   
    % For each node, solve for the set of coefficients by inverting the Vandermode matrix
    a = zeros(N);
    for i = 1:N
        a(:,i) = V\I(:,i);
    end
    
    for l = 1:N
        psi(l).fun = zeros(p+1);
        k = 1;
        for i = 0:p
            for j = 0:i
                psi(l).fun(end-j,end-(i-j)) = a(k,l);
                k = k+1;
            end        
        end
    end
end