function [ke,fe] = element1D(psi)
    % degree of the polynomial we construct
    d = length(psi)-1;
    ke = struct('k',zeros(d+1),'b',zeros(d+1));
    fe = zeros(d+1,1);
    
    % Calculate quadratures
    n1 = ceil((d+d+1)/2);
    Q1 = quadGaussLegendre(n1);
    n2 = ceil((d+1)/2);
    Q2 = quadGaussLegendre(n2);
    for i = 1:d+1
        for j = 1:i
            % integral of psi(i).der*psi(j).der
            g = conv(psi(i).der,psi(j).der);
            g_gauss = polyval(g,Q1.Points);
            ke.k(i,j) = Q1.Weights'*g_gauss;
            
            % integral of psi(i).fun*psi(j).fun
            f = conv(psi(i).fun,psi(j).fun);
            f_gauss = polyval(f,Q1.Points);
            ke.b(i,j) = Q1.Weights'*f_gauss;
            
            % Update ke due to symmetry
            if i~=j
                ke.k(j,i) = ke.k(i,j);
                ke.b(j,i) = ke.b(i,j);
            end
        end
        % Update fe
        fe(i) = Q2.Weights'*polyval(psi(i).fun,Q2.Points);
    end
end