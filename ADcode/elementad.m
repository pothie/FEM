function [me,ke,fe] = elementad(psi)
    % degree of the polynomial we construct
    d = length(psi)-1;
    me = zeros(d+1);
    ke = struct('k',zeros(d+1),'c',zeros(d+1)); %%% no b term anymore
    fe = zeros(d+1,1);
    
    % Calculate quadratures
    n1 = ceil((d+d+1)/2);
    Q1 = quadGaussLegendre(n1);
    n2 = ceil((d+1)/2);
    Q2 = quadGaussLegendre(n2);
    for i = 1:d+1
        for j = 1:d+1
            % integral of psi(i).der*psi(j).der
            g = conv(psi(i).der,psi(j).der);
            g_gauss = polyval(g,Q1.Points);
            ke.k(i,j) = Q1.Weights'*g_gauss;
            
            % integral of psi(i).fun*psi(j).der
            f = conv(psi(i).fun,psi(j).der); %%%%% psi(j).fun to psi(j).der
            f_gauss = polyval(f,Q1.Points);
            ke.c(i,j) = Q1.Weights'*f_gauss;
            
            psi_i = polyval(psi(i).fun,Q1.Points);
            psi_j = polyval(psi(j).fun,Q1.Points);
            me(i,j) = Q1.Weights'*(psi_i.*psi_j);   
        end
        % Update fe
        fe(i) = Q2.Weights'*polyval(psi(i).fun,Q2.Points);
    end
end